/* Curso Formação IoT ESP32
   Módulo: ESP-32 com FreeRTOS (Arduino Core)
   Exemplo 6: Conexão Socket HTTPS 
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
#define WIFI_PASS "Seu password"
#define BAUD_RATE 9600

/* Protótipo das Tasks */

/* Protótipo Função Auxiliares */

void prvConfigSerial(void);
void vPrintSerial(const char *pcString);

/* Variavéis Globais */

portMUX_TYPE myMutex = portMUX_INITIALIZER_UNLOCKED;
const char *pcTextForTask1 = "Task 1 is running\r\n";
const char *pcTextForTask2 = "Task 2 is running\r\n";

void setup()
{

  /* Inicia Comunicação Serial */

  prvConfigSerial();
}

void loop()
{
  vTaskDelay(100 / portTICK_PERIOD_MS);
}

/* Implementação Tasks */

/* Implementação Funções Auxiliares */

void prvConfigSerial(void)
{
  Serial.begin(BAUD_RATE);
  for (uint8_t t = 4; t > 0; t--)
  {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(500);
  }
}

void vPrintSerial(const char *pcString)
{
  portENTER_CRITICAL(&myMutex);
  {
    Serial.println((char *)pcString);
  }
  portEXIT_CRITICAL(&myMutex);
}