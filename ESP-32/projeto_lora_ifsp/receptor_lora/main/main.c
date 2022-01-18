/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva 
  * @file       : main.c
  * @author     : Yhan Christian Souza Silva
  * @date       : 17/01/2021
  * @brief      : Arquivo fonte main.c com o projeto do receptor (SLAVE) que 
  *               aguarda comando do MASTER para envio dos dados lidos por um
  *               acelerômetro via LoRA em uma comunicação PaP.
  ******************************************************************************
*/

/* Includes ------------------------------------------------------------------*/

#include <stdio.h>
#include "nvs_flash.h"
#include "esp_spi_flash.h"

#include "esp_system.h"
#include "esp_event.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

#include "esp_log.h"

#include "lora.h"
#include "mpu6050.h"
#include "ssd1306.h"

/* Private define & constants ------------------------------------------------*/

static const char *TAG = "MPU6050";

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

/* I2C Interface inicialization ----------------------------------------------*/

/*!< Config I²C Display OLED */

#define I2C_SDA_PIN CONFIG_I2C_SDA_PIN       //default 4
#define I2C_SCL_PIN CONFIG_I2C_SCL_PIN       //default 15
#define I2C_CHANNEL CONFIG_I2C_CHANNEL       //default 0
#define OLED_PIN_RESET CONFIG_OLED_PIN_RESET //default 16

/*!< Config I²C MPU6050 */

#define I2C_MASTER_SCL_IO 22      /*!< gpio number for I2C master clock */
#define I2C_MASTER_SDA_IO 21      /*!< gpio number for I2C master data  */
#define I2C_MASTER_NUM I2C_NUM_1  /*!< I2C port number for master dev */
#define I2C_MASTER_FREQ_HZ 100000 /*!< I2C master clock frequency */

/* Private typedef -----------------------------------------------------------*/


/* Private tasks prototypes --------------------------------------------------*/

mpu6050_handle_t mpu6050 = NULL; 


/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);
static void ssd1306_start(void);
static void i2c_bus_init(void);
static void i2c_sensor_mpu6050_init(void);

void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_start();

    /*!< Inicia display  OLED 0.96"*/
    ssd1306_start();

    /*!< Inicia sensor acelerômetro MPU6050*/
    i2c_sensor_mpu6050_init();

    /*!< Inicia LoRa e seta frequência 915MHz*/
    lora_init();
    lora_set_frequency(915E6);
    
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

    /**
    * Imprime usando fonte8x16;
    * Sintaxe: ssd1306_out16( linha, coluna, ftring , fonte_color );
    */
    ssd1306_out16(0, 0, "Receiver", WHITE);
    ssd1306_out8(2, 0, "Node Add:", WHITE);
    ssd1306_chr8(2, 9, SLAVE_NODE_ADDRESS + '0', WHITE);
}
static void i2c_bus_init(void)
{
    i2c_config_t conf;
    conf.mode = I2C_MODE_MASTER;
    conf.sda_io_num = (gpio_num_t)I2C_MASTER_SDA_IO;
    conf.sda_pullup_en = GPIO_PULLUP_ENABLE;
    conf.scl_io_num = (gpio_num_t)I2C_MASTER_SCL_IO;
    conf.scl_pullup_en = GPIO_PULLUP_ENABLE;
    conf.master.clk_speed = I2C_MASTER_FREQ_HZ;
    conf.clk_flags = I2C_SCLK_SRC_FLAG_FOR_NOMAL;

    ESP_ERROR_CHECK(i2c_param_config(I2C_MASTER_NUM, &conf));
    ESP_ERROR_CHECK(i2c_driver_install(I2C_MASTER_NUM, conf.mode, 0, 0, 0));
}
static void i2c_sensor_mpu6050_init(void)
{
    i2c_bus_init();
    mpu6050 = mpu6050_create(I2C_MASTER_NUM, MPU6050_I2C_ADDRESS);
    ESP_ERROR_CHECK(mpu6050_config(mpu6050, ACCE_FS_4G, GYRO_FS_500DPS));
    ESP_ERROR_CHECK(mpu6050_wake_up(mpu6050));
}

/* Bodies of private tasks ---------------------------------------------------*/
