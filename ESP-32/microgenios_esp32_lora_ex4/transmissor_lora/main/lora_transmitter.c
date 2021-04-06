/* Curso Formação IoT ESP32 - Utilizando ESP32 Heltec módulo LoRa SDK-IDF
   Módulo: Heltec Lora V2 - ESP32
   Exemplo 04: Transimissor LoRa - comunicação Ponto a Ponto e MQTT
   Autor: Yhan Christian Souza Silva - data: 05/04/2020
   Descrição: Este projeto tem como objetivo criar um transmissor (MASTER) que transmite uma requisição
   de dados ao SLAVE a partir de um comando recebido do BROKER MQTT, interpreta o json recebido
   e envia um comando ao SLAVE, aguarda o retorno do SLAVe e publica a informação no Broker MQTT
   é utilizado validação de dados CRC 16bits conforme exemplos anteriores.
   O frame LoRa de transmissão é composto de: 
   <id_node_sender> <id_node_receiver> <command> <payload_size> <payload> <crc>
   biblioteca lora.h dentro da pasta components (SDK-IDF)
*/


/*
#define CMD_READ_COUNT 0
#define CMD_READ_ADC   1
#define CMD_SET_GPIO   2
#define CMD_PRINT_OLED 3
#define CMD_READ_RSSI  4

 * comandos:
 * Escreve no display Oled o valor 545 do node 1 e 
 * {"node":"1","command":"3","value":"545"}
 * retorno: {"node":"1","command":"3","ack":"ok"}
 * 
 * Realiza a leitura do RSSI e SNR do node 1;
 * {"node":"1","command":"4"}
 * retorno: {"node":"1","rssi":"-47","snr":"9.75"}
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
 * Drivers
 */
#include "nvs_flash.h"

/**
 * Lib LoRa;
 * Localizado em Componentes > lora;
 */
#include "lora.h"

/**
 * Log
 */
#include "esp_system.h"
#include "esp_err.h"
#include "esp_log.h"

/**
 * Drivers
 */
#include "driver/gpio.h"

/**
 * Lora CRC;
 */
#include "lora_crc.h"

/**
 * Lib Display SSD1306 Oled;
 */
#include "lib_heltec.h"

/**
 * Configurações de Rede;
 */
#include "sys_config.h"

/**
 * LWIP
 */
#include "lwip/sockets.h"
#include "lwip/dns.h"
#include "lwip/netdb.h"

/**
 * WiFi Callback
 */
#include "esp_event_loop.h"

/**
 * WiFi
 */
#include "esp_wifi.h"

/**
 * MQTT User;
 */
#include "mqtt.h"


/**
 * Endereçamento dos dispositivos da rede LoRa;
 * O MASTER sempre será o inicializa a comunicação com os SLAVES;
 * O MASTER possui endereço 0, enquanto os SLAVES são enumerados de 1 a 1000;
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
const static int CONNECTED_BIT = BIT0;
static EventGroupHandle_t wifi_event_group;
esp_mqtt_client_handle_t client;

/**
 * Protótipos
 */
static esp_err_t wifi_event_handler( void *ctx, system_event_t *event );
static void wifi_init_sta( void );

static void lora_data_received( void );
void lora_data_send( char * node_address, char * command, char * value );


static void lora_data_received( void )
{
    int x;
    int cnt_1 = 0;
    uint8_t protocol[100];

    if( xQueueReceive( xQueue_LoRa, &cnt_1, LORA_RECEIVER_TIMEOUT_MS/portTICK_PERIOD_MS ) == pdTRUE )
    {
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


            if( DEBUG )
                ESP_LOGI( TAG, "%.*s  Size=%d", x, protocol, x );             
             /**
             * Protocolo;
             * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
             */
             if( x >= 6 && protocol[1] == MASTER_NODE_ADDRESS  )
             {
                  /**
                   * Verifica CRC;
                   */
                  USHORT usCRC = usLORACRC16( protocol, 3 + protocol[3] + 1);
                  UCHAR ucLow =  (UCHAR)(usCRC & 0xFF);
                  UCHAR ucHigh = (UCHAR)((usCRC >> 8) & 0xFF);

                  if( ucLow == protocol[3 + protocol[3] + 1] && ucHigh == protocol[3 + protocol[3] + 2] )
                  {
                      if( DEBUG )
                          ESP_LOGI( TAG, "CRC OK!" );

                      switch( protocol[2] )
                      {
                          case CMD_READ_RSSI:
                              if( mqtt_publish_data( (char *)&protocol[4], strlen((char*)&protocol[4]) ) == ESP_OK )
                              {
                                  //if( DEBUG )
                                      ESP_LOGI( TAG, "mqtt published %s", &protocol[4] );
                              }
                              return; 

                          case CMD_PRINT_OLED:
                              if( mqtt_publish_data( (char *)&protocol[4], strlen((char*)&protocol[4]) ) == ESP_OK )
                              {
                                  //if( DEBUG )
                                      ESP_LOGI( TAG, "mqtt published %s", &protocol[4] );
                              }
                              return;                         
                      }              
                  } else
                  {
                      if( DEBUG )
                        ESP_LOGI( TAG, "CRC ERROR!" );
                  }
              }
          }

        vTaskDelay( 1/portTICK_PERIOD_MS  );
    } else
    {
        if( DEBUG )
          ESP_LOGI( TAG, "timeout!" );
    }
}

/**
 * Task responsável pela transmissão Tx via LoRa;
 */
void lora_data_send( char * node_address, char * command, char * value )
{


   uint8_t protocol[100];
   int n_address = atoi( node_address );
   int n_command = atoi( command );

  /**
   * Protocolo;
   * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
   */
    protocol[0] = MASTER_NODE_ADDRESS; 
    protocol[1] = n_address;        
    protocol[2] = n_command;       
    protocol[3] = strlen(value) + 1;                   
    
    strncpy( (char*)&protocol[4], value, sizeof(protocol)-4 );
    
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
        ESP_LOGI( TAG, "packet sent..%d ", n_address ); 

    lora_data_received();

    /**
     * Delay;
     */
    vTaskDelay( 10/portTICK_PERIOD_MS  );

}

/**
 * Função de callback do WiFi;
 */
static esp_err_t wifi_event_handler( void *ctx, system_event_t *event )
{
    switch( event->event_id ) 
    {
        case SYSTEM_EVENT_STA_START:
            esp_wifi_connect();
            break;

        case SYSTEM_EVENT_STA_GOT_IP:
            xEventGroupSetBits( wifi_event_group, CONNECTED_BIT );
            break;

        case SYSTEM_EVENT_STA_DISCONNECTED:
            esp_wifi_connect();
            xEventGroupClearBits( wifi_event_group, CONNECTED_BIT );
            break;

        default:
            break;
    }
    return ESP_OK;
}

/**
 * Inicializa a rede WiFi em modo Station;
 */
static void wifi_init_sta( void )
{
    tcpip_adapter_init();

#if IP_FIXO
    /**
     * O ESP32 ROOT da rede Mesh é aquele que receber o endereço IP do Roteador; 
     * Deseja trabalhar com o endereço IP fixo na rede? Ou seja, deseja configurar
     * o ROOT com IP Statico? 
     */
    ESP_ERROR_CHECK(tcpip_adapter_dhcpc_stop(TCPIP_ADAPTER_IF_STA));
    tcpip_adapter_ip_info_t sta_ip;
    sta_ip.ip.addr = ipaddr_addr( IP_ADDRESS );
    sta_ip.gw.addr = ipaddr_addr( GATEWAY_ADDRESS );
    sta_ip.netmask.addr = ipaddr_addr( NETMASK_ADDRESS );
    tcpip_adapter_set_ip_info(WIFI_IF_STA, &sta_ip);
#endif

    ESP_ERROR_CHECK( esp_event_loop_init( wifi_event_handler, NULL ) );

    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));
    ESP_ERROR_CHECK(esp_wifi_set_storage(WIFI_STORAGE_RAM));

    wifi_config_t wifi_config = {
        .sta = {
            .ssid = WIFI_SSID,
            .password = WIFI_PASSWORD,
        },
    };
    ESP_ERROR_CHECK( esp_wifi_set_mode( WIFI_MODE_STA ) );
    ESP_ERROR_CHECK( esp_wifi_set_config( ESP_IF_WIFI_STA, &wifi_config ) );
    ESP_ERROR_CHECK( esp_wifi_start() );

    if( DEBUG )
    {
      ESP_LOGI(TAG, "start the WIFI SSID:[%s] password:[%s]", WIFI_SSID, "******");
      ESP_LOGI(TAG, "Waiting for wifi");    
    }

}

/**
 * Inicio do app;
 */
void app_main( void )
{
    /*
      Inicialização da memória não volátil para armazenamento de dados (Non-volatile storage (NVS)).
      **Necessário para realização da calibração do PHY. 
    */
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES) {
      ESP_ERROR_CHECK(nvs_flash_erase());
      ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    /*
       Event Group do FreeRTOS. 
       Só podemos enviar ou ler alguma informação TCP quando a rede WiFi estiver configurada, ou seja, 
       somente após o aceite de conexão e a liberação do IP pelo roteador da rede.
    */
    wifi_event_group = xEventGroupCreate();

   /**
    * Inicializa display Oled 128x64 SSD1306;
    * As configurações de pinagens do Oled são encontradas
    * em "lib_heltec.h";
    */
    ssd1306_start();
    ssd1306_out16( 0, 0, "Transmitter", WHITE );
    ssd1306_out8( 2, 0, "Node Add:", WHITE );
    ssd1306_chr8( 2, 9, MASTER_NODE_ADDRESS + '0', WHITE );

    /*
      Configura a rede WiFi.
    */
    wifi_init_sta();

    /**
     * Aguarda a conexão WiFi do ESP32 com o roteador;
     */
    xEventGroupWaitBits( wifi_event_group, CONNECTED_BIT, false, true, portMAX_DELAY );

    /**
     * Inicializa e configura a rede;
     */
    mqtt_start();

   /**
    * Inicializa LoRa utilizando as configurações
    * definidas via menuconfig -> componentes -> lora
    */
   lora_init();
   lora_set_frequency( 915e6 );
   lora_enable_crc();
   lora_enable_irq();


}