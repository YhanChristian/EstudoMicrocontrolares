/* Curso Formação IoT ESP32
   Módulo: ESP-32 com FreeRTOS (Arduino Core)
   Exemplo 1: Implementando Task atribuindo ao core ESP32
   Autor: Yhan Christian Souza Silva - data: 17/11/2020
   Descrição: Este Projeto tem por objetivo criar duas tasks no FreeRTOS.
              Cada task é responsável em enviar uma string pela UART do ESP32 de maneira concorrente.
              Cada task será executada em um core diferente, uma no CORE 1 e outra no CORE 2
*/

/* Inclusão de Bibliotecas */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

/* Protótipo das Tasks */

void vTask1(void *pvParameters);
void vTask2(void *pvParameters);

/* Protótipo Função Auxiliares */

void prvConfigSerial(void);
void vPrintSerial(const char *pcString);

/* Variavéis Globais */

portMUX_TYPE myMutex = portMUX_INITIALIZER_UNLOCKED;

void setup()
{

  /* Inicia Comunicação Serial */

  prvConfigSerial();

  /* Criação das Tasks */

  xTaskCreatePinnedToCore(
      vTask1,                   /*task*/
      "task1",                  /*identificação task*/
      configMINIMAL_STACK_SIZE, /*tamanho stack*/
      NULL,                     /*parametros passados para task*/
      1,                        /*prioridade*/
      NULL,                     /*handle*/
      APP_CPU_NUM);             /*core 1*/

  xTaskCreatePinnedToCore(
      vTask2,                   /*task*/
      "task2",                  /*identificação task*/
      configMINIMAL_STACK_SIZE, /*tamanho stack*/
      NULL,                     /*parametros passados para task*/
      1,                        /*prioridade*/
      NULL,                     /*handle*/
      PRO_CPU_NUM);             /*core 2*/
}

void loop()
{
  vTaskDelay(100 / portTICK_PERIOD_MS);
}

/* Implementação Tasks */

void vTask1(void *pvParameters)
{
  const char *pcTaskName = "Task 01 Rodando\r\n";
  while (true)
  {
    vPrintSerial(pcTaskName);
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

void vTask2(void *pvParameters)
{
  const char *pcTaskName = "Task 02 Rodando\r\n";
  while (true)
  {
    vPrintSerial(pcTaskName);
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

/* Implementação Funções Auxiliares */

void prvConfigSerial(void)
{
  Serial.begin(9600);
}

void vPrintSerial(const char *pcString)
{
  portENTER_CRITICAL(&myMutex);
  {
    Serial.println((char *)pcString);
  }
  portEXIT_CRITICAL(&myMutex);
}