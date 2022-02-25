/*
 * File:   pwm.c
 * Author: User
 *
 * Created on 29 de Janeiro de 2021, 11:15
 */

#include <xc.h>
#include <stdint.h>        
#include <stdbool.h>  
#include "config.h"
#include "pwm.h"

void PWM_Initialize()
{
    PR2 = (_XTAL_FREQ / (PWM_FREQ * 4 * TMR2_PRESCALE)) -1; //Seta PR2, usa PWM com Freq 5kHz
    CCP1CON = 0x0C; //Configura CCP1CON como PWM 
    T2CON = 0x05; //TMR2ON, Pre-scaler 4
    TRISC2 = OUTPUT; //Configura Pino RC2 como saída, CCP1 
}


uint16_t PWM_Duty(uint16_t duty)
{
    if(duty <= 1023)
    {
        duty = ((float)duty / 1023) * (_XTAL_FREQ / (PWM_FREQ * TMR2_PRESCALE));
        CCP1X = duty & 1; 
        CCP1Y = duty & 2; 
        CCPR1L = duty >> 2;
    }
    return duty;
}
