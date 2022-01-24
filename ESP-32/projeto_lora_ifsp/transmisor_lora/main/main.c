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
#include "nvs_flash.h"
#include "esp_spi_flash.h"

#include "esp_system.h"
#include "esp_spi_flash.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

#include "esp_log.h"

#include "lora.h"
#include "ssd1306.h"

/* Private define & constants ------------------------------------------------*/

static const char *TAG = "LoRa_Transmitter";

/**
 * LoRa device Address;
 */
const int MASTER_NODE_ADDRESS = 0;

#define LORA_RECEIVER_TIMEOUT_MS 5000

/* I2C Interface inicialization ----------------------------------------------*/

/*!< Config I²C Display OLED */
#define I2C_SDA_PIN CONFIG_I2C_SDA_PIN       /*!< default 4 */
#define I2C_SCL_PIN CONFIG_I2C_SCL_PIN       /*!< default 15 */
#define I2C_CHANNEL CONFIG_I2C_CHANNEL       /*!< default 0 */
#define OLED_PIN_RESET CONFIG_OLED_PIN_RESET /*!< default 16 */

/* Private variables ---------------------------------------------------------*/

/* Private tasks prototypes --------------------------------------------------*/

/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);
static void ssd1306_start(void);

void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_start();

    /*!< Inicia display  OLED 0.96"*/
    ssd1306_start();

    /*!< Inicia LoRa e seta frequência 915MHz*/
    lora_init();
    lora_set_frequency(915E6);

    /*!< Habilita CRC*/
    lora_enable_crc();
    /*!< Habilita a recepção LoRa via Interrupção Externa;*/
    lora_enable_irq();
}

/* Bodies of private tasks ---------------------------------------------------*/

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
    ssd1306_out16(0, 0, "Transmitter", WHITE);
    ssd1306_out8(2, 0, "Node Add:", WHITE);
    ssd1306_chr8(2, 9, MASTER_NODE_ADDRESS + '0', WHITE);
}