/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : main.c
 * @author     : Yhan Christian Souza Silva
 * @date       : 24/01/2022
 * @brief      : Arquivo fonte main.c com o projeto do transmissor (MASTER) que
 *               envia um comando ao módulo SLAVE para receber dados do sensor
 *               acelerômetro (MPU6050) via LoRa em uma comunicação PaP.
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>

#include "nvs_flash.h"
#include "esp_spi_flash.h"
#include "esp_system.h"
#include "esp_log.h"
#include "esp_event.h"

#include <esp_wifi.h>
#include <esp_netif.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include "freertos/queue.h"
#include "freertos/event_groups.h"

#include "lora.h"
#include "lora_crc.h"
#include "ssd1306.h"
#include "wifi_manager.h"
#include "esp32_mqtt.h"
#include "cJSON.h"
#include "mqtt_client.h"

/* Private define & constants ------------------------------------------------*/

static const char *TAG = "LoRa_Transmitter";

/**
 * LoRa device Address;
 */
const int MASTER_NODE_ADDRESS = 0;

/**
 * LoRa devices (qtde de Slaves = no caso estou utilizando 1 dispositivo
 * slave no END 1  e o master no END 0);
 */
#define LORA_TOTAL_NODES 1

#define LORA_RECEIVER_TIMEOUT_MS 5000

#define CMD_READ_MPU6050 1

/* I2C Interface inicialization ----------------------------------------------*/

/*!< Config I²C Display OLED */
#define I2C_SDA_PIN CONFIG_I2C_SDA_PIN       /*!< default 4 */
#define I2C_SCL_PIN CONFIG_I2C_SCL_PIN       /*!< default 15 */
#define I2C_CHANNEL CONFIG_I2C_CHANNEL       /*!< default 0 */
#define OLED_PIN_RESET CONFIG_OLED_PIN_RESET /*!< default 16 */

/* Global variables -----------------------------------------------------------*/

char str_ip[16];

static const char *MQTT_TOPIC = "ifsp/projetolora";

/* FreeRTOS section - Handles and tasks prototypes ----------------------------*/

static void vLoRaTxTask(void *pvParameter);
static void vMQTT_PublishTask(void *pvParameter);
// static void vMonitoringTask(void *pvParameter);

static EventGroupHandle_t wifi_connected_event_group;
const static int WIFI_CONNECTED = BIT0;

QueueHandle_t sensor_data_queue;
SemaphoreHandle_t mqtt_connected_mutex;

extern esp_mqtt_client_handle_t client;

/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);
static void ssd1306_start(void);
static void lora_received_data(void);
void cb_connection_ok(void *pvParameter);

void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_start();

    /*!< Inicia display  OLED 0.96"*/
    ssd1306_start();

    /*!< Cria grupo de evento para sinalizar conexão WiFi */
    wifi_connected_event_group = xEventGroupCreate();

    /*!< Cria semaforo Mutex para sinalizar enivo dados MQTT*/
    mqtt_connected_mutex = xSemaphoreCreateMutex();

    /*!< Cria fila para armazenamento dos dados lidos sensor*/
    sensor_data_queue = xQueueCreate(10, sizeof(char *));

    /*!< Inicia conexão WiFi manager */
    wifi_manager_start();

    /*!< register a callback as an example to how you can integrate your code with the wifi manager */
    wifi_manager_set_callback(WM_EVENT_STA_GOT_IP, &cb_connection_ok);

    /**
     * Aguarda conexão WiFi para processar Task
     */
    xEventGroupWaitBits(wifi_connected_event_group, WIFI_CONNECTED, false, true, portMAX_DELAY);

    /*!< Inicia LoRa e seta frequência 915MHz*/
    lora_init();
    lora_set_frequency(915E6);

    /*!< Habilita CRC*/
    lora_enable_crc();
    /*!< Habilita a recepção LoRa via Interrupção Externa;*/
    lora_enable_irq();

    /*!< Cria a task de transmissão LoRa*/
    if (xTaskCreate(vLoRaTxTask, "vLoRaTxTask", configMINIMAL_STACK_SIZE + 8192, NULL, 5, NULL) != pdTRUE)
    {
        ESP_LOGE("ERROR", "*** vLoRaTxTask error ***\n");
    }

    if (xTaskCreate(vMQTT_PublishTask, "vMQTT_PublishTask", configMINIMAL_STACK_SIZE + 10240, NULL, 5, NULL) != pdTRUE)
    {
        ESP_LOGE("ERROR", "*** vMQTT_PublishTask error ***\n");
    }

    /*
        if (xTaskCreatePinnedToCore(&vMonitoringTask, "vMonitoringTask", 2048, NULL, 1, NULL, 1) != pdTRUE)
        {
            ESP_LOGE("ERROR", "*** vMonitoringTask error ***\n");
        }
       */
}

/* Bodies of private tasks ---------------------------------------------------*/

static void vLoRaTxTask(void *pvParameter)
{
    uint8_t protocol[100];
    for (;;)
    {

        if (xSemaphoreTake(mqtt_connected_mutex, portMAX_DELAY))
        {
            /**
             * Protocolo;
             * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
             */

            protocol[0] = MASTER_NODE_ADDRESS;
            protocol[1] = LORA_TOTAL_NODES;
            protocol[2] = CMD_READ_MPU6050;
            protocol[3] = 0;

            /**
             * Calcula o CRC do pacote;
             */
            USHORT usCRC = usLORACRC16(protocol, 4);
            protocol[4] = (UCHAR)(usCRC & 0xFF);
            protocol[5] = (UCHAR)((usCRC >> 8) & 0xFF);

            /**
             * Transmite protocol via LoRa;
             */
            lora_send_packet(protocol, 6);

            ESP_LOGI(TAG, "Pacote Enviado para node = %d ", LORA_TOTAL_NODES);

            vTaskDelay(10 / portTICK_RATE_MS);

            /**
             * Chama a função que irá receber os dados do acelerômetro, enviado pelo receptor;
             */
            lora_received_data();

            vTaskDelay(600E3 / portTICK_RATE_MS);
            xSemaphoreGive(mqtt_connected_mutex);
        }
    }
}

static void vMQTT_PublishTask(void *pvParameter)
{
    /*!< Inicio MQTT configurando Broker, User, ETC*/
    mqtt_app_start();

    char *pcRecebeDados;

    for (;;)
    {
        if (xSemaphoreTake(mqtt_connected_mutex, portMAX_DELAY))
        {

            if (xQueueReceive(sensor_data_queue, &pcRecebeDados, 0) == pdPASS)
            // if (xQueueReceive(sensor_data_queue, &pcRecebeDados, portMAX_DELAY))
            {
                ESP_LOGI(TAG, "Task MQTT Data: %s", pcRecebeDados);
                vTaskDelay(10 / portTICK_RATE_MS);
                esp_mqtt_client_publish(client, MQTT_TOPIC, pcRecebeDados, 0, 1, 0);
                free(pcRecebeDados);
            }

            vTaskDelay(10 / portTICK_RATE_MS);
            xSemaphoreGive(mqtt_connected_mutex);
        }
    }
}

/*
static void vMonitoringTask(void *pvParameter)
{
    for (;;)
    {

        ESP_LOGI(TAG, "free heap: %d", esp_get_free_heap_size());
        vTaskDelay(10000 / portTICK_RATE_MS);
    }
}
*/
/* Bodies of private functions -----------------------------------------------*/

static void esp32_start(void)
{
    /* Print chip information */
    esp_chip_info_t chip_info;
    esp_chip_info(&chip_info);
    printf("This is ESP32 chip with %d CPU cores, WiFi%s%s, ",
           chip_info.cores,
           (chip_info.features & CHIP_FEATURE_BT) ? "/BT" : "",
           (chip_info.features & CHIP_FEATURE_BLE) ? "/BLE" : "");

    printf("silicon revision %d, ", chip_info.revision);

    printf("%dMB %s flash\n", spi_flash_get_chip_size() / (1024 * 1024),
           (chip_info.features & CHIP_FEATURE_EMB_FLASH) ? "embedded" : "external");

    // Initialize NVS
    esp_err_t err = nvs_flash_init();
    if (err == ESP_ERR_NVS_NO_FREE_PAGES || err == ESP_ERR_NVS_NEW_VERSION_FOUND)
    {
        // NVS partition was truncated and needs to be erased
        // Retry nvs_flash_init
        ESP_ERROR_CHECK(nvs_flash_erase());
        err = nvs_flash_init();
    }
    ESP_ERROR_CHECK(err);
}

static void ssd1306_start(void)
{
    ssd1306_config(I2C_SDA_PIN, I2C_SCL_PIN, I2C_CHANNEL, OLED_PIN_RESET);
    ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
    ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
    ssd1306_out8(3, 2, "Waiting WiFi", WHITE);
    ssd1306_out8(4, 3, "Connection", WHITE);
}

static void lora_received_data(void)
{
    int x;
    int count = 0;
    uint8_t protocol[150];

    if (xQueueReceive(xQueue_LoRa, &count, LORA_RECEIVER_TIMEOUT_MS / portTICK_PERIOD_MS) == pdTRUE)
    {
        while (lora_received())
        {
            x = lora_receive_packet(protocol, sizeof(protocol));
            /**
             * Protocolo;
             * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
             */
            if (x >= 6 && protocol[1] == MASTER_NODE_ADDRESS)
            {
                /**
                 * Verifica CRC;
                 */
                USHORT usCRC = usLORACRC16(protocol, 3 + protocol[3] + 1);
                UCHAR ucLow = (UCHAR)(usCRC & 0xFF);
                UCHAR ucHigh = (UCHAR)((usCRC >> 8) & 0xFF);

                if (ucLow == protocol[3 + protocol[3] + 1] && ucHigh == protocol[3 + protocol[3] + 2])
                {
                    ESP_LOGI(TAG, "CRC OK!");
                    switch (protocol[2])
                    {
                    case CMD_READ_MPU6050:

                        ESP_LOGI(TAG, "Dados recebidos MPU6050 - Receiver: %d", LORA_TOTAL_NODES);

                        // ESP_LOGI(TAG, "Dados recebidos MPU6050 - Receiver: %d Data: %s\n\n", LORA_TOTAL_NODES,(char *)&protocol[4]);

                        char *pcData = malloc(strlen((char *)&protocol[4]) + 1);

                        strcpy(pcData, (char *)&protocol[4]);

                        /*!< Coloca na fila a string recebida via LoRa*/
                        if (xQueueSend(sensor_data_queue, &pcData, (100 / portTICK_RATE_MS)) == pdPASS)
                        {
                            ESP_LOGI(TAG, "Envia dados fila: %s", pcData);
                        }

                        ssd1306_clear();
                        ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
                        ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
                        ssd1306_out8(3, 0, "IP: ", WHITE);
                        ssd1306_out8(3, 3, str_ip, WHITE);
                        ssd1306_out8(5, 0, "ACK: 0", WHITE);
                        ssd1306_out8(5, 8, "Rec.: ", WHITE);
                        ssd1306_chr8(5, 13, LORA_TOTAL_NODES + '0', WHITE);
                        break;
                    }
                }

                else
                {
                    ESP_LOGI(TAG, "CRC ERROR!");
                    ssd1306_clear();
                    ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
                    ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
                    ssd1306_out8(3, 0, "IP: ", WHITE);
                    ssd1306_out8(3, 3, str_ip, WHITE);
                    ssd1306_out8(5, 0, "CRC Error", WHITE);
                }
            }
        }
        vTaskDelay(10 / portTICK_PERIOD_MS);
    }
    else
    {
        ESP_LOGI(TAG, "timeout!");
        ssd1306_clear();
        ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
        ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
        ssd1306_out8(3, 0, "IP: ", WHITE);
        ssd1306_out8(3, 3, str_ip, WHITE);
        ssd1306_out8(5, 0, "ACK: -1", WHITE);
        ssd1306_out8(5, 8, "Timeout", WHITE);
    }
}

void cb_connection_ok(void *pvParameter)
{
    xEventGroupSetBits(wifi_connected_event_group, WIFI_CONNECTED);
    ip_event_got_ip_t *param = (ip_event_got_ip_t *)pvParameter;
    /* transform IP to human readable string */
    esp_ip4addr_ntoa(&param->ip_info.ip, str_ip, IP4ADDR_STRLEN_MAX);
    ESP_LOGI(TAG, "I have a connection and my IP is %s!", str_ip);
    ssd1306_clear();
    ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
    ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
    ssd1306_out8(3, 0, "IP: ", WHITE);
    ssd1306_out8(3, 3, str_ip, WHITE);
}