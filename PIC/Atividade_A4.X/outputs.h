/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : outputs.h
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo header com funções, defines para saídas digitais
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef OUTPUTS_H
#define OUTPUTS_H

/* Includes ------------------------------------------------------------------*/
#include <stdbool.h>
#include <stdint.h>
#include "config.h"

/* Define --------------------------------------------------------------------*/
#define GPIO_BUZZER 1

#define CLEAR_ALL_BITS 0x00
#define SET_ALL_BITS 0xFF

/* Typedef -------------------------------------------------------------------*/
typedef enum {
    GPIO_LED_0 = 0,
    GPIO_LED_1,
    GPIO_LED_2,
    GPIO_LED_3,
    GPIO_LED_4,
    GPIO_LED_5,
    GPIO_LED_6,
    GPIO_LED_7,
    MAX_LEDS
} e_gpio_led_t;

enum {
    GPIO_OK = 0,
    GPIO_ERROR = 1000,
    GPIO_INV_PARAM,
    MAX_GPIO_ERRORS
};

/* Public objects -----------------------------------------------------------*/

/* Public function prototypes -----------------------------------------------*/
void configOutputs();
int setLedsOn(uint8_t uiNumLeds);
void changeBuzzerState(bool fState);
bool readBuzzerState();


#endif /* OUTPUTS_H */

/*****************************END OF FILE**************************************/