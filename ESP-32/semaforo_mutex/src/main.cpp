/* Exemplo com semáforo MUTEX (o mais utilizado) RTOS - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
   **MUTEX: GARANTE ACESSO EXCLUSIVO AO RECURSO SOMENTE A TAREFA QUE RECEBE O SEMAFORO PODE LIBERAR**
  
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

/* Armazena handle semaforo */

SemaphoreHandle_t xSemaphoreMutex;

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t xTask01;
TaskHandle_t xTask02;

/* Protótipo das Tasks*/
void vTask01(void *pvParameters);
void vTask02(void *pvParameters);

/*Protótipo funções auxiliares */
void enviaInformacao(uint8_t x);

void setup()
{

  /* Inicia serial e hardware */
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);

  /* Cria semoforo e faz teste */

  xSemaphoreMutex = xSemaphoreCreateMutex(); //Não necessita passa parametro

  /*Criação de TASKS */

  xTaskCreate(
      vTask01,                         /*task*/
      "task01",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      1,                               /*prioridade*/
      &xTask01);                       /*handle*/

  xTaskCreate(
      vTask02,                         /*task*/
      "task02",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      4,                               /*prioridade*/
      &xTask02);                       /*handle*/
}

void loop()
{
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
  Serial.println("Estado LED: " + String(digitalRead(LED_BUILTIN)));
  vTaskDelay(pdMS_TO_TICKS(250));
}

/* Implementação das TASKS */

void vTask01(void *pvParameters)
{
  while (true)
  {
    //  xSemaphoreTake(xSemaphoreMutex, portMAX_DELAY);
    enviaInformacao(1);
    //delay(2000);
    // xSemaphoreGive(xSemaphoreMutex);
    vTaskDelay(10);
  }
}

void vTask02(void *pvParameters)
{
  while (true)
  {
    // xSemaphoreTake(xSemaphoreMutex, portMAX_DELAY);
    enviaInformacao(2);
    vTaskDelay(10);
    //  xSemaphoreGive(xSemaphoreMutex);
    //   vTaskDelay(pdMS_TO_TICKS(10));
  }
}

/*Implementação de funções auxiliares */

void enviaInformacao(uint8_t x)
{
  xSemaphoreTake(xSemaphoreMutex, portMAX_DELAY);
  Serial.println("Enviando informação da task: " + String(x));
  delay(1000);
  xSemaphoreGive(xSemaphoreMutex);
}