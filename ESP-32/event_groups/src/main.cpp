/* Exemplo com  event groups RTOS - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
  
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/timers.h"
#include "freertos/event_groups.h"

/* Defines e Hardware */

#define TASK01_FLAG (1 << 0) // 01
#define TASK02_FLAG (1 << 1) // 10

/*Variáveis e constantes globais */

uint16_t tempo = 0;

/* Variáveis globais - armazena handle das tasks e timers */

TaskHandle_t xTask01, xTask02;
TimerHandle_t xTimer;
EventGroupHandle_t xEvents;

/* Protótipo das Tasks*/

void vTask01(void *pvParameters);
void vTask02(void *pvParameters);

/* Protótipo callback timer */

void vCallbackTimer(TimerHandle_t xTimer);

void setup()
{

  Serial.begin(115200);

  pinMode(LED_BUILTIN, OUTPUT);

  /*Cria Grupo de Eventos */

  xEvents = xEventGroupCreate();

  /*Cria Timer */

  xTimer = xTimerCreate(
      "timer01",           /*identificação timer */
      pdMS_TO_TICKS(1000), /* tempo timer em ticks*/
      pdTRUE,              /*pdTRUE = autoreload*/
      0,                   /*id*/
      vCallbackTimer);     /*função de callback */

  /* Cria TASKS*/

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
      2,                               /*prioridade*/
      &xTask02);                       /*handle*/

  xTimerStart(xTimer, 0); /*Timer inicia*/
}

void loop()
{
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
  vTaskDelay(pdMS_TO_TICKS(500));
}

/* Implementação das TASKS */

void vTask01(void *pvParameters)
{
  EventBits_t xBits;
  while (true)
  {
    xBits = xEventGroupWaitBits(xEvents, TASK01_FLAG, pdTRUE, pdTRUE, portMAX_DELAY);
    Serial.println("Task 01: saiu do estado de bloqueio: " + String(xBits));
  }
}

void vTask02(void *pvParameters)
{
  EventBits_t xBits;
  while (true)
  {
    xBits = xEventGroupWaitBits(xEvents, TASK02_FLAG, pdTRUE, pdTRUE, portMAX_DELAY);
    Serial.println("Task 02: saiu do estado de bloqueio: " + String(xBits));
  }
}

void vCallbackTimer(TimerHandle_t xTimer)
{
  tempo++;

  if (tempo == 5)
  {
    xEventGroupSetBits(xEvents, TASK01_FLAG);
  }

  else if (tempo == 10)
  {
    xEventGroupSetBits(xEvents, TASK02_FLAG);
  }

  else if (tempo == 20)
  {
    xEventGroupSetBits(xEvents, TASK01_FLAG | TASK02_FLAG);
    tempo = 0;
  }
}