/* Exemplo conexão TTN ABP 
   Módulo: Heltec LoRa ESP32
   Autor: Yhan Christian Souza Silva - data: 24/01/2021
   Descrição: Este Projeto tem por objetivo realizar a conexão de um ENDPOINT a plataforma TTN 
              (The Things Network)
  Obs.: Utilizado PlatformIO e as libs externas fica no arquivo platformio.ino 
        Alterar arquivo lmic_project_config.h descomentar #define CFG_us915 1
*/

/* Inclusão de Bibliotecas */

#include <Arduino.h>
#include <TTN_esp32.h>
#include "TTN_CayenneLPP.h"

/* Hardware e Defines */

#define BAUD_RATE 115200

/* Constantes (array de char)*/

/* Crie seu device na Plataforma TTN e altere as seguintes constantes pelos parâmetros abaixo */

const char *devAddr = "CHANGE_ME"; // Change to TTN Device Address
const char *nwkSKey = "CHANGE_ME"; // Change to TTN Network Session Key
const char *appSKey = "CHANGE_ME"; // Change to TTN Application Session Key

/* Instância de Objetos */

TTN_esp32 ttn;
TTN_CayenneLPP lpp;

/*Protótipo de Funções Auxiliares */
void message(const uint8_t *payload, size_t size, int rssi);

void setup()
{
  Serial.begin(BAUD_RATE);
  Serial.println("Starting");
  ttn.begin();
  ttn.onMessage(message); // declare callback function when is downlink from server
  ttn.personalize(devAddr, nwkSKey, appSKey);
  ttn.showStatus();
}

void loop()
{
  static float nb = 18.2;
  nb += 0.1;
  lpp.reset();
  lpp.addTemperature(1, nb);
  if (ttn.sendBytes(lpp.getBuffer(), lpp.getSize()))
  {
    Serial.printf("Temp: %f TTN_CayenneLPP: %d %x %02X%02X\n", nb, lpp.getBuffer()[0], lpp.getBuffer()[1],
                  lpp.getBuffer()[2], lpp.getBuffer()[3]);
  }
  delay(10000);
}

/* Implementação de Funções Auxiliares */

void message(const uint8_t *payload, size_t size, int rssi)
{
  Serial.println("-- MESSAGE");
  Serial.print("Received " + String(size) + " bytes RSSI= " + String(rssi) + "dB");

  for (int i = 0; i < size; i++)
  {
    Serial.print(" " + String(payload[i]));
    // Serial.write(payload[i]);
  }

  Serial.println();
}