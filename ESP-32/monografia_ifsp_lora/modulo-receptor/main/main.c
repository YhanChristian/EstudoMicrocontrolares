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

#include "nvs_flash.h"
#include "esp_spi_flash.h"

#include "esp_system.h"
#include "esp_event.h"
#include "esp_log.h"

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"

#include "mpu6050.h"


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



void app_main(void)
{

}