/* Exemplo com semáforo binário RTOS - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
   ***Permite sincronização entre TASKs***
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

/* Hardware */

#define PINO_ADC 34

/* Armazena handle semaforo */

SemaphoreHandle_t xSemaphoreBinary;

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t xTaskADCHandle;

/* Protótipo das Tasks*/

void vTaskADC(void *pvParameters);

void setup()
{

  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);

/* Cria semoforo e faz teste */

  xSemaphoreBinary = xSemaphoreCreateBinary();

  if (xSemaphoreBinary == NULL)
  {
    Serial.println("Não foi possível criar o semáforo binário");
    while (true)
    {
      /* fica preso aqui */
    }
  }

  /* Cria task ADC */

  xTaskCreate(vTaskADC, "taskADC", configMINIMAL_STACK_SIZE + 1024, NULL, 1, &xTaskADCHandle); //Cria Task
}


void loop()
{
      digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    Serial.println("Valor do LED: " + String(digitalRead(LED_BUILTIN)));
    vTaskDelay(pdMS_TO_TICKS(500));

    /*libera semaforo */
    xSemaphoreGive(xSemaphoreBinary); 

}

/* Implementa a TASK */

void vTaskADC(void *pvParameters)
{
  uint16_t leituraADC;
  while(true)
  {
    /*Recebe semaforo liberando leitura ADC*/
    xSemaphoreTake(xSemaphoreBinary, portMAX_DELAY);
    leituraADC = analogRead(PINO_ADC);
    Serial.println("Valor ADC: " + String(leituraADC));
    Serial.println(" ");
  }
}