/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : main.c
 * @author     : Yhan Christian Souza Silva
 * @date       : 03/08/2022
 * @brief      : Arquivo fonte main.c com o projeto do transmissor (MASTER) que
 *               envia um comando ao módulo SLAVE para receber dados do sensor
 *               acelerômetro (MPU6050) com os seguintes parâmetros calculados
 *               - Velocidade (RMS)
 *               - Aceleração (RMS e Pico)
 *               via LoRa em uma comunicação PaP.
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

#include "nvs_flash.h"
#include "esp_spi_flash.h"

#include "esp_system.h"
#include "esp_event.h"
#include "esp_log.h"

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
#include "mqtt_client.h"

/* Private define & constants ------------------------------------------------*/

static const char *TAG = "LoRa_Transceiver";

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

/*!< Config I²C MPU6050 */
#define I2C_MASTER_SCL_IO 22      /*!< gpio number for I2C master clock */
#define I2C_MASTER_SDA_IO 21      /*!< gpio number for I2C master data  */
#define I2C_MASTER_NUM I2C_NUM_1  /*!< I2C port number for master dev */
#define I2C_MASTER_FREQ_HZ 100000 /*!< I2C master clock frequency */

/* Global variables -----------------------------------------------------------*/

char str_ip[16];

static const char *MQTT_TOPIC = "ifsp/monografia-lora";

/* FreeRTOS section - Handles and tasks prototypes ----------------------------*/

static void vLoRaTxTask(void *pvParameter);
static void vMQTTPublishTask(void *pvParameter);

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

/* app_main function body ----------------------------------------------------*/

void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_start();

    /*!< Inicia display  OLED 0.96"*/
    ssd1306_start();

    /*!< Cria semaforo Mutex para sinalizar envio dados MQTT*/
    mqtt_connected_mutex = xSemaphoreCreateMutex();

    if (mqtt_connected_mutex == NULL)
    {
        ESP_LOGE("ERROR", "*** mqtt_connected_mutex Create error ***\n");
    }

    /*!< Cria fila para armazenamento dos dados lidos sensor*/
    sensor_data_queue = xQueueCreate(10, sizeof(char *));

    if (sensor_data_queue == NULL)
    {
        ESP_LOGE("ERROR", "*** sensor_data_queue Create error ***\n");
    }

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
}

/* Bodies of private tasks ---------------------------------------------------*/

static void vLoRaTxTask(void *pvParameter)
{
    for (;;)
}

static void vMQTTPublishTask(void *pvParameter)
{
    for (;;)
}

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