/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : PWM.h
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo header com funções, defines para uso do PWM
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef PWM_H
#define	PWM_H

/* Includes ------------------------------------------------------------------*/
#include "config.h"
#include <stdint.h>

/* Define --------------------------------------------------------------------*/
#define PWM_PIN 1   /* RC1 PIN */
#define MOTOR_PIN 2 /*RC2 PIN */

#define PWM_FREQUENCY 8E3

#define TMR2_PRESCALER 16 /*Pré-Scaler Timer2 utilizado com PWM */

#define PWM_MAX 1023
#define PWM_MIN 0

#define PWM_PERCENT_MAX 100

/* Typedef -------------------------------------------------------------------*/
enum {
    PWM_OK = 0,
    PWM_ERROR = 3000,
    PWM_INV_PARAM,
    PWM_MAX_ERRORS
};

/* Public function prototypes ------------------------------------------------*/
int iConfigPWM(int iNumPin);
int iPWMSetDuty(int iNumPin, int iDuty);

#endif	/* PWM_H */

/*****************************END OF FILE**************************************/