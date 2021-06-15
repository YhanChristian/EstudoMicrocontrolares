
/**
  ******************************************************************************
  * @Company: Yhan Christian Souza Silva MEI
  * @file   : yc_drv_adc.h
  * @author :  Yhan Christian Souza Silva
  * @version: V0.0
  * @date   : 15/06/2021
  * @brief  : Header file of UART driver
   *****************************************************************************
*/
#ifdef UART_ENABLED

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __YC_DRV_UART_H
#define __YC_DRV_UART_H

/* Includes ------------------------------------------------------------------*/ 
// STMicroelctronics
#include "stm32f1xx_hal.h"
/* Define --------------------------------------------------------------------*/
#define LENGHT_TX_BUFFER	(uint8_t)64

/* Typedef -------------------------------------------------------------------*/
typedef struct
{
    /* Flags ******************************************************************/
    uint8_t FlagEnable;				    // State of peripheral
	uint8_t FlagIsTxDone;			    // This flag indicates if TX process is done
    
    /* Variables **************************************************************/
	int8_t 	cTxBuffer[LENGHT_TX_BUFFER];// Buffer of transmition
    
    /* Function Pointers ******************************************************/
    int8_t  (*Open) (void);                        
    int8_t  (*Close)(void); 
    int8_t  (*Write)(char*, uint16_t);                
    
}st_uart_t;

/* Public objects ------------------------------------------------------------*/    
extern st_uart_t UART;

#endif /* __YC_DRV_UART_H */
#endif /* UART_ENABLED */
/*****************************END OF FILE**************************************/