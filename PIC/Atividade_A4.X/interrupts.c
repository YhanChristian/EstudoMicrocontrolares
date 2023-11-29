/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : interrupts.c
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo source com fun��es, defines para uso de interrup��es
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "interrupts.h"

/* Public objects ------------------------------------------------------------*/

/* Bodies of private functions -----------------------------------------------*/

/* Bodies of public functions ------------------------------------------------*/
void ConfigTimerZeroISR() {
    /* Tempo de Estouro Timer 16bits
     * (65536 - TMR0) x Prescaler x ciclo de m�quina
     * Tempo de estouro Timer 250ms
     * Ciclo de M�quina	0,0000002
     * PreScaler	32
     * Modo 16bits	65535
     * Tempo Desejado	0,25
     * Valor Registrador	26473
     */
    T0CON = 0x84; /*Modo de 16bits, Pr�-Scaler 1:32 clock interno*/
    
    /*Valor inicial registradores para estouro em 250ms*/
    TMR0H = 0x66;
    TMR0L = 0x5A;
    
    /*Habilita interrup��o no Timer 0*/
    INTCONbits.TMR0IE = TRUE;
    
    /*Habilita interrup��es globais*/
    INTCONbits.GIE = TRUE;
    
    /*Limpa Flag de Interrup��o Timer 0*/
    INTCONbits.TMR0IF = 0;
}

/*****************************EN1D OF FILE**************************************/