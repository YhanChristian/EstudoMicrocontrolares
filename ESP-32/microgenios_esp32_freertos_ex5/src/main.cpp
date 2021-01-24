/* Curso Formação IoT ESP32
   Módulo: ESP-32 com FreeRTOS (Arduino Core)
   Exemplo 21: Uso do Queue SET e Event Groups
   Autor: Yhan Christian Souza Silva - data: 24/01/2021
   Descrição: Este Projeto tem por objetivo apresentar o uso do recurso de Event Groups 
              e MailBox do FreeRTOS
*/

/* Inclusão de Bibliotecas */

#include <Arduino.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "freertos/event_groups.h"

/* Hardware e Defines*/

#define BAUD_RATE 9600

/*Estrutura de dados */

typedef struct xExampleStructure
{
  TickType_t xTimeStamp;
  uint32_t ulValue;
} Example_t;

/*Handle  Fila*/

QueueHandle_t xMailbox;


/* Variáveis Globais (MUTEX) */

portMUX_TYPE myMutex = portMUX_INITIALIZER_UNLOCKED;

/* Protótipo das Tasks */

void vSenderTask(void *pvParameters);
void vReceiverTask(void *pvParameters);

/* Protótipo Função Auxiliares */

void prvConfigSerial();
void vPrintStringAndInteger(const char *pcString, uint32_t ulValue);



void setup()
{
  /*Inicia Serial Monitor */
  prvConfigSerial();

  /*Cria fila de uma posição*/ 
  xMailbox = xQueueCreate(1, sizeof(Example_t));

  /*Criação das Tasks */

  xTaskCreatePinnedToCore(
      vSenderTask,                /*task*/
      "Task Sender",                          /*identificação task*/
      configMINIMAL_STACK_SIZE + 2048, /*tamanho stack*/
      NULL,                             /*parametros passados para task*/
      1,                                /*prioridade*/
      NULL,                             /*handle*/
      APP_CPU_NUM);                     /*core 1*/

  xTaskCreatePinnedToCore(
      vReceiverTask,                   /*task*/
      "Task Receiver",                  /*identificação task*/
      configMINIMAL_STACK_SIZE + 2048, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      1,                               /*prioridade*/
      NULL,                            /*handle*/
      APP_CPU_NUM);                    /*core 1*/
}


void loop()
{
  
  vTaskDelay(100 / portTICK_PERIOD_MS);
}

/* Implentação Tasks*/

void vSenderTask(void *pvParameters)
{
  Example_t xData;
  BaseType_t xStringNumber = 0;
  const TickType_t xBlockTime = pdMS_TO_TICKS(100);
  for (;;)
  {

    xStringNumber++;
    /* Write the new data into the Example_t structure.*/
    xData.ulValue = xStringNumber;
    /* Use the RTOS tick count as the time stamp stored in the Example_t structure. */
    xData.xTimeStamp = xTaskGetTickCount();
    /* Send the structure to the mailbox - overwriting any data that is already in the 
          mailbox. */
    xQueueOverwrite(xMailbox, &xData);

    /* Block for 100ms. */
    vTaskDelay(xBlockTime);
  }
}

void vReceiverTask(void *pvParameters)
{
  BaseType_t xStatus;
  Example_t xData;
  BaseType_t xDataUpdated;
  const TickType_t xDelay500ms = pdMS_TO_TICKS(500);

  for (;;)
  {

    xStatus = xQueuePeek(xMailbox, &xData, xDelay500ms);
    if (xStatus == pdPASS)
    {
      vPrintStringAndInteger("Value = ", xData.ulValue);
      vPrintStringAndInteger("TimeStamp = ", xData.xTimeStamp);
    }

    vTaskDelay(xDelay500ms);
  }
}

/* Implementação funções auxiliares */
void prvConfigSerial()
{
  Serial.begin(9600);
  for (uint8_t t = 4; t > 0; t--)
  {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(500);
  }
}

void vPrintStringAndInteger(const char *pcString, uint32_t ulValue)
{
  portENTER_CRITICAL(&myMutex);
  {
    char buffer[50];
    sprintf(buffer, "%s %lu", pcString, ulValue);
    Serial.println((char *)buffer);
  }
  portEXIT_CRITICAL(&myMutex);
}