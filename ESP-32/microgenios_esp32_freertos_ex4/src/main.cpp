/* Curso Formação IoT ESP32
   Módulo: ESP-32 com FreeRTOS (Arduino Core)
   Exemplo 17: Conexão Socket HTTPS envio de dados da porta analógica a cada 60s com uso de filas e da API genIOT
   Autor: Yhan Christian Souza Silva - data: 21/01/2021
   Descrição: Este Projeto tem por objetivo criar duas tasks no FreeRTOS.
             Uma task fará a leitura da porta analógica do ESP-32 e passará o valor lido para uma fila
             Outra task enviará os dados via HTTPs para o servidor
*/

/* Inclusão de Bibliotecas */

#include <Arduino.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

#include "WiFi.h"
#include "WiFiMulti.h"
#include "HTTPClient.h"

#include "driver/gpio.h"
#include "driver/adc.h"
#include "esp_system.h"
#include "esp_adc_cal.h"

#include "geniotHTTPS_ESP32.h"

/*Hardware e Defines */

#define WIFI_SSID "Seu SSID"
#define WIFI_PASS "Sua Senha"

#define TOKEN_GENIOT "Insira o seu token GenIOT"
#define TEMPERATURA "S00"

#define BAUD_RATE 9600
#define DEBUG 0
#define V_REF 1100

/* Instância Objetos*/

Geniot client((char *)TOKEN_GENIOT);

/* Handle da Fila */

QueueHandle_t xQueueADC;

/* Protótipo das Tasks */

void vTaskSendDataHTTP(void *pvParameters);
void vTaskReadADC(void *pvParameters);

/* Protótipo Função Auxiliares */

void prvConfigSerial();
void prvConfigWiFi();

void setup()
{
  /* Inicia Comunicação Serial */

  prvConfigSerial();

  /*Inicia Config WiFi */

  prvConfigWiFi();

  /*Criação de filas e teste */

  xQueueADC = xQueueCreate(5, sizeof(int));

  if (xQueueADC == NULL)
  {
    while (true)
    {
       //Programa trava aqui
    }
  }

  /*Criação das Tasks */

  xTaskCreatePinnedToCore(
      vTaskSendDataHTTP,               /*task*/
      "task1",                         /*identificação task*/
      configMINIMAL_STACK_SIZE + 10240, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      2,                               /*prioridade*/
      NULL,                            /*handle*/
      PRO_CPU_NUM);                    /*core 2*/

  xTaskCreatePinnedToCore(
      vTaskReadADC,                    /*task*/
      "task 3",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      3,                               /*prioridade*/
      NULL,                            /*handle*/
      APP_CPU_NUM);                    /*core 1*/
}

void loop()
{
  vTaskDelay(100 / portTICK_PERIOD_MS);
}

/* Implementação Tasks */

void vTaskSendDataHTTP(void *pvParameters) 
{
  BaseType_t xStatus;
  int adc_result;
  client.vPrintString("Task1 Init...");
  
  for (;;)
  {

    xStatus = xQueueReceive(xQueueADC, &adc_result, 0);
    if (xStatus == pdPASS)
    {
      //Envia o valor da temperatura para o servidor GenIOT
      client.add((char *)TEMPERATURA, (float)adc_result);

      if (client.send())
      {
        client.vPrintString("-----------------------------------------------");
        client.vPrintString((char *)"Enviado com sucesso!");
      }
    }

    vTaskDelay(60000 / portTICK_PERIOD_MS);
  }
}

void vTaskReadADC(void *pvParameters)
{
  BaseType_t xStatus;

  for (;;)
  {

    adc1_config_width(ADC_WIDTH_12Bit);
    adc1_config_channel_atten(ADC1_CHANNEL_0, ADC_ATTEN_11db);
    esp_adc_cal_characteristics_t characteristics;
    esp_adc_cal_get_characteristics(V_REF, ADC_ATTEN_11db, ADC_WIDTH_12Bit, &characteristics);
    uint32_t temperatura = adc1_to_voltage(ADC1_CHANNEL_0, &characteristics);

    //Coloca na fila do valor lido pelo ADC

    xStatus = xQueueSend(xQueueADC, &temperatura, 0);

    if (xStatus != pdPASS)
    {
      
    }

    vTaskDelay(20 / portTICK_PERIOD_MS);
  }
}

/* Implementação Funções Auxiliares */

void prvConfigSerial()
{
  Serial.begin(BAUD_RATE);
}

void prvConfigWiFi()
{
  while (!(client.wifiConnection((char *)WIFI_SSID, (char *)WIFI_PASS)))
  {
    for (uint8_t t = 4; t > 0; t--)
    {
      Serial.printf("[SETUP] WAIT %d...\n", t);
      Serial.flush();
      delay(500);
    }
  }
}
