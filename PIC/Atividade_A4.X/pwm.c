/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : adc.c
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo source com funções, defines para uso do PWM
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "pwm.h"

/* Public objects ------------------------------------------------------------*/

/* Bodies of private functions -----------------------------------------------*/

/* Bodies of public functions ------------------------------------------------*/
int iConfigPWM(int iNumPin) {
    /*Limita a quantidade canais em 2 
     o PIC18F4520 possui dois pinos PWM
     */
    switch (iNumPin) {
        case PWM_PIN:
            CCP2CON = 0x0F;
            break;
        case MOTOR_PIN:
            CCP1CON = 0x0F;
            break;
        default:
            return PWM_INV_PARAM;
    }


    /*Calcula PR2 de acordo com formula datasheet*/
    PR2 = ("%#x", (_XTAL_FREQ / (PWM_FREQUENCY * 4 * TMR2_PRESCALER)) - 1);

    /*Verifica o pino e configura como saída*/
    TRISC &= ~(1 << iNumPin);

    /*Configura Registradores referentes ao timer 2*/
    T2CON = 0x03;
    TMR2 = 0;
    T2CONbits.TMR2ON = TRUE;

    return PWM_OK;
}

int iPWMSetDuty(int iNumPin, int iDuty) {
    /*Limita a quantidade canais em 2 
    o PIC18F4520 possui dois pinos PWM
     */
    if (iDuty <= PWM_MAX) {

        iDuty = ((float) iDuty / PWM_MAX) * (_XTAL_FREQ / (PWM_FREQUENCY * TMR2_PRESCALER));

        switch (iNumPin) {
            case PWM_PIN:
                CCPR2L = (unsigned char) iDuty >> 2;
                break;
            case MOTOR_PIN:
                CCPR1L = (unsigned char) iDuty >> 2;
                break;
            default:
                return PWM_INV_PARAM;
        }
    } else {
        return PWM_ERROR;
    }
    return PWM_OK;
}

/*****************************EN1D OF FILE**************************************/