/* Exemplo com soft timers RTOS - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
  
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/timers.h"

/* Hardware */

#define LED_02 14
#define BUTTON 12

/* Variáveis globais - armazena handle das tasks e timers */

TaskHandle_t xTask01;
TimerHandle_t xTimerAutoReload, xTimerOneShot;

/* Protótipo das Tasks*/

void vTask01(void *pvParameters);

/*Protótipo Callback function - timers */

void callBackTimerOneShot(TimerHandle_t xTimer);
void callBackTimerAutoReload(TimerHandle_t xTimer);

void setup()
{

  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(LED_02, OUTPUT);
  pinMode(BUTTON, INPUT_PULLUP);

  /* Cria Timers */

  xTimerAutoReload = xTimerCreate(
      "TimerAutoReload",        /*identificação timer */
      pdMS_TO_TICKS(1000),      /* tempo timer em ticks*/
      pdTRUE,                   /*pdTRUE = timer autoreload*/
      0,                        /*id*/
      callBackTimerAutoReload); /*função de callback */

  xTimerOneShot = xTimerCreate(
      "TimerOneShot",        /*identificação timer */
      pdMS_TO_TICKS(10000),  /* tempo timer em ticks*/
      pdFALSE,               /*pdFALSE = timer Shot*/
      0,                     /*id*/
      callBackTimerOneShot); /*função de callback */

  /* Cria TASK*/

  xTaskCreate(
      vTask01,                         /*task*/
      "task01",                        /*identificação task*/
      configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
      NULL,                            /*parametros passados para task*/
      1,                               /*prioridade*/
      &xTask01);                       /*handle*/

  /*Inicia TIMER*/
  xTimerStart(xTimerAutoReload, 0);
}

void loop()
{
  //Apenas para liberar CPU

  vTaskDelay(pdMS_TO_TICKS(1000));
}

/* Implementação das TASKS */

void vTask01(void *pvParameters)
{
  uint8_t debounceTime = 0;

  while (true)
  {
    /* Verifica botão e se timer não esta ativo...
    incrementa variável debounce para tratar acionamento btn
    */
    if ((digitalRead(BUTTON) == LOW) && (xTimerIsTimerActive(xTimerOneShot) == pdFALSE))
    {
      debounceTime++;

      if (debounceTime >= 10)
      {
        debounceTime = 0;
        digitalWrite(LED_02, HIGH);
        xTimerStart(xTimerOneShot, 0);
        xTimerStop(xTimerAutoReload, 0);
        Serial.println("Iniciando Timer 02");
      }
    }

    else
    {
      debounceTime = 0;
    }
    vTaskDelay(pdMS_TO_TICKS(10));
  }
}

/* Implementação das funções de CALLBACK  (deve ser uma ação rápida) */

void callBackTimerAutoReload(TimerHandle_t xTimer)
{
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
}

void callBackTimerOneShot(TimerHandle_t xTimer)
{
  digitalWrite(LED_02, LOW);

  /*Reinicia Timer 01 */

  xTimerStart(xTimerAutoReload, 0);
}