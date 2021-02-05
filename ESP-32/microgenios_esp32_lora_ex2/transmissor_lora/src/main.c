/* Curso Formação IoT ESP32 - Utilizando ESP32 Heltec módulo LoRa SDK-IDF
   Módulo: Heltec Lora V2 - ESP32
   Exemplo 02: Transimissor LoRa - comunicação Ponto a Ponto
   Autor: Yhan Christian Souza Silva - data: 05/02/2021
   Descrição: Este projeto tem como objetivo criar um transmissor (MASTER) que transmite e recebe confirmação
   de dados do (SLAVE) e faz validação através do CRC
   O frame LoRa de transmissão é composto de: 
   <id_node_sender> <id_node_receiver> <command> <payload_size> <payload> <crc>
   biblioteca lora.h dentro da pasta components (SDK-IDF)
*/


/**
 * Bibliotecas auxiliares
*/

#include <stdio.h>
#include <string.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "esp_err.h"
#include "esp_log.h"

#include "lora.h"
#include "lora_crc.h"

#include "lib_heltec.h"


/**
 *  Hardware e Defines  
*/

#define DEBUG 1 
#define LORA_TOTAL_NODES 2 

/**
 * Endereçamento dos dispositivos da rede LoRa;
 * O MASTER sempre será o inicializa a comunicação com os SLAVES;
 * O MASTER possui endereço 0, enquanto os SLAVES são enumerados de 1 a 255;
 */

#define MASTER_NODE_ADDRESS 0
#define LORA_RECEIVER_TIMEOUT_MS 500

/**
 * Comandos;
 */
#define CMD_READ_COUNT 0
#define CMD_READ_ADC   1
#define CMD_SET_GPIO   2
#define CMD_PRINT_OLED 3
#define CMD_READ_RSSI  4

/**
 * Variáveis;
 */
const char * TAG = "main ";

/**
 * Protótipo Tasks 
 */

static void task_tx( void *pvParameter );

/**
 * Protótipo funções Auxiliares
 */

static void read(void);


/**
 * Função Main
*/


void app_main(void) 
{

}

/**
 *  Implementação Tasks
 */

static void task_tx( void *pvParameter )
{
   /**
   * Mensagem a ser transmitida via LoRa;
   */
  uint8_t protocolo[100];

  for(;;)
  {
     /**
       * Transmite o mesmo comando CMD_READ_COUNT para todos os devices (SLAVE), conforme
       * o range de endereços em LORA_TOTAL_NODES; 
       * Indice do for inicia em 1, pois endereço do MASTER é 0.
       */

      for(uint8_t i = 1; i < LORA_TOTAL_NODES; i++)
      {
        /**
         * Protocolo;
         * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
         */
          protocolo[0] = MASTER_NODE_ADDRESS;  //master address node;
          protocolo[1] = i;                    //slave address node;
          protocolo[2] = CMD_READ_COUNT;       //comando de leitura da variável Count do receptor;
          protocolo[3] = 0;                    //neste exemplo não há dados a serem enviados no payload;
          
      }

  }

}


/**
 * Implementação Funções Auxiliares
 */

static void read(void)
{

}