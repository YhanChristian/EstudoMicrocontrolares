/*Libs include */

#include "mqtt.h"

/* Libs to MQTT connect and post to TAGOIO*/
#include <stdio.h>
#include <Arduino.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include "ArduinoJson.h"

/* Defines */

#define WIFI_SSID "Seu SSID"
#define WIFI_PASS "Sua Senha"

#define MQTT_SERVER "mqtt.tago.io"
#define MQTT_PORT 1883

#define MQTT_USER "Qualquer nome"
#define MQTT_PASS "Seu token TAGO.IO (verifique ao criar o Device)"

#define MQTT_PUB "tago/data/post"

/* Objects */

WiFiClient client;
PubSubClient MQTT(client);

/* Connect To WiFi */

void connectToWiFi()
{
    Serial.print("Conectando a rede = ");
    Serial.println(WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASS);
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(500);
    }

    Serial.println("");
    Serial.print("Conectado IP = ");
    Serial.println(WiFi.localIP());
    delay(1000);
}

/*Verify WiFi is connected */

void verifyWifiConnect()
{
    if (WiFi.status() == WL_CONNECTED)
    {
        return;
    }
    else
    {
        connectToWiFi();
    }
}

/* Connect To MQTT Broker */

void connectToMQTT()
{
    uint8_t tentativasConexao = 0;
    char idMQTTRandom[5] = {0};
    MQTT.setServer(MQTT_SERVER, MQTT_PORT);

    randomSeed(random(9999));
    sprintf(idMQTTRandom, "%ld", random(9999));

    while (!MQTT.connected())
    {
        Serial.println("Conectando ao Broker MQTT");
        if (MQTT.connect(idMQTTRandom, MQTT_USER, MQTT_PASS))
        {
            Serial.println("Conectado ao Broker MQTT com sucesso!");
            tentativasConexao = 0;
        }
        else
        {
            tentativasConexao++;
            Serial.println("Falha na tentativa de conexão com o Broker MQTT");
            Serial.println("Nova tentativa em 5s");
            if (tentativasConexao == 5)
            {
                Serial.println("ESP-32 não conectou! o mesmo será resetado");
                vTaskDelay(pdMS_TO_TICKS(1000));
                ESP.restart();
            }
            vTaskDelay(pdMS_TO_TICKS(5000));
        }
    }
}

/* Verifiy MQTT is connected to Broker*/

void verifyMQTTConnect()
{
    if (MQTT.connected())
    {
        return;
    }
    else
    {
        connectToMQTT();
    }
}

/* Publish data from sensor to MQTT Broker, param: value (temp data) */

void publishDataToMQTT(float value)
{
    StaticJsonDocument<250> json_temp;
    char jsonString[250] = {0};
    //Exibe Serial

    Serial.print("Temperatura ºC = ");
    Serial.println(value);

    //Publish data

    json_temp["variable"] = "temp";
    json_temp["unit"] = "C";
    json_temp["value"] = value;
    memset(jsonString, 0, sizeof(jsonString));
    serializeJson(json_temp, jsonString);
    MQTT.publish(MQTT_PUB, jsonString);
}