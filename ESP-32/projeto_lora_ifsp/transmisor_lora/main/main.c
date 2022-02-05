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
#include "lora_crc.h"
#include "ssd1306.h"

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

/* Private variables ---------------------------------------------------------*/

/* Private tasks prototypes --------------------------------------------------*/
static void vLoRaTxTask(void *pvParameter);

/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);
static void ssd1306_start(void);
static void lora_received_data(void);

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

    /*!< Cria a task de transmissão LoRa*/
    if (xTaskCreate(vLoRaTxTask, "vLoRaTxTask", configMINIMAL_STACK_SIZE + 8192, NULL, 5, NULL) != pdTRUE)
    {
        ESP_LOGE("ERROR", "*** vLoRaTxTask error ***\n");
    }
}

/* Bodies of private tasks ---------------------------------------------------*/

static void vLoRaTxTask(void *pvParameter)
{
    uint8_t protocol[100];
    while (true)
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

        /**
         * Chama a função que irá receber os dados do acelerômetro, enviado pelo receptor;
         */
        lora_received_data();

        vTaskDelay(5000 / portTICK_RATE_MS);
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
    ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
    ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
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
                        ESP_LOGI(TAG, "Dados recebidos MPU6050 - Receiver: %d, Data: %s", LORA_TOTAL_NODES, (char *)&protocol[4]);
                        ssd1306_clear();
                        ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
                        ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
                        ssd1306_out8(3, 0, "ACK: 0", WHITE);
                        ssd1306_out8(3, 8, "Rec.: ", WHITE);
                        ssd1306_chr8(3, 13, LORA_TOTAL_NODES + '0', WHITE);
                        break;
                    }
                }

                else
                {
                    ESP_LOGI(TAG, "CRC ERROR!");
                    ssd1306_clear();
                    ssd1306_out16(0, 0, "Trans. Addr:", WHITE);
                    ssd1306_chr16(0, 13, MASTER_NODE_ADDRESS + '0', WHITE);
                    ssd1306_out8(3, 0, "CRC Error", WHITE);
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
        ssd1306_out8(3, 0, "ACK: -1", WHITE);
        ssd1306_out8(3, 8, "Timeout", WHITE);
    }
}