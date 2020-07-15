/* Exemplo de criação de TASK - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t task1Handle = NULL;
TaskHandle_t task2Handle = NULL;

/* Protótipo das Tasks*/

void vTask1(void *pvParameters);
void vTask2(void *pvParameters);

void setup()
{
  Serial.begin(115200);

  /* Criação de tasks*/

  xTaskCreate(vTask1, "task1", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
  xTaskCreate(vTask2, "task2", configMINIMAL_STACK_SIZE + 1024, NULL, 2, NULL);
}

void loop()
{
  vTaskDelay(1000);
}

void vTask1(void *pvParameters)
{
  while (true)
  {
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    vTaskDelay(pdMS_TO_TICKS(200));
  }
}

void vTask2(void *pvParameters)
{
  uint16_t contador = 0;
  while (true)
  {
    Serial.println("Task 02: " + String(contador++));
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}