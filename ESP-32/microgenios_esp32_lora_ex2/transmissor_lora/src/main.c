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
#define LORA_RECEIVER_TIMEOUT_MS 5000

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
   char messagem[50];
   
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

   snprintf( messagem, sizeof(messagem), "Address=%d", MASTER_NODE_ADDRESS );
   ssd1306_out8( 0, 0, (char*) "Transmissor", WHITE );
   ssd1306_out8( 1, 0, (char*) messagem, WHITE );

   /**
    * Inicializa LoRa utilizando as configurações
    * definidas via menuconfig -> componentes -> lora;
    * Por padrão, a Api LoRa inicializa o rádio em modo de recepção;
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
    * Cria a task de transmissão LoRa;
    */
   if( xTaskCreate( task_tx, "task_tx", 1024*5, NULL, 2, NULL ) != pdTRUE )
   {
      if( DEBUG )
         ESP_LOGI( TAG, "error - Nao foi possivel alocar task_tx.\r\n" );  
      return;   
   }
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
          

           /**
           * Calcula o CRC do pacote;
           */
          USHORT usCRC = usLORACRC16( protocolo, 4 );
          protocolo[4] = (UCHAR)(usCRC & 0xFF); 
          protocolo[5] = (UCHAR)((usCRC >> 8) & 0xFF);

           /**
           * Transmite protocol via LoRa;
           */
          lora_send_packet( protocolo, 6 );

          /**
           * Após a transmissão a API configura o LoRa em modo de recepção;
           */

          if( DEBUG )
          {
               ESP_LOGI(TAG, "Pacote Enviado para node = %d ", i); 
          }
              
      
          /**
           * Chama a função que irá receber o valor de Count, enviado pelo receptor;
           */
          read();

          /**
           * Delay;
           */
          vTaskDelay(10/portTICK_PERIOD_MS);

      }

  }

   /**
    * Esta linha não deveria ser executada...
    */
   vTaskDelete( NULL );
}


/**
 * Implementação Funções Auxiliares
 */

static void read(void)
{
    int x;
    uint8_t protocolo[100];

        /**
      * Aguarda durante LORA_RECEIVER_TIMEOUT_MS o recebimento de algum dado;
      */
     for(int i = 0; i < LORA_RECEIVER_TIMEOUT_MS; i++)
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

            if(x >= 6 && protocolo[1] == MASTER_NODE_ADDRESS)
            {
                  /**
                   * Verifica CRC;
                   */
                  USHORT usCRC = usLORACRC16( protocolo, 3 + protocolo[3] + 1);
                  UCHAR ucLow =  (UCHAR)(usCRC & 0xFF);
                  UCHAR ucHigh = (UCHAR)((usCRC >> 8) & 0xFF);

                  if(ucLow == protocolo[3 + protocolo[3] + 1] && ucHigh == protocolo[3 + protocolo[3] + 2])
                  {
                     switch(protocolo[2])
                     {
                        case CMD_READ_COUNT:
                                  /**
                                 * Imprime o valor de "Count" que foi incrementado pelo receptor a cada pacote
                                 * recebido;
                                 */
                                 ESP_LOGI( TAG, "Address = %d; Value = %d\n", protocolo[0], ((protocolo[5] << 8) | protocolo[4]));
                                vTaskDelay( 30/portTICK_PERIOD_MS  );
                                return; 
                     
                     }
                  }               
            }
         
        }
        vTaskDelay( 1/portTICK_PERIOD_MS  );
     }
}