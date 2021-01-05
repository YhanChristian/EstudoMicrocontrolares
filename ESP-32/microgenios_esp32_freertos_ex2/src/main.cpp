/* Curso Formação IoT ESP32
   Módulo: ESP-32 com FreeRTOS (Arduino Core)
   Exemplo 6: Conexão Socket HTTPS envio de dados a cada 60s
   Autor: Yhan Christian Souza Silva - data: 22/12/2020
   Descrição: Este Projeto tem por objetivo criar duas tasks no FreeRTOS.
             Uma task enviará um dado de um sensor de temperatura (ficticil) e outra Task 
             Printará dados através do serial monitor. Exemplo sem certificado (pode-se incluir)
*/

/* Inclusão de Bibliotecas */

#include <Arduino.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

/* Defines e Hardware */

#define WIFI_SSID "Seu SSID"
#define WIFI_PASS "Sua Senha"
#define BAUD_RATE 9600

/* Instância Objetos */

WiFiMulti wifiMulti;

/* Protótipo das Tasks */

void vTaskSendDataHTTP(void *pvParameters);
void vTaskPrintSerial(void *pvParameters);

/* Protótipo Função Auxiliares */

void prvConfigSerial();
void prvConfigWiFi();
void vPrintString(const char *pcString);
void vPrintStringAndNumber(const char *pcString, uint32_t ulValue);
void vPrintTwoStrings(const char *pcString1, const char *pcString2);

/* Variavéis Globais */

portMUX_TYPE myMutex = portMUX_INITIALIZER_UNLOCKED;

const char *pcTextForTask1 = "Task 1 is running\r\n";
const char *pcTextForTask2 = "Task 2 is running\r\n";

void setup()
{

  /* Inicia Comunicação Serial */

  prvConfigSerial();

  /*Inicia Config WiFi */

  prvConfigWiFi();

  /*Criação das Tasks */

  xTaskCreatePinnedToCore(
      vTaskSendDataHTTP,               /*task*/
      "task1",                         /*identificação task*/
      configMINIMAL_STACK_SIZE + 8192, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      2,                               /*prioridade*/
      NULL,                            /*handle*/
      APP_CPU_NUM);                    /*core 1*/

  xTaskCreatePinnedToCore(
      vTaskPrintSerial,                /*task*/
      "task 2",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 5000, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      1,                               /*prioridade*/
      NULL,                            /*handle*/
      PRO_CPU_NUM);                    /*core 2*/
}

void loop()
{
  vTaskDelay(100 / portTICK_PERIOD_MS);
}

/* Implementação Tasks */

void vTaskSendDataHTTP(void *pvParameters)
{
  UBaseType_t uxHighWaterMark;
  uxHighWaterMark = uxTaskGetStackHighWaterMark(NULL);
  vPrintString("Task1 Init...\n");

  for (;;)
  {

    if ((wifiMulti.run() == WL_CONNECTED))
    {

      HTTPClient http;

      vPrintString("[HTTP] begin...\n");

      http.begin("https://www.geniot.io/things/services/api/v1/variables/S00/value/?token=VerificarToken"); //HTTP
      http.addHeader("Content-Type", "application/json");
      http.addHeader("Connection", "close");

      vPrintString("[HTTP] POST...\n");
      int httpCode = http.POST("{\"value\": 30.00}");
      // httpCode will be negative on error
      if (httpCode > 0)
      {
        // HTTP header has been send and Server response header has been handled
        vPrintStringAndNumber("[HTTP] POST... code: \n", httpCode);

        // file found at server
        if (httpCode == HTTP_CODE_OK)
        { //Code 200
          String payload = http.getString();
          vPrintString(payload.c_str());
        }
      }
      else
      {
        vPrintTwoStrings("[HTTP] POST... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }

      http.end();
    }

    /* Obtêm consumo stack  */

    uxHighWaterMark = uxTaskGetStackHighWaterMark(NULL);
    vPrintStringAndNumber("Size: ", uxHighWaterMark);

    /* Aguarda 60s para novo envio de dado */

    vTaskDelay(60000 / portTICK_PERIOD_MS);

  }
}

void vTaskPrintSerial(void *pvParameters)
{
  char *pcTaskName;
  pcTaskName = (char *)pvParameters;
  volatile uint32_t ul;

  vPrintString("Task2 Init...\n");
  for (;;)
  {
    vPrintString(pcTaskName);
    vTaskDelay(100 / portTICK_PERIOD_MS);
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

void vPrintString(const char *pcString)
{
  portENTER_CRITICAL(&myMutex);
  {
    Serial.println((char *)pcString);
  }
  portEXIT_CRITICAL(&myMutex);
}

void vPrintStringAndNumber(const char *pcString, uint32_t ulValue)
{
  taskENTER_CRITICAL(&myMutex);
  {
    char buffer[50];
    sprintf(buffer, "%s %lu\r\n", pcString, ulValue);
    Serial.println((char *)buffer);
  }
  taskEXIT_CRITICAL(&myMutex);
}

void vPrintTwoStrings(const char *pcString1, const char *pcString2)
{
  taskENTER_CRITICAL(&myMutex);
  {
    char buffer[50];
    sprintf(buffer, "%s %s\r\n", pcString1, pcString2);
    Serial.println((char *)buffer);
  }
  taskEXIT_CRITICAL(&myMutex);
}