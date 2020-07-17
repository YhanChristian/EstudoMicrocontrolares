/* Exemplo com filas RTOS: adicionar itens, ler - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
*/


/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

/* Cria o objeto fila */

QueueHandle_t xFila;

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t xTask1Handle;
TaskHandle_t xTask2Handle;


/* Protótipo das Tasks*/

void vTask1(void *pvParameters);
void vTask2(void *pvParameters);


void setup() {

  BaseType_t xReturned;

 Serial.begin(115200);
 pinMode(LED_BUILTIN, OUTPUT);
 
 /*Criação da fila e teste*/

 xFila = xQueueCreate(5, sizeof(int));

 if(xFila == NULL)
 {
   Serial.println("Não foi possível criar a fila");
   while(1);
 }
 
  /*Criação de task e teste*/

 xReturned = xTaskCreate(vTask1, "task1", configMINIMAL_STACK_SIZE + 1024, NULL, 1, &xTask1Handle);

 if(xReturned == pdFAIL)
 {
   Serial.println("Falha ao criar a Task01");
   while(1);
 }

 xReturned = xTaskCreate(vTask2, "task2", configMINIMAL_STACK_SIZE + 1024, NULL, 1, &xTask2Handle);

 if(xReturned == pdFAIL)
 {
   Serial.println("Falha ao criar a Task02");
   while(1);
 }

}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
  vTaskDelay(pdMS_TO_TICKS(1000));
}

/* Implementação das tasks */

void vTask1(void *pvParameters)
{
  (void) pvParameters;  /* Apenas para o Compilador não retornar warnings */

  int count = 0;

  while(true)
  {
    if(count < 10)
    {
      xQueueSend(xFila, &count, portMAX_DELAY);
      count++;
    }

    else {
      count = 0;
      vTaskDelay(pdMS_TO_TICKS(5000));
    }

    vTaskDelay(pdMS_TO_TICKS(500));
  }
}

void vTask2(void *pvParameters)
{
  (void) pvParameters;  /* Apenas para o Compilador não retornar warnings */

  int valorRecebido = 0;

  while(true)
  {
    if(xQueueReceive(xFila, &valorRecebido, pdMS_TO_TICKS(1000)) == pdTRUE)
    {
      Serial.println("Valor recebido: " + String(valorRecebido));
    }

    else 
    {
      Serial.println("TIMEOUT");

    }
   
  }
}