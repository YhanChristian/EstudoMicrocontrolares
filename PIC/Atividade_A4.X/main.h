/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : MAIN.h
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo header com funções, defines aplicação principal
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef MAIN_H
#define	MAIN_H

/* Includes ------------------------------------------------------------------*/  
#include "config.h"
#include "adc.h"
#include "lcd.h"
#include "outputs.h"
#include "pwm.h"
#include "interrupts.h"
#include <stdio.h>
#include <string.h>

/* Define --------------------------------------------------------------------*/
#define VALOR_INC_LEDS 128
#define ONE_SECOND 4 /* 4 Ciclos de 250ms */

#define AGUARDA_MSG_LCD 2000 

/* Typedef -------------------------------------------------------------------*/
typedef struct {
    int iContador;
    bool fTimerOverflow;
} st_timers_t;

/* Private function prototypes -----------------------------------------------*/

#endif	/* MAIN_H */

/*****************************END OF FILE**************************************/