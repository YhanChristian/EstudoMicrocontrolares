/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : main.c
 * @author     : Yhan Christian Souza Silva
 * @date       :03/08/2022
 * @brief      : Projeto Voltz Scooter
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
#include "esp_timer.h"
#include "esp_task_wdt.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "screen_driver.h"
#include "lcd_config.h"
#include "img_array.h"

/* Private define & constants ------------------------------------------------*/

static const char *TAG = "VoltzScooter Project";

/** If you use a spi interface screen, set the USE_SPI_SCREEN to 1,
 *  otherwise use 8080 interface. */

// #define USE_SPI_SCREEN 1

/* Private variables ---------------------------------------------------------*/

static uint16_t g_color_table[ITERATION];
static scr_driver_t g_lcd;
static scr_info_t g_lcd_info;

/* Private function prototypes -----------------------------------------------*/

static void esp32_start(void);
static void lcd_init(void);
static void lcd_test(void);
static void generate_mandelbrot(scr_driver_t *lcd, uint16_t size_x,
                                uint16_t size_y, int32_t offset_x, int32_t offset_y,
                                uint16_t zoom, uint16_t *line_buffer);
static uint16_t rgb888_to_rgb565(uint8_t r, uint8_t g, uint8_t b);
static void init_CLUT(uint16_t *clut);
static void screen_clear(scr_driver_t *lcd, int color);
static void lcd_bitmap_test(scr_driver_t *lcd);
static void lcd_speed_test(scr_driver_t *lcd);

/* app_main function body ----------------------------------------------------*/

void app_main(void)
{
    /*!< Inicia ESP32 e exibe algumas informações */
    esp32_start();

    /*!< Inicia TFT Disp SKU: NT35510 e exibe informações */
    lcd_init();

    /*!< Realiza testes com o display / verificando funcionamento */
    lcd_test();
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

static void lcd_init(void)
{
    /** Initialize 16bit 8080 interface */
    esp_err_t ret = ESP_OK;

    /** Initialize 16bit 8080 interface */
    i2s_lcd_config_t i2s_lcd_cfg = {
        .data_width = DATA_WIDTH,
        .pin_data_num = {
            DB0_BIT,
            DB1_BIT,
            DB2_BIT,
            DB3_BIT,
            DB4_BIT,
            DB5_BIT,
            DB6_BIT,
            DB7_BIT,
            DB8_BIT,
            DB9_BIT,
            DB10_BIT,
            DB11_BIT,
            DB12_BIT,
            DB13_BIT,
            DB14_BIT,
            DB15_BIT},
        .pin_num_cs = CS_PIN,
        .pin_num_wr = WR_PIN,
        .pin_num_rs = RS_PIN,
        .clk_freq = CLK_FREQ,
        .i2s_port = I2S_NUM_0,
        .buffer_size = BUFFER_SIZE,
        .swap_data = false,
    };
    scr_interface_driver_t *iface_drv;
    scr_interface_create(SCREEN_IFACE_8080, &i2s_lcd_cfg, &iface_drv);

    /** Find screen driver for NT35510 */
    ret = scr_find_driver(SCREEN_CONTROLLER_NT35510, &g_lcd);
    if (ESP_OK != ret)
    {
        ESP_LOGE(TAG, "Screen NT35510 driver failed!");
        return;
    }
    /** Configure screen controller */
    scr_controller_config_t lcd_cfg = {
        .interface_drv = iface_drv,
        .pin_num_rst = -1,  // The reset pin is not connected
        .pin_num_bckl = -1, // The backlight pin is not connected
        .rst_active_level = 0,
        .bckl_active_level = 1,
        .offset_hor = 0,
        .offset_ver = 0,
        .width = DISP_WIDTH,
        .height = DISP_HEIGHT,
        .rotate = SCR_SWAP_XY | SCR_MIRROR_Y, /** equal to SCR_DIR_BTLR */
    };

    ret = g_lcd.init(&lcd_cfg);
    if (ESP_OK != ret)
    {
        ESP_LOGE(TAG, "Screen initizalize failed!");
        return;
    }

    g_lcd.get_info(&g_lcd_info);
    ESP_LOGI(TAG, "Screen name:%s | width:%d | height:%d", g_lcd_info.name, g_lcd_info.width, g_lcd_info.height);

    screen_clear(&g_lcd, COLOR_ESP_BKGD);
    vTaskDelay(pdMS_TO_TICKS(500));

    /** Draw a red point at position (10, 20) */
    g_lcd.draw_pixel(10, 20, COLOR_RED);

    vTaskDelay(pdMS_TO_TICKS(3000));
}

static void lcd_test(void)
{
    /**  Run test */
    lcd_bitmap_test(&g_lcd);
    vTaskDelay(pdMS_TO_TICKS(2000));
    lcd_speed_test(&g_lcd);
    vTaskDelay(pdMS_TO_TICKS(2000));
    init_CLUT(g_color_table); /** Initialize color look up table */

    /** Define an interesting point on the complex plane */
    float real = -0.68481 + (g_lcd_info.width / 2 / (float)MAX_ZOOM);
    float img = 0.380584 + (g_lcd_info.height / 2 / (float)MAX_ZOOM);

    uint16_t *pixels = heap_caps_malloc(g_lcd_info.width * sizeof(uint16_t), MALLOC_CAP_8BIT | MALLOC_CAP_INTERNAL);
    if (NULL == pixels)
    {
        ESP_LOGE(TAG, "Memory for bitmap is not enough");
        return;
    }

    float zoom;

    while (1)
    {
        for (zoom = 50; zoom <= MAX_ZOOM; zoom *= 1.1f)
        {
            int32_t off_x = (real)*zoom;
            int32_t off_y = (img)*zoom;
            generate_mandelbrot(&g_lcd, g_lcd_info.width, g_lcd_info.height, g_lcd_info.width / 2 - off_x, g_lcd_info.height / 2 - off_y, zoom, pixels);
            vTaskDelay(1); /** Delay one tick for feed task watchdog */
        }
        for (; zoom > 50; zoom /= 1.1f)
        {
            int32_t off_x = (real)*zoom;
            int32_t off_y = (img)*zoom;
            generate_mandelbrot(&g_lcd, g_lcd_info.width, g_lcd_info.height, g_lcd_info.width / 2 - off_x, g_lcd_info.height / 2 - off_y, zoom, pixels);
            vTaskDelay(1);
        }
    }
}

static void generate_mandelbrot(scr_driver_t *lcd, uint16_t size_x, uint16_t size_y, int32_t offset_x, int32_t offset_y, uint16_t zoom, uint16_t *line_buffer)
{
    uint8_t i;
    uint16_t x, y;
    float tmp1, tmp2;
    float p_r, p_i;
    float num_real, num_img;
    float radius;
    ESP_LOGI(TAG, "zoom = %d", zoom);

    for (y = 0; y < size_y; y++)
    {
        for (x = 0; x < size_x; x++)
        {
            num_real = x - offset_x;
            p_r = num_real = num_real / zoom;
            num_img = y - offset_y;
            p_i = num_img = num_img / zoom;
            i = 0;
            radius = 0;
            if (0 == x && 0 == y)
            {
                ESP_LOGI(TAG, "start(%f, %f)", num_real, num_img);
            }
            if (size_x - 1 == x && size_y - 1 == y)
            {
                ESP_LOGI(TAG, "end  (%f, %f)", num_real, num_img);
            }

            while ((i < ITERATION - 1) && (radius < 16))
            {
                // z = z^2 + c
                tmp1 = num_real * num_real;
                tmp2 = num_img * num_img;
                num_img = 2 * num_real * num_img + p_i;
                num_real = tmp1 - tmp2 + p_r;
                radius = tmp1 + tmp2; // Modulus^2
                i++;
            }
            if (NULL != line_buffer)
            {
                line_buffer[x] = g_color_table[i];
            }
            else
            {
                lcd->draw_pixel(x, y, g_color_table[i]);
            }
        }
        if (NULL != line_buffer)
        {
            lcd->draw_bitmap(0, y, g_lcd_info.width, 1, line_buffer);
        }
    }
}

static uint16_t rgb888_to_rgb565(uint8_t r, uint8_t g, uint8_t b)
{
    return ((r & 0xF8) << 8) | ((g & 0xFC) << 3) | (b >> 3);
}

static void init_CLUT(uint16_t *clut)
{
    uint32_t i = 0x00;
    uint16_t red = 0, green = 0, blue = 0;

    for (i = 0; i < ITERATION; i++)
    {
        red = (i * 6 * 256 / ITERATION) % 256;
        green = (i * 4 * 256 / ITERATION) % 256;
        blue = (i * 8 * 256 / ITERATION) % 256;
        clut[i] = rgb888_to_rgb565(red, green, blue);
    }
}

static void screen_clear(scr_driver_t *lcd, int color)
{
    scr_info_t lcd_info;
    lcd->get_info(&lcd_info);
    uint16_t *buffer = malloc(lcd_info.width * sizeof(uint16_t));
    if (NULL == buffer)
    {
        for (size_t y = 0; y < lcd_info.height; y++)
        {
            for (size_t x = 0; x < lcd_info.width; x++)
            {
                lcd->draw_pixel(x, y, color);
            }
        }
    }
    else
    {
        for (size_t i = 0; i < lcd_info.width; i++)
        {
            buffer[i] = color;
        }

        for (int y = 0; y < lcd_info.height; y++)
        {
            lcd->draw_bitmap(0, y, lcd_info.width, 1, buffer);
        }

        free(buffer);
    }
}

static void lcd_bitmap_test(scr_driver_t *lcd)
{
    scr_info_t lcd_info;
    lcd->get_info(&lcd_info);

    uint16_t *pixels = heap_caps_malloc((img_width * img_height) * sizeof(uint16_t), MALLOC_CAP_8BIT | MALLOC_CAP_INTERNAL);
    if (NULL == pixels)
    {
        ESP_LOGE(TAG, "Memory for bitmap is not enough");
        return;
    }
    memcpy(pixels, img_array, (img_width * img_height) * sizeof(uint16_t));
    lcd->draw_bitmap(0, 0, img_width, img_height, (uint16_t *)pixels);
    heap_caps_free(pixels);
}

static void lcd_speed_test(scr_driver_t *lcd)
{
    scr_info_t lcd_info;
    lcd->get_info(&lcd_info);

#if defined(CONFIG_BOARD_ESP32_M5STACK)
    uint32_t w = 320, h = 240;
#else
    uint32_t w = 240, h = 240;
#endif

    w = lcd_info.width < w ? lcd_info.width : w;
    h = lcd_info.height < h ? lcd_info.height : h;

    const uint32_t buffer_size = w * h;
    uint16_t *pixels = heap_caps_malloc(buffer_size * sizeof(uint16_t), MALLOC_CAP_8BIT | MALLOC_CAP_INTERNAL);
    if (NULL == pixels)
    {
        ESP_LOGE(TAG, "Memory for bitmap is not enough");
        return;
    }

    esp_task_wdt_delete(xTaskGetIdleTaskHandleForCPU(xPortGetCoreID()));
    const uint16_t color_table[] = {COLOR_RED, COLOR_GREEN, COLOR_BLUE, COLOR_YELLOW};
    uint32_t times = 256;
    uint64_t s;
    uint64_t t1 = 0;
    for (int i = 0; i < times; i++)
    {
        for (int j = 0; j < buffer_size; j++)
        {
            pixels[j] = color_table[i % 4];
        }
        s = esp_timer_get_time();
        lcd->draw_bitmap(0, 0, w, h, pixels);
        t1 += (esp_timer_get_time() - s);
    }
    t1 = t1 / 1000;
    float time_per_frame = (float)t1 / (float)times;
    float fps = (float)times * 1000.f / (float)t1;
    float write_speed = sizeof(uint16_t) * buffer_size * times / 1024.0f / 1.0240f / (float)t1;
    float factor = ((float)w * (float)h) / ((float)lcd_info.width * (float)lcd_info.height);
    ESP_LOGI(TAG, "-------%s Test Result------", lcd_info.name);
    if (w != lcd_info.width || h != lcd_info.height)
    {
        ESP_LOGI(TAG, "@resolution 240x240          [time per frame=%.2fMS, fps=%.2f, speed=%.2fMB/s]", time_per_frame, fps, write_speed);
        ESP_LOGI(TAG, "@resolution %ux%u infer to [time per frame=%.2fMS, fps=%.2f]",
                 lcd_info.width, lcd_info.height,
                 time_per_frame / factor, factor * fps);
    }
    else
    {
        ESP_LOGI(TAG, "@resolution %ux%u          [time per frame=%.2fMS, fps=%.2f, speed=%.2fMB/s]", lcd_info.width, lcd_info.height, time_per_frame, fps, write_speed);
    }
    ESP_LOGI(TAG, "-------------------------------------");

    esp_task_wdt_add(xTaskGetIdleTaskHandleForCPU(xPortGetCoreID()));
    heap_caps_free(pixels);
}