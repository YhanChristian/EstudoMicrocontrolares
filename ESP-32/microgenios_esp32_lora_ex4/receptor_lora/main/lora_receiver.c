/* Curso Formação IoT ESP32 - Utilizando ESP32 Heltec módulo LoRa SDK-IDF
   Módulo: Heltec Lora V2 - ESP32
   Exemplo 04: Receptor LoRa - comunicação Ponto a Ponto e MQTT
   Autor: Yhan Christian Souza Silva - data: 05/04/2020
   Descrição: Este projeto tem como criar um receptor LoRa, que ao receber um comando do Master enviará os dados
   conforme comandos descritos no firmware, neste exemplo será enviado o valor de um contador e exibido no display
   e enviado o nível de sinal RSSI do módulo Heltec. O transmissor ao receber esta informação publicará no broker MQTT.
   O frame LoRa de transmissão é composto de: 
   <id_node_sender> <id_node_receiver> <command> <payload_size> <payload> <crc>
   biblioteca lora.h dentro da pasta components (SDK-IDF)
*/

/**
 * Lib Standar C;
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

/**
 * FreeRTOS
 */
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include "freertos/queue.h"
#include "freertos/event_groups.h"

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
 * Lora CRC;
 */
#include "lora_crc.h"

/**
 * Lib Display SSD1306 Oled;
 * Atenção: Inclua este arquivo apenas 1x;
 * Caso contrário, inclua "lib_ss1306.h"
 */
#include "lib_heltec.h"
/**
 * Configurações de Rede;
 */
#include "sys_config.h"

/**
 * LoRa device Address;
 */
const int MASTER_NODE_ADDRESS = 0;

/**
 * ATENÇÃO: 
 * Defina aqui o endereço deste DISPOSITIVO; 1 a 255;
 * Cada dispositivo SLAVE precisa ter endereço diferente;
 */
const int SLAVE_NODE_ADDRESS = 1;

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
 * Protótipos;
 */
static void lora_data_send( uint8_t * protocol, char * message, uint8_t n_command ); 
static void task_rx( void *pvParameter );


static void lora_data_send( uint8_t * protocol, char * message, uint8_t n_command )
{
    /**
    * Protocolo;
    * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
    */
    protocol[0] = SLAVE_NODE_ADDRESS;   
    protocol[1] = MASTER_NODE_ADDRESS;  
    protocol[2] = n_command;            
    protocol[3] = strlen( message ) + 1;             
    
    strcpy( (char*)&protocol[4], message );
    
    /**
     * Calcula o CRC do pacote;
     */
    USHORT usCRC = usLORACRC16( protocol, 4 + protocol[3] );
    protocol[4 + protocol[3]] = (UCHAR)(usCRC & 0xFF); 
    protocol[5 + protocol[3]] = (UCHAR)((usCRC >> 8) & 0xFF);

    /**
     * Transmite protocol via LoRa;
     */
    lora_send_packet( protocol, 6 + protocol[3] );
    
    if( DEBUG )
        ESP_LOGI( TAG, "Mensagem enviada: %s", message );
}

/**
 * Task responsável pela recepção LoRa;
 */
static void task_rx( void *pvParameter )
{
   int x;
   char buf[50];
   uint8_t protocol[100];
   int cnt_1 = 0;
   int rssi = -1;
   float snr = -1;
   
   for( ;; ) 
   {
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
              USHORT usCRC = usLORACRC16( protocol, 4 + protocol[3] );
              UCHAR ucLow =  (UCHAR)(usCRC & 0xFF);
              UCHAR ucHigh = (UCHAR)((usCRC >> 8) & 0xFF);

              if( ucLow == protocol[4 + protocol[3]] && ucHigh == protocol[5 + protocol[3]] )
              {
                  if( DEBUG )
                      ESP_LOGI( TAG, "CRC OK!" );

                  /**
                   * Verifica qual o comando recebido;
                   */
                  switch( protocol[2] )
                  {
                      /**
                       * Comando para impressão no display Oled;
                       */
                      case CMD_READ_RSSI:
                            rssi = lora_packet_rssi();
                            snprintf( buf, sizeof(buf), "RSSI:%d dbm", rssi );
                            ssd1306_out8( 3, 0, buf, WHITE );
                            
                            snr = lora_packet_snr();
                            snprintf( buf, sizeof(buf), "SNR:%.2f", snr );
                            ssd1306_out8( 4, 0, buf, WHITE );

                            if( DEBUG )
                                ESP_LOGI( TAG, "RSSI:%d dbm SNR:%.2f", rssi, snr );
                            
                            vTaskDelay( 100/portTICK_PERIOD_MS );
                            /**
                             * Deseja enviar para o transmissor uma mensagem de confirmação
                             * de entrega de mensagem? Sim, então envie o comando de ACK;
                             */
                            snprintf( buf, sizeof(buf), "{\"node\":\"%d\",\"rssi\":\"%d\",\"snr\":\"%.2f\"}", SLAVE_NODE_ADDRESS, rssi, snr );
                            lora_data_send( protocol, buf, CMD_READ_RSSI );

                            break;
 
                      case CMD_PRINT_OLED:
                            ssd1306_out8( 5, 0, (char*)"Value:", WHITE );
                            ssd1306_out8( 5, 6, "       ", WHITE );
                            ssd1306_out8( 5, 6, (char*)&protocol[4], WHITE );
                            

                            vTaskDelay( 100/portTICK_PERIOD_MS );
                            /**
                             * Deseja enviar para o transmissor uma mensagem de confirmação
                             * de entrega de mensagem? Sim, então envie o comando de ACK;
                             */
                            snprintf( buf, sizeof(buf), "{\"node\":\"%d\",\"command\":\"%d\",\"ack\":\"ok\"}", SLAVE_NODE_ADDRESS, CMD_PRINT_OLED );
                            lora_data_send( protocol, buf, CMD_PRINT_OLED );

                            break;
                        /*     
                        case CMD_SET_GPIO:
                             gpio_set_level( LED_BUILDING, atoi( (char*)&protocol[4] ) );
                              break;
                        */
                      
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

    /**
    * Inicializa display Oled 128x64 SSD1306;
    * As configurações de pinagens do Oled são encontradas
    * em "lib_heltec.h";
    */
    ssd1306_start();
    /**
    * Imprime usando fonte8x16;
    * Sintaxe: ssd1306_out16( linha, coluna, ftring , fonte_color );
    */
    ssd1306_out16( 0, 0, "Receiver", WHITE );
    ssd1306_out8( 2, 0, "Node Add:", WHITE );
    ssd1306_chr8( 2, 9, SLAVE_NODE_ADDRESS + '0', WHITE );
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