/* Exemplo com semáforo contador RTOS - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
  
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

/* Hardware */

#define BOTAO 12

/* Armazena handle semaforo */

SemaphoreHandle_t xSemaphoreCounting;

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t xTaskTrataBTN;

/*Variáveis e constantes globais */

const uint8_t valorMinimo = 0, valorMaximo = 255;

/* Protótipo das Tasks*/

void vTaskTrataBTN(void *pvParameters);

/* Protótipo interrupção ISR*/

void trataISR();

void setup()
{
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(BOTAO, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(BOTAO), trataISR, FALLING);

  /* Cria semoforo e faz teste */

  xSemaphoreCounting = xSemaphoreCreateCounting(valorMaximo, valorMinimo);

  if (xSemaphoreCounting == NULL)
  {
    Serial.println("Não foi possível criar o semáforo contador!");
    while (true)
    {
      /* fica preso aqui */
    }
  }

  /* Cria task trata BTN */

  xTaskCreate(vTaskTrataBTN, "taskTataBTN", configMINIMAL_STACK_SIZE + 1024, NULL, 3, &xTaskTrataBTN); //Cria Task
}

void loop()
{
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
  Serial.println("Valor do LED: " + String(digitalRead(LED_BUILTIN)));
  vTaskDelay(pdMS_TO_TICKS(500));
}

/* Interrupção ISR */

void trataISR()
{
  BaseType_t xHighPriorityTaskWoken = pdTRUE;
  /* Libera semáforo*/
  xSemaphoreGiveFromISR(xSemaphoreCounting, &xHighPriorityTaskWoken);

  /* Força troca de contexto para exibir task com maior prioridade */

  if (xHighPriorityTaskWoken == pdTRUE)
  {
    portYIELD_FROM_ISR();
  }
}

/* Implementa a TASK */

void vTaskTrataBTN(void *pvParameters)
{

  UBaseType_t x = 0;

  while (true)
  {

    /* Aguarda liberar semáforo */
    xSemaphoreTake(xSemaphoreCounting, portMAX_DELAY);
    x = uxSemaphoreGetCount(xSemaphoreCounting);
    Serial.println("Tratando a ISR do BTN:" + String(x));
    //delay(1000);

  }
}