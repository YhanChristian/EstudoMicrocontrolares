/* Curso Formação IoT ESP32
   Módulo: ESP-32 com FreeRTOS (Arduino Core)
   Exemplo 10: Conexão Socket HTTPS envio de dados da porta analógica a cada 60s
   Autor: Yhan Christian Souza Silva - data: 07/01/2021
   Descrição: Este Projeto tem por objetivo criar duas tasks no FreeRTOS.
             Uma task enviará um dado de um potenciometro e exibir o último valor transmitido no
             display OLED, utilizando filas nas Tasks 
*/

/* Inclusão de Bibliotecas */

#include <Arduino.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include "cJSON.h"
#include <driver/adc.h>
#include "esp_system.h"
#include "esp_adc_cal.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

/* Bibliotecas LoRa e Display OLED */

#include "heltec.h"

/* Defines e Hardware */

#define WIFI_SSID "Seu SSID"
#define WIFI_PASS "Sua Senha"
#define BAUD_RATE 9600
#define DEBUG 0

/* Instância Objetos */

WiFiMulti wifiMulti;

/* Protótipo das Tasks */

void vTaskSendDataHTTP(void *pvParameters);
void vTaskPrintSerial(void *pvParameters);
void vTaskLeituraADC(void *pvParameters);
void vTaskAtualizaDisplay(void *pvParameters);

/* Protótipo Função Auxiliares */

void prvConfigSerial();
void prvConfigWiFi();
void prvConfigOLED();
void vPrintString(const char *pcString);
void vPrintStringAndFloat(const char *pcString, float ulValue);
void vPrintStringAndInteger(const char *pcString, uint32_t ulValue);
void vPrintTwoStrings(const char *pcString1, const char *pcString2);
bool vJsonConverter(String &payload, float *result);

/* Variavéis Globais e Handle Filas */

portMUX_TYPE myMutex = portMUX_INITIALIZER_UNLOCKED;
QueueHandle_t xQueueOled;
QueueHandle_t xQueueADC;

/* Setup */

void setup()
{

  /* Inicia Comunicação Serial */

  prvConfigSerial();

  /*Inicia Config WiFi */

  prvConfigWiFi();

  /*Inicia Disp OLED  */

  prvConfigOLED();

  /*Criação de filas e teste */

  xQueueOled = xQueueCreate(5, sizeof(float));

  if (xQueueOled == NULL)
  {
    while (true)
    {
      vPrintString("Queue OLED error");
    }
  }

  xQueueADC = xQueueCreate(1, sizeof(int));

  if (xQueueADC == NULL)

  {
    while (true)
    {
      vPrintString("Queue ADC error");
    }
  }

  /*Criação das Tasks */

  xTaskCreatePinnedToCore(
      vTaskSendDataHTTP,               /*task*/
      "task1",                         /*identificação task*/
      configMINIMAL_STACK_SIZE + 8192, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      2,                               /*prioridade*/
      NULL,                            /*handle*/
      PRO_CPU_NUM);                    /*core 2*/

  xTaskCreatePinnedToCore(
      vTaskPrintSerial,                /*task*/
      "task 2",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 5000, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      1,                               /*prioridade*/
      NULL,                            /*handle*/
      APP_CPU_NUM);                    /*core 1*/

  xTaskCreatePinnedToCore(
      vTaskLeituraADC,                /*task*/
      "task 3",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      3,                               /*prioridade*/
      NULL,                            /*handle*/
      APP_CPU_NUM);                    /*core 1*/

  xTaskCreatePinnedToCore(
      vTaskAtualizaDisplay,             /*task*/
      "task 4",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      1,                               /*prioridade*/
      NULL,                            /*handle*/
      APP_CPU_NUM);                    /*core 1*/
}

/* Loop */

void loop()
{
  vTaskDelay(100 / portTICK_PERIOD_MS);
}

/* Implementação Tasks */

void vTaskSendDataHTTP(void *pvParameters)
{
  float value;
  int adc_result;

  UBaseType_t uxHighWaterMark;
  uxHighWaterMark = uxTaskGetStackHighWaterMark(NULL);
  BaseType_t xStatus;

  if (DEBUG)
    vPrintString("Task1 Init...");

  for (;;)
  {

    xStatus = xQueueReceive(xQueueADC, &adc_result, 0);
    if (xStatus != pdPASS)
    {
      continue;
    }

    if ((wifiMulti.run() == WL_CONNECTED))
    {

      HTTPClient http;

      http.begin("https://www.geniot.io/things/services/api/v1/variables/S00/value/?token=SEUTOKEN"); //HTTPS
      http.addHeader("Content-Type", "application/json");
      http.addHeader("Connection", "close");

      String dta = String(adc_result);

      if (DEBUG)
        vPrintStringAndInteger("ADC:", adc_result);

      int httpCode = http.POST("{\"value\":" + dta + "}");

      if (httpCode > 0)
      {

        if (DEBUG)
          vPrintStringAndInteger("HTTP_CODE_RETURN:", httpCode);

        if (httpCode == HTTP_CODE_OK)
        {
          String payload = http.getString();

          if (DEBUG)
            vPrintString(payload.c_str());

          if (vJsonConverter(payload, &value) == true)
          {
            xStatus = xQueueSendToBack(xQueueOled, &value, portMAX_DELAY);
            if (xStatus != pdPASS)
            {

              if (DEBUG)
                vPrintString("Fila cheia.");
            }
          }
        }
      }
      else
      {

        if (DEBUG)
          vPrintTwoStrings("[HTTP] POST.. falha, error: %s\n", http.errorToString(httpCode).c_str());
      }

      http.end();
    }

/*Verifica espaço disponível STACK */ 

    if (DEBUG)
    {
      uxHighWaterMark = uxTaskGetStackHighWaterMark(NULL);
      vPrintStringAndInteger("Task1 Stack-Size: ", uxHighWaterMark);
    }

  /*Aguarda 60s para novo envio  */
    vTaskDelay(60000 / portTICK_PERIOD_MS);

  }
}

void vTaskPrintSerial(void *pvParameters)
{
  if (DEBUG)
    vPrintString("Task2 Init...");
  for (;;)
  {
    vTaskDelay(500 / portTICK_PERIOD_MS);
  }
}

void vTaskLeituraADC(void *pvParameters)
{

  BaseType_t xStatus;
  int value;
  if (DEBUG)
    vPrintString("Task4 Init...");

  for (;;)
  {

#define V_REF 1100 // ADC reference voltage
    adc1_config_width(ADC_WIDTH_12Bit);
    adc1_config_channel_atten(ADC1_CHANNEL_0, ADC_ATTEN_11db);
    // Calculate ADC characteristics i.e. gain and offset factors
    esp_adc_cal_characteristics_t characteristics;
    esp_adc_cal_get_characteristics(V_REF, ADC_ATTEN_11db, ADC_WIDTH_12Bit, &characteristics);
    // Read ADC and obtain result in mV
    value = adc1_to_voltage(ADC1_CHANNEL_0, &characteristics);

    //if( DEBUG )
    vPrintStringAndInteger("Task 4 ADC:", value);

    xStatus = xQueueSendToBack(xQueueADC, &value, portMAX_DELAY);
    if (xStatus != pdPASS)
    {

      if (DEBUG)
        vPrintString("Fila cheia.");
    }
    vTaskDelay(2000 / portTICK_PERIOD_MS);
  }
}

void vTaskAtualizaDisplay(void *pvParameters)
{

  float lReceivedValue;
  BaseType_t xStatus;

  if (DEBUG)
    vPrintString("Task3 Init...");

  for (;;)
  {

    xStatus = xQueueReceive(xQueueOled, &lReceivedValue, portMAX_DELAY);
    if (xStatus == pdPASS)
    {

      Heltec.display->clear();
      Heltec.display->drawString(0, 0, String(lReceivedValue));
      Heltec.display->display();
    }

    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

/* Implementação Funções Auxiliares */

void prvConfigSerial()
{
  Serial.begin(BAUD_RATE);
  for (uint8_t t = 4; t > 0; t--)
  {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(500);
  }
}

void prvConfigWiFi()
{
  wifiMulti.addAP(WIFI_SSID, WIFI_PASS);
}

void prvConfigOLED()
{
  Heltec.display->init();
  Heltec.display->flipScreenVertically();
  Heltec.display->setFont(ArialMT_Plain_16);
}

void vPrintString(const char *pcString)
{
  portEXIT_CRITICAL(&myMutex);
  {
    Serial.println((char *)pcString);
  }
  portEXIT_CRITICAL(&myMutex);
}

//Atenção Modificado para imprimir FLOAT com duas casas após a vírgula

void vPrintStringAndFloat(const char *pcString, float ulValue)
{
  portEXIT_CRITICAL(&myMutex);
  {
    char buffer[50];
    sprintf(buffer, "%s %.2f", pcString, ulValue);
    Serial.println((char *)buffer);
  }
  portEXIT_CRITICAL(&myMutex);
}

void vPrintStringAndInteger(const char *pcString, uint32_t ulValue)
{
  portEXIT_CRITICAL(&myMutex);
  {
    char buffer[50];
    sprintf(buffer, "%s %lu", pcString, ulValue);
    Serial.println((char *)buffer);
  }
  portEXIT_CRITICAL(&myMutex);
}

void vPrintTwoStrings(const char *pcString1, const char *pcString2)
{
  portENTER_CRITICAL(&myMutex);
  {
    char buffer[50];
    sprintf(buffer, "%s %s", pcString1, pcString2);
    Serial.println((char *)buffer);
  }
  portEXIT_CRITICAL(&myMutex);
}

bool vJsonConverter(String &payload, float *result)
{
  bool retorno = false;
  cJSON *json = cJSON_Parse(payload.c_str());
  if (json != NULL)
  {
    const cJSON *lastvalue = NULL;
    lastvalue = cJSON_GetObjectItem(json, "last_value");
    if ((lastvalue->valuestring != NULL))
    {
      if (DEBUG)
        vPrintTwoStrings("last_value: ", lastvalue->valuestring);

      cJSON *json_value = cJSON_Parse(lastvalue->valuestring);
      if (json_value != NULL)
      {
        const cJSON *value = NULL;
        value = cJSON_GetObjectItem(json_value, "value");
        *result = value->valuedouble;
        retorno = true;

        cJSON_Delete(json_value);
      }
    }
    cJSON_Delete(json);
  }
  else
  {
    retorno = false;
  }
  return retorno;
}