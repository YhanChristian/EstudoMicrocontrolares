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

/* FreeRTOS section - Handles and tasks prototypes ----------------------------*/

/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);

void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_start();
}

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