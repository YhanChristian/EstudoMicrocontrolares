/* Hello World Example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/

/* Includes ------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "sdkconfig.h"

#include "driver/gpio.h"

#include "esp_system.h"
#include "nvs_flash.h"
#include "esp_spi_flash.h"
#include "esp_log.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "freertos/timers.h"

/* Private define & constants ------------------------------------------------*/
#define BLINK_GPIO 18
#define BLINK_GPIO_SEL (1ULL << BLINK_GPIO)

#define BUTTON_GPIO 4
#define BUTTON_GPIO_SEL (1ULL << BUTTON_GPIO)

#define DEBOUNCE_DELAY_MS 100

const char *TAG = "ESP32_Demo";

/* FreeRTOS section - Handles and tasks prototypes ----------------------------*/

static void vBlinkTask(void *pvParameters);

static TimerHandle_t debounce_timer = NULL; /*!< Handle do timer de debounce */
xTaskHandle gpio_evt_led = NULL;            /*!< Handle da task BlinkLed */
xQueueHandle gpio_evt_queue = NULL;         /*!< Handle da fila de interrupção */

/* Private function prototypes -----------------------------------------------*/
static void esp32_init(void);
static void config_gpio(void);

/* Interrupt ISR */
static void IRAM_ATTR gpio_isr_handler(void *arg)
{
    /*!< Obtém GPIO responsável por ISR */
    uint32_t gpio_num = (uint32_t)arg;

    /*!< Reinicia o timer de debounce */
    xTimerResetFromISR(debounce_timer, NULL);

    /*!< Envia o número do GPIO para a fila */
    xQueueSendFromISR(gpio_evt_queue, &gpio_num, NULL);
}

/* Callback que trata interrupção btn */
static void debounce_timer_callback(TimerHandle_t xTimer)
{
    uint32_t io_num = (uint32_t)pvTimerGetTimerID(xTimer);

    // Exibe mensagem no console
    ESP_LOGI(TAG, "GPIO[%d] intr, val: %d\n", io_num, gpio_get_level(io_num));

    // Suspende ou retoma a Task BlinkLed
    if (io_num == BUTTON_GPIO)
    {
        if (gpio_evt_led != NULL)
        {
            if (eTaskGetState(gpio_evt_led) == eSuspended)
            {
                // Retoma a task
                ESP_LOGI(TAG, "Retoma a task BlinkLed\n");
                vTaskResume(gpio_evt_led);
            }
            else
            {
                // Suspende a task
                ESP_LOGI(TAG, "Suspende a task BlinkLed\n");
                vTaskSuspend(gpio_evt_led);

                // Garante led apagado
                gpio_set_level(BLINK_GPIO, 0);
            }
        }
    }
}

/* app_main function body ----------------------------------------------------*/
void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_init();

    /*!< Inicia Config GPIOs */
    config_gpio();

    /*!< Cria o timer de debounce */
    debounce_timer = xTimerCreate("DebounceTimer", pdMS_TO_TICKS(DEBOUNCE_DELAY_MS),
                                  pdFALSE, (void *)BUTTON_GPIO, debounce_timer_callback);
    if (debounce_timer == NULL)
    {
        ESP_LOGE("ERROR", "*** xTimerCreate error ***\n");
        return;
    }

    /*<! Cria a fila para receber GPIO*/
    gpio_evt_queue = xQueueCreate(10, sizeof(uint32_t));
    if (gpio_evt_queue == NULL)
    {
        ESP_LOGE("ERROR", "*** xQueueCreate error ***\n");
        return;
    }

    /*!< Cria a task Blink LED*/
    if (xTaskCreate(vBlinkTask, "vBlinkTask", 1024 + configMINIMAL_STACK_SIZE, NULL, 2, &gpio_evt_led) != pdTRUE)
    {
        ESP_LOGE("ERROR", "*** vBlinkTask error ***\n");
        return;
    }
}

/* Bodies of private tasks ---------------------------------------------------*/
static void vBlinkTask(void *pvParameters)
{
    uint8_t led_status = 0;

    /*!< Configura o estado inicial do LED */
    gpio_set_level(BLINK_GPIO, led_status);

    for (;;)
    {
        /*!< Aguarda 1s */
        vTaskDelay(pdMS_TO_TICKS(1000));

        /*!< Inverte o estado do LED */
        led_status ^= 1;
        gpio_set_level(BLINK_GPIO, led_status);

        /*!< Exibe mensagem no console */
        ESP_LOGI(TAG, "LED Status: %d", led_status);
    }
}

/* Bodies of private functions -----------------------------------------------*/
static void esp32_init(void)
{
    /* Initialize NVS */
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES)
    {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

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
}

static void config_gpio(void)
{
    /*!< Estrutura de configuração do GPIO */
    gpio_config_t io_conf;

    /*!< Configura GPIO2 como saída */
    io_conf.intr_type = GPIO_INTR_DISABLE; /*!< Desabilita interrupção */
    io_conf.mode = GPIO_MODE_OUTPUT;       /*!< Configura como saída */
    io_conf.pin_bit_mask = BLINK_GPIO_SEL; /*!< Seleciona GPIO2 */
    io_conf.pull_down_en = false;          /*!< Desabilita resistor de pull-down */
    io_conf.pull_up_en = false;            /*!< Desabilita resistor de pull-up */
    gpio_config(&io_conf);                 /*!< Configura GPIO */

    /*!< Configura GPIO18 como entrada */
    io_conf.mode = GPIO_MODE_INPUT;         /*!< Configura como entrada */
    io_conf.pin_bit_mask = BUTTON_GPIO_SEL; /*!< Seleciona GPIO18 */
    io_conf.pull_down_en = false;           /*!< Desabilita resistor de pull-down */
    io_conf.pull_up_en = true;              /*!< Habilita resistor de pull-up */
    io_conf.intr_type = GPIO_INTR_POSEDGE;  /*!< Configura interrupção para borda de subida */
    gpio_config(&io_conf);                  /*!< Configura GPIO */

    /*!< Instala o tratamento de interrupção para o botão */
    gpio_install_isr_service(ESP_INTR_FLAG_LEVEL1);
    gpio_isr_handler_add(BUTTON_GPIO, gpio_isr_handler, (void *)BUTTON_GPIO);
}