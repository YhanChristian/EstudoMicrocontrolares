/* Exemplo com filas (interrupção) RTOS: adicionar itens, ler - Curso primeiros passos com FreeRTOS
   Utilizado: Modulo LoRa Heltec V2 (ESP-32)
*/

/* Bibliotecas Auxiliares */

#include <Arduino.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

/* Hardware */

#define PINO_BOTAO 12

/* Cria o objeto fila */

QueueHandle_t xFila;

/* Variáveis globais - armazena handle das tasks */

TaskHandle_t xTask1Handle;

/* Protótipo das Tasks*/

void vTask1(void *pvParameters);

/* Protótipo interrupção*/

void trataISRBTN();

void setup()
{
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(PINO_BOTAO, INPUT_PULLUP);
  
  /*Configura interrupção por borda decida pino_botao */

  attachInterrupt(digitalPinToInterrupt(PINO_BOTAO), trataISRBTN, FALLING);

/* Cria fila 5 posições */
  xFila = xQueueCreate(5, sizeof(int)); 

/* Cria task1 */

  xTaskCreate(vTask1, "task1", configMINIMAL_STACK_SIZE + 1024, NULL ,1, &xTask1Handle);

}

void loop()
{
  digitalWrite(LED, !digitalRead(LED));
  vTaskDelay(pdMS_TO_TICKS(1000));

}

/* Interrupção */

void trataISRBTN()
{
  static int valor; 
  valor++;
  
  /* Envia valor para fila*/

  xQueueSendFromISR(xFila, &valor, NULL);
}

/* Task */

void vTask1(void *pvParameters)
{
  int valorRecebido;
  while(true)
  {
    xQueueReceive(xFila, &valorRecebido, portMAX_DELAY);

    Serial.println("Botão pressionado: " + String(valorRecebido));

  }

}