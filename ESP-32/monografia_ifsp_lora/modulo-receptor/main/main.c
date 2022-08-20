/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : main.c
 * @author     : Yhan Christian Souza Silva
 * @date       :03/08/2022
 * @brief      : Arquivo fonte main.c com o projeto do receptor (SLAVE) que
 *               aguarda comando do MASTER para envio dos dados lidos por um
 *               acelerômetro realiza o cálculo dos sguintes parâmetros:
 *                 - Velocidade (RMS)
 *                 - Aceleração (RMS e Pico)
 *
 *              E por fim,  envia LoRA em uma comunicação PaP.
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <math.h>

#include "nvs_flash.h"
#include "esp_spi_flash.h"

#include "esp_system.h"
#include "esp_event.h"
#include "esp_log.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include "freertos/queue.h"

#include "mpu6050.h"
#include "lora.h"

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

/**
 * Define Tempo aquisição sensor.
 */

#define SAMPLES 1024
#define SAMPLE_TIME 1000
#define CALC_SAMPLE_TIME (float)SAMPLE_TIME / SAMPLES

/**
 * Define uso constantes math.h
 */

#define _USE_MATH_DEFINES

/**
 * Define utilizado para obter máximo e mínimo
 */

#define min(a, b) (((a) < (b)) ? (a) : (b))
#define max(a, b) (((a) > (b)) ? (a) : (b))

/**
 * Define qtde de eixos (3 = x,y,z)
 */
#define AXIS_READ 3

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

typedef struct
{
    float acel_avg[AXIS_READ];
    float acel_rms[AXIS_READ];
    float acel_max[AXIS_READ];
    float acel_min[AXIS_READ];
    float vel_rms[AXIS_READ];
    float temp;

} sensor_data_t;

/* Private variables ---------------------------------------------------------*/

/* FreeRTOS section - Handles and tasks prototypes ----------------------------*/

static void vMPU6050Task(void *pvParameter);
static void vTaskLoRa(void *pvParameter);

QueueHandle_t sensor_data_queue = NULL;

/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);
static void i2c_bus_init(void);
static void i2c_sensor_mpu6050_init(void);

/* app_main function body ----------------------------------------------------*/

void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_start();

    /*!< Inicia sensor acelerômetro MPU6050*/
    i2c_sensor_mpu6050_init();

    /*!<Criação de Fila para armezar dados da struct*/
    sensor_data_queue = xQueueCreate(10, sizeof(sensor_data_t));

    if (sensor_data_queue == NULL)
    {
        ESP_LOGE("ERROR", "*** sensor_data_queue Create error ***\n");
    }

    /*!<Criação de Tasks*/

    if (xTaskCreate(vMPU6050Task, "vMPU6050Task", configMINIMAL_STACK_SIZE + 8192, NULL, 5, NULL) != pdTRUE)
    {
        ESP_LOGE("ERROR", "*** vMPU6050Task error ***\n");
    }

    if (xTaskCreate(vTaskLoRa, "vTaskLoRa", configMINIMAL_STACK_SIZE + 8192, NULL, 5, NULL) != pdTRUE)
    {
        ESP_LOGE("ERROR", "*** vTaskLoRa error ***\n");
    }
}

/* Bodies of private tasks ---------------------------------------------------*/

static void vMPU6050Task(void *pvParameter)
{
    sensor_data_t Sensor_Data;
    for (;;)
    {
        for (uint16_t i = 0; i < SAMPLES; i++)
        {

            mpu6050_acce_value_t MPU6050_Acce_Data;
            mpu6050_temp_value_t MPU6050_Temp_Data;

            mpu6050_get_acce(mpu6050, &MPU6050_Acce_Data);
            mpu6050_get_temp(mpu6050, &MPU6050_Temp_Data);

            Sensor_Data.acel_max[0] = max(MPU6050_Acce_Data.acce_x, Sensor_Data.acel_max[0]);
            Sensor_Data.acel_max[1] = max(MPU6050_Acce_Data.acce_y, Sensor_Data.acel_max[1]);
            Sensor_Data.acel_max[2] = max(MPU6050_Acce_Data.acce_z, Sensor_Data.acel_max[2]);

            Sensor_Data.acel_min[0] = min(MPU6050_Acce_Data.acce_x, Sensor_Data.acel_min[0]);
            Sensor_Data.acel_min[1] = min(MPU6050_Acce_Data.acce_y, Sensor_Data.acel_min[1]);
            Sensor_Data.acel_min[2] = min(MPU6050_Acce_Data.acce_z, Sensor_Data.acel_min[2]);

            Sensor_Data.acel_avg[0] += MPU6050_Acce_Data.acce_x;
            Sensor_Data.acel_avg[1] += MPU6050_Acce_Data.acce_y;
            Sensor_Data.acel_avg[2] += MPU6050_Acce_Data.acce_z;
            Sensor_Data.temp += MPU6050_Temp_Data.temp;
        }

        /*!< Calculo de acel (média), RMS, vel e vel RMS*/

        Sensor_Data.acel_avg[0] = Sensor_Data.acel_avg[0] / SAMPLES;
        Sensor_Data.acel_avg[1] = Sensor_Data.acel_avg[1] / SAMPLES;
        Sensor_Data.acel_avg[2] = Sensor_Data.acel_avg[2] / SAMPLES;
        Sensor_Data.temp = Sensor_Data.temp / SAMPLES;

        Sensor_Data.acel_rms[0] = Sensor_Data.acel_avg[0] * M_SQRT1_2;
        Sensor_Data.acel_rms[1] = Sensor_Data.acel_avg[1] * M_SQRT1_2;
        Sensor_Data.acel_rms[2] = Sensor_Data.acel_avg[2] * M_SQRT1_2;

        Sensor_Data.vel_rms[0] = (Sensor_Data.acel_avg[0] * CALC_SAMPLE_TIME) * M_SQRT1_2;
        Sensor_Data.vel_rms[1] = (Sensor_Data.acel_avg[1] * CALC_SAMPLE_TIME) * M_SQRT1_2;
        Sensor_Data.vel_rms[2] = (Sensor_Data.acel_avg[2] * CALC_SAMPLE_TIME) * M_SQRT1_2;

        /*!< Coloca dados na fila e verifica se n houve falhas*/

        if (xQueueSend(sensor_data_queue, (void *)&Sensor_Data, (TickType_t)0) == pdTRUE)
        {
            ESP_LOGI(TAG, "%s", "Dados da struct Sensor_Data enviados fila ");
        }
        else
        {
            ESP_LOGE("ERROR", "*** Erro ao inserir dados fila ***\n");
        }

        vTaskDelay(SAMPLE_TIME / portTICK_RATE_MS);
    }
}

static void vTaskLoRa(void *pvParameter)
{
    sensor_data_t Sensor_Data_Received;
    for (;;)
    {

        /*!< Verifica  dados fila e imprime pelos sensores*/
        if (xQueueReceive(sensor_data_queue, &(Sensor_Data_Received), (TickType_t)0) == pdPASS)
        {
            ESP_LOGI(TAG, "aX:%.2f aY:%.2f aZ:%.2f",
                     Sensor_Data_Received.acel_avg[0], Sensor_Data_Received.acel_avg[1],
                     Sensor_Data_Received.acel_avg[2]);

            ESP_LOGI(TAG, "aX_RMS:%.2f ay_RMS:%.2f az_RMS:%.2f",
                     Sensor_Data_Received.acel_rms[0], Sensor_Data_Received.acel_rms[1],
                     Sensor_Data_Received.acel_rms[2]);

            ESP_LOGI(TAG, "aX_max:%.2f aY_max:%.2f aZ_max:%.2f",
                     Sensor_Data_Received.acel_max[0], Sensor_Data_Received.acel_max[1],
                     Sensor_Data_Received.acel_max[2]);

            ESP_LOGI(TAG, "aX_min:%.2f aY_min:%.2f aZ_min:%.2f",
                     Sensor_Data_Received.acel_min[0], Sensor_Data_Received.acel_min[1],
                     Sensor_Data_Received.acel_min[2]);

            ESP_LOGI(TAG, "vx_RMS:%.2f vy_RMS:%.2f vz_RMS:%.2f",
                     Sensor_Data_Received.vel_rms[0], Sensor_Data_Received.vel_rms[1],
                     Sensor_Data_Received.vel_rms[2]);

            ESP_LOGI(TAG, "t:%.2f", Sensor_Data_Received.temp);

        }

        vTaskDelay(100 / portTICK_RATE_MS);
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