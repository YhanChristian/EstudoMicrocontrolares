/* Exemplo com  task notification RTOS - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
  
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

/* Hardware e Defines */

#define BUTTON 12

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t xTask01;

/* Protótipo Interrupção*/

void trataISR();

/* Protótipo das Tasks*/

void vTask01(void *pvParameters);

void setup()
{

  Serial.begin(115200);

  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(BUTTON, INPUT_PULLUP);

  /* Config interrupção externa */

  attachInterrupt(digitalPinToInterrupt(BUTTON), trataISR, FALLING);

  /* Cria TASK*/

  xTaskCreate(
      vTask01,                  /*task*/
      "task01",                 /*identificação task*/
      configMINIMAL_STACK_SIZE, /*tamanho stack*/
      NULL,                     /*parametros passados para task*/
      1,                        /*prioridade*/
      &xTask01);                /*handle*/
}

void loop()
{
  vTaskDelay(pdMS_TO_TICKS(1000));
}

/* Interrupção */

void trataISR()
{
  vTaskNotifyGiveFromISR(xTask01, pdFALSE);
}

/* Implementação das TASKS */

void vTask01(void *pvParameters)
{
  uint32_t contador = 0;
  while(true)
  {
    contador = ulTaskNotifyTake(pdFALSE, portMAX_DELAY); /* pdFALSE = inc contador notifications, portMAX_DELAY = espera */
    Serial.println("Tratando ISR BTN, Notificação nº: " + String(contador));
    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    delay(500); // aguarda 
  }
}
