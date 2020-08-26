/** ============================================================================================================
  Exemplo de aplicação prática com FreeRTOS e ESP32
  Realiza a leitura de um sensor (LM35), imprime valor no display OLED
  publica valor a cada 30s no broker MQTT.
  Dados sendo acompanhados no Tago IO a cada 30s.
  @autor: Yhan Christian Souza Silva
  @data: 10/08/2020
  @versao: 1.0.0
============================================================================================================== */

/*Libs include */

#include "main.h"

void setup() 
{
  initOutput(); /*inicia outputs*/
  initDisplay();/*inicia display*/
  connectToWiFi(); /*conecta a rede WiFi*/
  connectToMQTT(); /*coneta ao Broker MQTT*/
  initRTOS(); /*inicia RTOS e cria tarefas, fila e softwareTimer*/
}

void loop() 
{
  vTaskDelete(NULL); //deleta a task Loop
  
}