/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : interrupts.h
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo header com funções, defines para uso de interrupções
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef INTERRUPTS_H
#define	INTERRUPTS_H

/* Includes ------------------------------------------------------------------*/
#include "config.h"

/* Define --------------------------------------------------------------------*/
#define CICLO_MAQUINA (4 / _XTAL_FREQ)

/* Typedef -------------------------------------------------------------------*/


/* Public function prototypes ------------------------------------------------*/
void ConfigTimerZeroISR();

#endif	/* INTERRUPTS_H */

/*****************************END OF FILE**************************************/