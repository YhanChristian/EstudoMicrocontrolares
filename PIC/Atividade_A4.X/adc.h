/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : adc.h
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo header com funções, defines para uso do ADC
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef ADC_H
#define	ADC_H

/* Includes ------------------------------------------------------------------*/
#include "config.h"

/* Define --------------------------------------------------------------------*/
#define NUM_CHANNELS 1
#define POT_CHANNEL 0

#define ADC_MAX 1023
#define ADC_MIN 0
#define ADC_VREF 5

/* Typedef -------------------------------------------------------------------*/
enum {
    ADC_OK = 0,
    ADC_ERROR = 2000,
    ADC_INV_PARAM,
    ADC_MAX_ERRORS
};

/* Public function prototypes ------------------------------------------------*/
int iConfigADC(int iNumChannels);
int iAnalogRead(int iChannel);

#endif	/* ADC_H */

/*****************************END OF FILE**************************************/