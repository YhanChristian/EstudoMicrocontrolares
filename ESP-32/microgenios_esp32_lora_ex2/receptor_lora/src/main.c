/* Curso Formação IoT ESP32 - Utilizando ESP32 Heltec módulo LoRa SDK-IDF
   Módulo: Heltec Lora V2 - ESP32
   Exemplo 02: Receptor LoRa - comunicação Ponto a Ponto
   Autor: Yhan Christian Souza Silva - data: 08/02/2021
   Descrição: Este projeto tem como objetivo criar um receptor(SLAVE) que transmite a partir de um comando 
   do MASTER.
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

/**
 * LoRa device Address;
 */
#define MASTER_NODE_ADDRESS 0

/**
 * ATENÇÃO: 
 * Defina aqui o endereço deste DISPOSITIVO; 1 a 255;
 * Cada dispositivo SLAVE precisa ter endereço diferente;
 */
#define SLAVE_NODE_ADDRESS 1

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

static void task_rx(void *pvParameter);

/**
 * Protótipo funções Auxiliares
 */

static void send(uint8_t * protocolo, uint16_t data);

/**
 * Função Main
*/

void app_main()
{
    char mensagem[30];
    
    /**
    * Inicializa display Oled 128x64 SSD1306;
    * As configurações de pinagens do Oled são encontradas
    * em "lib_heltec.h";
    */
   ssd1306_start();

   /**
    * Imprime usando fonte8x8;
    * Sintaxe: ssd1306_out8( linha, coluna, string , fonte_color );
    */
   snprintf( mensagem, sizeof(mensagem), "Address=%d", SLAVE_NODE_ADDRESS );
   ssd1306_out8( 0, 0, (char*) "Receptor", WHITE );
   ssd1306_out8( 1, 0, (char*) mensagem, WHITE );

   /**
    * Inicializa LoRa utilizando as configurações
    * definidas via menuconfig -> componentes -> lora
    */
   lora_init();

   /**
    * A frequência licenciada no Brasil é a 915Mhz; 
    * Verifique a frequência do seu dispositivo LoRa; 
    * conforme: 433E6 para Asia; 866E6 para Europa e 915E6 para EUA;
    */
   lora_set_frequency( 915e6 );

   /**
    * Deseja habilitar o CRC no Payload da mensagem?
    */
   lora_enable_crc();

    /**
    * Cria a task de recepção LoRa;
    */
   if( xTaskCreate( task_rx, "task_rx", 1024*5, NULL, 5, NULL ) != pdTRUE )
   {
      if( DEBUG )
         ESP_LOGI( TAG, "error - Nao foi possivel alocar task_rx.\r\n" );  
      return;   
   }  

}


/**
 *  Implementação Tasks
 */


static void task_rx(void *pvParameter)
{
   int x;
   uint8_t protocolo[100];
   uint16_t counter = 0;
   for( ;; ) 
   {
      /**
       * Algum byte foi recebido?
       * Realiza a leitura dos registradores de status do LoRa com o 
       * objetivo de verificar se algum byte recebido foi armazenado
       * na FIFO do rádio;
       */
      while(lora_received())
      {
         /**
          * Sim, existe bytes na FIFO do rádio LoRa, portanto precisamos ler
          * esses bytes; A variável buf armazenará os bytes recebidos pelo LoRa;
          * x -> armazena a quantidade de bytes que foram populados em buf;
          */
         x = lora_receive_packet(protocolo, sizeof(protocolo));

         /**
         * Protocolo;
         * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
         */

        if(x >= 6 && protocolo[0] == MASTER_NODE_ADDRESS && protocolo[1] == SLAVE_NODE_ADDRESS)
        {
               /**
               * Verifica CRC;
               */
              USHORT usCRC = usLORACRC16(protocolo, 3 + protocolo[3] + 1);
              UCHAR ucLow =  (UCHAR)(usCRC & 0xFF);
              UCHAR ucHigh = (UCHAR)((usCRC >> 8) & 0xFF);     

               if(ucLow == protocolo[4] && ucHigh == protocolo[5]) 
               {
                   switch (protocolo[2])
                   {
                   case CMD_READ_COUNT:
                       if(DEBUG)
                       {
                           ESP_LOGI( TAG, "Comando CMD_READ_COUNT recebido ..." );
                       }
                        /**
                        * Envia o valor da variável counter para o transmissor;
                        */
                        send(protocolo, counter++ );                       
                       break;
                   
                   default:
                       break;
                   }
               }
        }

      }
       
       /**
       * Delay entre cada leitura dos registradores de status do LoRa;
       */
      vTaskDelay( 10/portTICK_PERIOD_MS  );
   }
}


/**
 * Implementação Funções Auxiliares
 */


/**
  * Nota: 
  * O LoRa SX1276/77/78/79 é um rádio Half-duplex, ou seja, não é possível enviar
  * e transmitir dados ao mesmo tempo.
  * A cada transmissão de dados via lora_send_packet() e recepção de dados por lora_receive_packet()
  * automaticamente a api configura o LoRa como receptor lora_receive(), pois esse é o default;
*/

static void send(uint8_t * protocolo, uint16_t data)
{
    /**
    * Protocolo;
    * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
    */

    protocolo[0] = SLAVE_NODE_ADDRESS;   //slave address node;
    protocolo[1] = MASTER_NODE_ADDRESS;  //master address node;
    protocolo[2] = CMD_READ_COUNT;       //comando de leitura de Count;
    protocolo[3] = sizeof(data);         //2 bytes; 
    protocolo[4] = (UCHAR)(data & 0xFF);
    protocolo[5] = (UCHAR)((data >> 8) & 0xFF); 

    /**
     * Calcula o CRC do pacote;
     */
    USHORT usCRC = usLORACRC16(protocolo, 6);
    protocolo[6] = (UCHAR)(usCRC & 0xFF); 
    protocolo[7] = (UCHAR)((usCRC >> 8) & 0xFF);

    /**
     * Transmite protocol via LoRa;
     */
    lora_send_packet(protocolo, 8);

    if(DEBUG)
    {
        ESP_LOGI(TAG, "Mensagem enviada: %d", data);
    }
}