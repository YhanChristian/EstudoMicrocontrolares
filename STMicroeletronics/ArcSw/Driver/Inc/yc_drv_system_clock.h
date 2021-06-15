
/**
  ******************************************************************************
  * @Company: Yhan Christian Souza Silva MEI
  * @file    : yc_drv_system_clock.h
  * @author : Yhan Christian Souza Silva 
  * @version: V0.0
  * @date   : 15/06/2021
  * @brief  : Header of system clock driver
   *****************************************************************************
*/
#ifdef SYSTEM_CLOCK_ENABLED

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __EA_DRV_SYSTEM_CLOCK_H
#define __EA_DRV_SYSTEM_CLOCK_H

/* Includes ------------------------------------------------------------------*/ 
// STMicroelctronics
#include "stm32f1xx_hal.h"
/* Define --------------------------------------------------------------------*/
/* Typedef -------------------------------------------------------------------*/
// Struct that retains all information about SYSCLK driver
typedef struct
{
    /* Flags ******************************************************************/
    FlagStatus FlagEnable;  // State of peripheral
    
    /* Function Pointers ******************************************************/
    int8_t  (*Open)(void);      
    void    (*Delay)(uint32_t);
    
}sysclk_gpio_t;

/* Public objects ------------------------------------------------------------*/
extern sysclk_gpio_t SYS;

#endif /* __YC_DRV_SYSTEM_CLOCK_H */
#endif /* SYSTEM_CLOCK_ENABLED */

/*****************************END OF FILE**************************************/