/* Selecionando Core ESP-32 para TASK - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
   PRO_CPU_NUM (0)
   APP_CPU_NUM (1)
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

/* Definições de Hardware */

#define LED_01  2
#define LED_02  14

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t task1Handle;
TaskHandle_t task2Handle;
TaskHandle_t task3Handle;

/* Variáveis e Constantes */

int cont = 500;

/* Protótipo das Tasks*/

void vTaskBlink(void *pvParameters);
void vTask2(void *pvParameters);

void setup()
{
  Serial.begin(115200);

  /* Criação de tasks*/
  xTaskCreatePinnedToCore(vTaskBlink, "task1", configMINIMAL_STACK_SIZE, (void*)LED_BUILTIN, 1, &task1Handle, APP_CPU_NUM); // Defino Task no core 01
  xTaskCreatePinnedToCore(vTask2, "task2", configMINIMAL_STACK_SIZE + 1024, (void*)cont, 2, &task2Handle, PRO_CPU_NUM); // Defino Task no core 02
  xTaskCreatePinnedToCore(vTaskBlink, "task3", configMINIMAL_STACK_SIZE, (void*)LED_02, 1, &task1Handle, APP_CPU_NUM); // Defino Task no core 01

}
void loop()
{
  vTaskDelay(1000);
}

void vTaskBlink(void *pvParameters)
{
  int pino = (int)pvParameters;
  while (true)
  {
    pinMode(pino, OUTPUT);
    digitalWrite(pino, !digitalRead(pino));
    vTaskDelay(pdMS_TO_TICKS(500));
  }
}

void vTask2(void *pvParameters)
{
  int contador = (int)pvParameters;
  while (true)
  {
    Serial.println("Task 02: " + String(contador++));

    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}