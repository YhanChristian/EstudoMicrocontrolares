
/**
  ******************************************************************************
  * @Company: Yhan Christian Souza Silva MEI
  * @file    : yc_drv_gpio.h
  * @author : Yhan Christian Souza Silva
  * @version: V0.0
  * @date   : 22/05/2021
  * @brief  : Header of GPIO file
   *****************************************************************************

*/
#ifdef GPIO_ENABLED

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __YC_DRV_GPIO_H
#define __YC_DRV_GPIO_H

/* Includes ------------------------------------------------------------------*/  
// STMicroelectronics
#include "stm32f1xx_hal.h"
/* Define --------------------------------------------------------------------*/
#define NUM_OF_IOS  (uint8_t)2 

/* DEFINING PORT AND PINS FOR THE DIGITAL I/Os USED --------------------------*/

/* OUTPUTS -------------------------------------------------------------------*/
/* LED of Nucleo board ********************************************************/
#define LED_Pin             GPIO_PIN_5
#define LED_Port            GPIOA

/*----------------------------------------------------------------------------*/

/* INPUTS --------------------------------------------------------------------*/
/* User button of Nucleo board ************************************************/
#define BUTTON_Pin          GPIO_PIN_13
#define BUTTON_Port         GPIOC
#define BUTTON_EXTI_IRQn    EXTI15_10_IRQn

/*----------------------------------------------------------------------------*/

/* Typedef -------------------------------------------------------------------*/
// These values helps to understand the code
typedef enum
{                       
    /* Output *****************************************************************/
	eLed    ,
    /* Input ******************************************************************/
    eButton ,
      
}e_gpio_t;

// This struct combines port and pin in one location
typedef struct
{
    GPIO_TypeDef    *port;
    uint16_t         pin;        
    
}st_gpio_pin_t;

// Struct that retains all information about GPIOs of application
typedef struct
{
    /* Flags ******************************************************************/
    uint8_t FlagEnable;                 // State of peripheral
    
    /* Variables **************************************************************/
	GPIO_PinState State[NUM_OF_IOS];	// Vector of GPIOs values stored
    
    /* Function Pointers ******************************************************/
    int8_t  (*Open) (void);                        
    int8_t  (*Close)(void);                    
    int8_t  (*Write)(e_gpio_t, GPIO_PinState);              
    int8_t  (*Read) (e_gpio_t);               
    
}st_gpio_t;

/* Public objects ------------------------------------------------------------*/
extern st_gpio_t GPIO;

#endif /* __YC_DRV_GPIO_H */
#endif /* GPIO_ENABLED */
/*****************************END OF FILE**************************************/