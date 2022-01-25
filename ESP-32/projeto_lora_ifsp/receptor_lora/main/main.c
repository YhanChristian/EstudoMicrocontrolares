/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva 
  * @file       : main.c
  * @author     : Yhan Christian Souza Silva
  * @date       : 17/01/2022
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
#include "lora_crc.h"
#include "mpu6050.h"
#include "ssd1306.h"

/* Private define & constants ------------------------------------------------*/

static const char *TAG = "LoRa_Receiver";

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

mpu6050_handle_t mpu6050 = NULL;

/* Private typedef -----------------------------------------------------------*/

mpu6050_acce_gyro_value_t MPU6050_Data;

/* Private variables ---------------------------------------------------------*/

/* Private tasks prototypes --------------------------------------------------*/

static void vLoRaRxTask(void *pvParameter);

/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);
static void ssd1306_start(void);
static void i2c_bus_init(void);
static void i2c_sensor_mpu6050_init(void);
static void mpu6050_read(void);
static void lora_data_send(uint8_t *protocol, char *message);

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

    /*!< Habilita CRC*/
    lora_enable_crc();
    /*!< Habilita a recepção LoRa via Interrupção Externa;*/
    lora_enable_irq();

    /*!< Cria a task de recepção LoRa*/
    if (xTaskCreate(vLoRaRxTask, "vLoRaRxTask", configMINIMAL_STACK_SIZE + 8192, NULL, 5, NULL) != pdTRUE)
    {
        ESP_LOGE("ERROR", "*** vLoRaRxTask error ***\n");
    }
}

/* Bodies of private tasks ---------------------------------------------------*/

static void vLoRaRxTask(void *pvParameter)
{
    int x;
    char buf[50];
    uint8_t protocol[100];
    int count = 0;
    while (true)
    {
        /*!< Recebe dado fila e verifica se bytes foram recebidos*/

        xQueueReceive(xQueue_LoRa, &count, portMAX_DELAY);

        /**
       * Algum byte foi recebido?
       * Realiza a leitura dos registradores de status do LoRa com o 
       * objetivo de verificar se algum byte recebido foi armazenado
       * na FIFO do rádio;
       */

        while (lora_received())
        {

            /**
          * Sim, existe bytes na FIFO do rádio LoRa, portanto precisamos ler
          * esses bytes; A variável buf armazenará os bytes recebidos pelo LoRa;
          * x -> armazena a quantidade de bytes que foram populados em buf;
          */
            x = lora_receive_packet(protocol, sizeof(protocol));

            /**
           * Protocolo;
           * <id_node_sender><id_node_receiver><command><payload_size><payload><crc>
           */
            if (x >= 6 && protocol[0] == MASTER_NODE_ADDRESS && protocol[1] == SLAVE_NODE_ADDRESS)
            {
                /**
                 * Verifica CRC;
                 */
                USHORT usCRC = usLORACRC16(protocol, 3 + protocol[3] + 1);
                UCHAR ucLow = (UCHAR)(usCRC & 0xFF);
                UCHAR ucHigh = (UCHAR)((usCRC >> 8) & 0xFF);

                if (ucLow == protocol[4] && ucHigh == protocol[5])
                {
                    switch (protocol[2])
                    {
                    case CMD_READ_MPU6050:
                        ESP_LOGI(TAG, "DEVICE: %d. Comando CMD_READ_MPU6050 recebido ...", SLAVE_NODE_ADDRESS);
                        /**
                        * Leitura do acelerômetro e envio de pacote para  o transmissor;
                        */
                        mpu6050_read();

                        break;
                    }
                }
            }
        }

        /*!< Delay entre cada leitura dos registradores de status do LoRa*/
        vTaskDelay(10 / portTICK_RATE_MS);
    }
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

static void mpu6050_read(void)
{
    mpu6050_acce_value_t acce;
    mpu6050_gyro_value_t gyro;

    mpu6050_get_acce(mpu6050, &acce);
    mpu6050_get_gyro(mpu6050, &gyro);

    MPU6050_Data.acce_data = acce;
    MPU6050_Data.gyro_data = gyro;
    ESP_LOGI(TAG, "accX:%.2f\n", MPU6050_Data.acce_data.acce_x);
    ESP_LOGI(TAG, "accY:%.2f\n", MPU6050_Data.acce_data.acce_y);
    ESP_LOGI(TAG, "accZ:%.2f\n", MPU6050_Data.acce_data.acce_z);
    ESP_LOGI(TAG, "gyroX:%.2f\n", MPU6050_Data.gyro_data.gyro_x);
    ESP_LOGI(TAG, "gyroY:%.2f\n", MPU6050_Data.gyro_data.gyro_y);
    ESP_LOGI(TAG, "gyroZ:%.2f\n", MPU6050_Data.gyro_data.gyro_z);
}

static void lora_data_send(uint8_t *protocol, char *message)
{
}
