/* Curso Formação IoT ESP32 - Utilizando ESP32 Heltec módulo LoRa SDK-IDF
   Módulo: Heltec Lora V2 - ESP32
   Exemplo 03: Receptor LoRa - comunicação Ponto a Ponto
   Autor: Yhan Christian Souza Silva - data: 31/03/2021
   Descrição: Este projeto tem como objetivo criar um receptor(SLAVE) que transmite a partir de um comando 
   do MASTER com a utilização de interrupção.
   O frame LoRa de transmissão é composto de: 
   <id_node_sender> <id_node_receiver> <command> <payload_size> <payload> <crc>
   biblioteca lora.h dentro da pasta components (SDK-IDF)
*/


/**
 * Lib Standar C;
 */
#include <stdio.h>
#include <string.h>

/**
 * FreeRTOs;
 */
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

/**
 * Lib LoRa;
 * Localizado em Componentes > lora;
 */
#include "lora.h"

/**
 * Logs;
 */
#include "esp_err.h"
#include "esp_log.h"

/**
 * Lib Display SSD1306 Oled;
 * Atenção: Inclua este arquivo apenas 1x;
 * Caso contrário, inclua "lib_ss1306.h"
 */
#include "lib_heltec.h"
 
/**
 * Lora CRC;
 */
#include "lora_crc.h"

/**
 * Debug?
 */
#define DEBUG 1

/**
 * LoRa device Address;
 */
#define MASTER_NODE_ADDRESS 0

/**
 * ATENÇÃO: 
 * Defina aqui o endereço deste DISPOSITIVO; 1 a 1000;
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


static void send( uint8_t * protocol, uint16_t data )
{
    /**
    * Protocolo;
    * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
    */
    protocol[0] = SLAVE_NODE_ADDRESS;   //slave address node;
    protocol[1] = MASTER_NODE_ADDRESS;  //master address node;
    protocol[2] = CMD_READ_COUNT;       //comando de leitura da variável counter;
    protocol[3] = sizeof(data);         //2 bytes; 
    protocol[4] = (UCHAR)(data & 0xFF);
    protocol[5] = (UCHAR)((data >> 8) & 0xFF); 
    
    /**
     * Calcula o CRC do pacote;
     */
    USHORT usCRC = usLORACRC16( protocol, 6 );
    protocol[6] = (UCHAR)(usCRC & 0xFF); 
    protocol[7] = (UCHAR)((usCRC >> 8) & 0xFF);

    /**
     * Transmite protocol via LoRa;
     */
    lora_send_packet( protocol, 8 );

    if( DEBUG )
        ESP_LOGI( TAG, "Mensagem enviada: %d", data );
}
/**
 * Task responsável pela recepção LoRa;
 */
static void task_rx( void *pvParameter )
{
   int x;
   uint8_t protocol[100];
   uint16_t counter = 0;
   int cnt_1 = 0;

   for( ;; ) 
   {

      /**
       * Aguarda o recebimento de um pacote de dados;
       *
       */
      xQueueReceive( xQueue_LoRa, &cnt_1, portMAX_DELAY );
      
      /**
       * Algum byte foi recebido?
       * Realiza a leitura dos registradores de status do LoRa com o 
       * objetivo de verificar se algum byte recebido foi armazenado
       * na FIFO do rádio;
       */
      while( lora_received() ) 
      {
           /**
            * Sim, existe bytes na FIFO do rádio LoRa, portanto precisamos ler
            * esses bytes; A variável buf armazenará os bytes recebidos pelo LoRa;
            * x -> armazena a quantidade de bytes que foram populados em buf;
            */
           x = lora_receive_packet( protocol, sizeof(protocol) );
           
           /**
           * Protocolo;
           * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
           */

           if( x >= 6 && protocol[0] == MASTER_NODE_ADDRESS && protocol[1] == SLAVE_NODE_ADDRESS )
           {
                /**
                 * Verifica CRC;
                 */
                USHORT usCRC = usLORACRC16( protocol, 3 + protocol[3] + 1);
                UCHAR ucLow =  (UCHAR)(usCRC & 0xFF);
                UCHAR ucHigh = (UCHAR)((usCRC >> 8) & 0xFF);

                if( ucLow == protocol[4] && ucHigh == protocol[5] )
                {
                    switch( protocol[2] )
                    {
                        case CMD_READ_COUNT: 

                              if( DEBUG )
                                  ESP_LOGI( TAG, "DEVICE: %d. Comando CMD_READ_COUNT recebido ...", SLAVE_NODE_ADDRESS );
                              
                              /**
                               * Envia o valor da variável counter para o transmissor;
                               */
                              send( protocol, counter++ );
                              
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
 * Inicio do app;
 */
void app_main( void )
{
    char message[30];

    /**
    * Inicializa display Oled 128x64 SSD1306;
    * As configurações de pinagens do Oled são encontradas
    * em "lib_heltec.h";
    */
   ssd1306_start();

   /**
    * Imprime usando fonte8x16;
    * Sintaxe: ssd1306_out16( linha, coluna, string , fonte_color );
    */
   snprintf( message, sizeof(message), "Address=%d", SLAVE_NODE_ADDRESS );
   ssd1306_out16( 0, 0, (char*) "Receptor", WHITE );
   ssd1306_out16( 3, 0, (char*) message, WHITE );

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
    * Habilita a recepção LoRa via Interrupção Externa;
    */
   lora_enable_irq();

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