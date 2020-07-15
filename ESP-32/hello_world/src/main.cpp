/* Primeiro exemplo com ESP-32 (Curso Primeiros passos com FreeRTOS)
  Utilizado o módulo Heltec Lora V2
*/

#include <Arduino.h>

void setup() {
  Serial.begin(115200);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
  delay(500);
  Serial.println("Olá, mundo!");
}