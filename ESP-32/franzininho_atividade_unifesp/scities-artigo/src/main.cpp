/**
 ******************************************************************************
 * @Company    : Lucas Barros | Yhan Christian
 * @file       : main.cpp
 * @author     : Lucas Barros | Yhan Christian
 * @date       : 06/04/2023
 * @brief      : Arquivo main.cpp com todos os requisitos do projeto para
 *               leitura de especificações acessar o arquivo ESPEC.txt
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include <Arduino.h>
#include <WiFi.h>
#include <WiFiManager.h>
#include <Adafruit_Sensor.h>
#include <ArduinoJson.h>
#include <DHT.h>
#include <MQUnifiedsensor.h>
#include <PubSubClient.h>

/* Define --------------------------------------------------------------------*/
#define BAUD_RATE 115200
#define LED_CONNECTED 33
#define LED_BROKER_CON 21
#define SENSOR_CO 1
#define SENSOR_CO2 2
#define DHT_PIN 44
#define DHT_TYPE DHT22

/*Configurações Sensores MQ2 e MQ135*/
/*Necessária Definições por conta Lib MQ Unified sensor*/
#define BOARD ("ESP-32")
#define VOLTAGE_RESOLUTION 3.3
#define TYPE_1 "MQ-2"
#define TYPE_2 "MQ-135"
#define ADC_BIT_RESOLUTION 12

/*RS/R0 = 9.83ppm*/
#define RATIO_MQ2_CLEAR_AIR 9.83

/*RS/R0 = 3.6ppm*/
#define RATIO_MQ135_CLEAR_AIR 3.6

/*Limites Leitura PPM*/
#define PPM_MINIMO 0
#define PPM_MAX 10000

/*Falha Leitura Sensor*/
#define ERRO_LEITURA -99

/*Tópico MQTT Envio DAdos Sensores*/
#define MQTT_SCITIES_TOPIC "scities/sensores/topic"

/*Tamanho do buffer JSON Dados*/
#define BUFFER_SIZE 255

/* Typedef -------------------------------------------------------------------*/

typedef struct
{
  uint32_t ulChipID;
  float fTemperatura;
  float fUmidade;
  float fMonoxidoPPM;
  float fDioxidoPPM;
  bool bFalhaLeitura;
} st_dados_sensores;

/* Public objects ------------------------------------------------------------*/
st_dados_sensores gstSensores;
DHT dht(DHT_PIN, DHT_TYPE);
WiFiClient client;
PubSubClient MQTT(client);
MQUnifiedsensor MQ2(BOARD, VOLTAGE_RESOLUTION, ADC_BIT_RESOLUTION, SENSOR_CO, TYPE_1);
MQUnifiedsensor MQ135(BOARD, VOLTAGE_RESOLUTION, ADC_BIT_RESOLUTION, SENSOR_CO2, TYPE_2);

/* Global Variables ----------------------------------------------------------*/

/*Intervalos de tempo millis()*/
const uint16_t guiWiFiConnInterval = 250;
const uint16_t guiBrokerConnInterval = 1000;

/*1000ms = 1s * 60s = 1min * x = xmin*/
const uint32_t gulPublishDataInterval = (1000 * 60 * 10);

/*Avisos Erro Inicialização Sensor MQ*/
const char *gpszWarningR0Aberto = "W: problema de conexão, R0 é infinito (circuito aberto detectado), "
                                  "verifique as conexões e fonte de alimentação";

const char *gpszWarningR0Curto = "W: problema de conexão encontrado, R0 é zero (curto-circuito do pino analógico para o terra), "
                                 "verifique as conexões e fonte de alimentação";

/*Credenciais Conexão WiFi*/
const char *gpszSSID = "WiFi SSID";
const char *gpszPass = "WiFi Password";

/*Credenciais MQTT*/
const char *gpszMQTTClient = "Client Name";
const char *gpszMQTTServer = "IP ou Hostname Servidor";
const int giMQTTPort = 1883;
const char *gpszMQTTUser = "User Login";
const char *gpszMQTTPass = "User Password";

/* Function Prototypes -------------------------------------------------------*/

void IniciaGPIOs();
int16_t iIniciaSensoresGas();
void ConectaWiFi();
void ReconectaWiFi();
void ConectaBroker();
void ReconectaBroker();
int16_t iLeituraDHT();
int16_t iLeituraGas();
void PublicaDadosMQTT();

/* Setup ---------------------------------------------------------------------*/
void setup()
{
  /*Variaveis no Escopo Setup*/
  int i = 0;
  int16_t iSt = ESP_OK;

  /*Inicia GPIOs*/
  IniciaGPIOs();

  Serial.begin(BAUD_RATE);
  Serial.println(VERSION);
  Serial.setDebugOutput(true);

  /*Inicia Sensores MQ e Calibra os mesmos*/
  iSt = iIniciaSensoresGas();
  if (iSt)
  {
    Serial.println("Falha na inicialização sensores MQ - verifique o log");
  }

  /*Conexão WiFi*/
  ConectaWiFi();

  memset(&gstSensores, 0x00, sizeof(gstSensores));

  /*Obtem O ID Esp32*/
  for (i = 0; i < 17; i = i + 8)
  {
    gstSensores.ulChipID |= ((ESP.getEfuseMac() >> (40 - i)) & 0xff) << i;
  }
}

/* Loop ----------------------------------------------------------------------*/
void loop()
{
  /*Verfica Conexão WiFi*/
  ReconectaWiFi();

  /*Verifica Conexão Broker MQTT*/
  ReconectaBroker();

  /*Realiza leitura Sensores e publica dados Broker*/
  PublicaDadosMQTT();

  /*Keep Alive MQTT*/
  MQTT.loop();
}

/* Bodies of functions -------------------------------------------------------*/

void IniciaGPIOs()
{
  /*Variáveis controle*/
  float calcR0 = 0;
  int i = 0;

  /*Led Indicação Conexão WiFi*/
  pinMode(LED_CONNECTED, OUTPUT);
  digitalWrite(LED_CONNECTED, LOW);

  /*Led Indicação Conexão Broker MQTT*/
  pinMode(LED_BROKER_CON, OUTPUT);
  digitalWrite(LED_BROKER_CON, LOW);

  /*Inicia o Sensor DHT22*/
  dht.begin();
}

int16_t iIniciaSensoresGas()
{
  /*Variáveis Ajuste Calibração*/
  float fCalcR0 = 0;
  int i = 0;
  int16_t iSt = ESP_OK, iSt2 = ESP_OK;

  /*Configuração Sensores MQ2 e MQ135
    e realiza calibração inicial*/
  /*
    Exponential regression MQ2:
    Gas    | a      | b
    H2     | 987.99 | -2.162
    LPG    | 574.25 | -2.222
    CO     | 36974  | -3.109
    Alcohol| 3616.1 | -2.675
    Propane| 658.71 | -2.168
  */
  MQ2.setRegressionMethod(1); //_PPM =  a*ratio^b
  MQ2.setA(36974);
  MQ2.setB(-3.109);
  MQ2.init();

  Serial.print("Calibrando Sensor MQ2");

  for (i = 1; i <= 10; i++)
  {
    // Update data, the esp32 will read the voltage from the analog pin
    MQ2.update();
    fCalcR0 += MQ2.calibrate(RATIO_MQ2_CLEAR_AIR);
    Serial.print(".");
  }
  MQ2.setR0(fCalcR0 / 10);
  Serial.println("  finalizado!.");

  /*Verifica se há erros conexão*/
  if (isinf(fCalcR0))
  {
    Serial.println(gpszWarningR0Aberto);
    iSt = ESP_FAIL;
  }
  if (fCalcR0 == 0)
  {
    Serial.println(gpszWarningR0Curto);
    iSt = ESP_FAIL;
  }

  MQ2.serialDebug(true);

  /*
    Exponential regression:
  GAS      | a      | b
  CO       | 605.18 | -3.937
  Alcohol  | 77.255 | -3.18
  CO2      | 110.47 | -2.862
  Toluen  | 44.947 | -3.445
  NH4      | 102.2  | -2.473
  Aceton  | 34.668 | -3.369
  */
  MQ135.setRegressionMethod(1); //_PPM =  a*ratio^b
  MQ135.setA(110.47);
  MQ135.setB(-2.862);
  MQ135.init();

  Serial.print("Calibrando Sensor MQ135");
  for (i = 1; i <= 10; i++)
  {
    MQ135.update(); // Update data, the arduino will read the voltage from the analog pin
    fCalcR0 += MQ135.calibrate(RATIO_MQ135_CLEAR_AIR);
    Serial.print(".");
  }
  MQ135.setR0(fCalcR0 / 10);
  Serial.println("  finalizado!.");

  /*Verifica se há erros conexão*/
  if (isinf(fCalcR0))
  {
    Serial.println(gpszWarningR0Aberto);
    iSt2 = ESP_FAIL;
  }

  if (fCalcR0 == 0)
  {
    Serial.println(gpszWarningR0Curto);
    iSt2 = ESP_FAIL;
  }

  MQ135.serialDebug(true);

  Serial.println("Init MQ2 iSt = " + String(iSt) + " Init MQ135 iSt2 = " + String(iSt2));

  if (iSt)
  {
    return iSt;
  }
  if (iSt2)
  {
    return iSt2;
  }
  return ESP_OK;
}

void ConectaWiFi()
{
  unsigned long ulUltimoMillis = 0;
  WiFi.mode(WIFI_STA);
  WiFi.begin(gpszSSID, gpszPass);

  /*Aguarda Conexão Piscando LED*/
  while (WiFi.status() != WL_CONNECTED)
  {
    if ((unsigned long)millis() - ulUltimoMillis >= guiWiFiConnInterval)
    {
      digitalWrite(LED_CONNECTED, !digitalRead(LED_CONNECTED));
      ulUltimoMillis = (unsigned long)millis();
    }
  }

  /* Mantém Led ligado indicando conexão */
  digitalWrite(LED_CONNECTED, HIGH);

  Serial.println();
  Serial.print("Conectado IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  Serial.println("Rede Conectada: " + String(gpszSSID));
}

void ReconectaWiFi()
{
  if (WiFi.status() == WL_CONNECTED)
  {
    return;
  }
  /*Chama função conecta WiFi caso perca Conexão*/
  ConectaWiFi();
}

void ConectaBroker()
{
  Serial.println("Conectando ao Broker MQTT");
  MQTT.setServer(gpszMQTTServer, giMQTTPort);

  while (!MQTT.connected())
  {
    static unsigned long ulLastMillis = 0;
    if ((millis() - ulLastMillis) >= guiBrokerConnInterval)
    {
      digitalWrite(LED_BROKER_CON, !digitalRead(LED_BROKER_CON));
      Serial.print(".");
      if (MQTT.connect(gpszMQTTClient, gpszMQTTUser, gpszMQTTPass))
      {
        Serial.println();
        Serial.println("Conectado ao client: " + String(gpszMQTTClient));
        break;
      }
      Serial.println("Falha Conexão Broker MQTT");
      Serial.println("Nova tentativa em 1s");
      ulLastMillis = millis();
    }
  }

  /*Mantém LED Aceso indicando conexão*/
  digitalWrite(LED_BROKER_CON, HIGH);
}

void ReconectaBroker()
{
  if (MQTT.connected())
  {
    return;
  }

  /* Chama função para conexão Broker MQTT */
  ConectaBroker();
}

int16_t iLeituraDHT()
{
  float fTempAux, fUmiAux;
  fTempAux = dht.readTemperature();
  fUmiAux = dht.readHumidity();

  if (isnan(fTempAux) || isnan(fUmiAux))
  {
    gstSensores.fTemperatura = ERRO_LEITURA;
    gstSensores.fUmidade = ERRO_LEITURA;
    return ESP_FAIL;
  }

  gstSensores.fTemperatura = fTempAux;
  gstSensores.fUmidade = fUmiAux;
  Serial.print("Temperatura: " + String(gstSensores.fTemperatura));
  Serial.println(" Umidade: " + String(gstSensores.fUmidade));
  return ESP_OK;
}

int16_t iLeituraGas()
{
  int16_t iSt = ESP_OK, iSt2 = ESP_OK;
  float fMonoxidoAux, fDioxidoAux;

  /*Realiza Leitura MQ2 e verifica erro*/
  MQ2.update();
  fMonoxidoAux = MQ2.readSensor();
  MQ2.serialDebug();

  if (fMonoxidoAux <= PPM_MINIMO || fMonoxidoAux > PPM_MAX)
  {
    gstSensores.fMonoxidoPPM = ERRO_LEITURA;
    iSt = ESP_FAIL;
  }
  else
  {
    gstSensores.fMonoxidoPPM = fMonoxidoAux;
  }

  /*Realiza Leitura MQ135 e verifica erro*/
  MQ135.update();
  fDioxidoAux = MQ135.readSensor();
  MQ135.serialDebug();
  if (fDioxidoAux <= PPM_MINIMO || fDioxidoAux > PPM_MAX)
  {
    gstSensores.fDioxidoPPM = ERRO_LEITURA;
    iSt2 = ESP_FAIL;
  }
  else
  {
    gstSensores.fDioxidoPPM = fDioxidoAux;
  }

  /*Log de status leitura*/
  Serial.println("Read MQ2 iSt = " + String(iSt) + " Read MQ135 iSt2 = " + String(iSt2));

  /*Verifica e retorna erro de leitura caso um dos sensores falhar*/
  if (iSt)
  {
    return iSt;
  }
  if (iSt2)
  {
    return iSt2;
  }
  return ESP_OK;
}

void PublicaDadosMQTT()
{
  int16_t iSt = ESP_OK, iSt2 = ESP_OK;
  char buffer[BUFFER_SIZE];
  static unsigned long ulUltimaPub = gulPublishDataInterval;

  if ((unsigned long)millis() - ulUltimaPub >= gulPublishDataInterval)
  {
    memset(buffer, '\0', sizeof(buffer));

    /*Leitura Temp*/
    iSt = iLeituraDHT();

    /*Leitura Sensores MQ2*/
    iSt2 = iLeituraGas();

    if (iSt || iSt2)
    {
      gstSensores.bFalhaLeitura = true;
    }
    else
    {
      gstSensores.bFalhaLeitura = false;
    }

    /*Atualiza Buffer para Publish MQTT*/
    snprintf(buffer, sizeof(buffer), "{\"id\":\"%x\",\"temperatura\":\"%.2f\",\"umidade\":\"%.2f\","
                                     "\"co2\":\"%.2f\",\"co\":\"%.2f\",\"falha_leitura\":\"%d\"}",
             gstSensores.ulChipID, gstSensores.fTemperatura, gstSensores.fUmidade,
             gstSensores.fDioxidoPPM, gstSensores.fMonoxidoPPM, gstSensores.bFalhaLeitura);

    /*Publica Dados Broker*/
    Serial.println(buffer);
    MQTT.publish(MQTT_SCITIES_TOPIC, buffer);
    ulUltimaPub = (unsigned long)millis();
  }
}

/*****************************END OF FILE**************************************/