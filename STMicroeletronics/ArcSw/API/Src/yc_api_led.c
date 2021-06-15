/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva MEI
  * @file       : yc_api_led.c
  * @author     : Yhan Christian Souza Silva 
  * @version	: V0.0 
  * @date       : 15/06/2021
  * @brief      : Source file of LED API
  ******************************************************************************
*/ 

/* Includes ------------------------------------------------------------------*/ 
// C language standard library
#include "stdint.h"
// Yhan Christian driver library
#include "yc_drv_gpio.h"
// API library
#include "yc_api_led.h"

/*******************************************************************************
                          HOW TO USE THIS API
********************************************************************************

1. 	First, you should include in your .c file the "ea_api_led.h" file.

2.  Call yc_api_led_init() to initialize the driver;

3.  Call yc_api_led_set() to set or ea_api_led_reset() to reset the LED.

*******************************************************************************/

/* Private define ------------------------------------------------------------*/
#define LED_API_OK          (int8_t) 0
#define LED_API_ERROR       (int8_t)-1

/* Private macros ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/    
int8_t  yc_api_led_init    (void);// Initialize LED API
int8_t  yc_api_led_deinit  (void);// Deinitialize LED API
void    yc_api_led_set     (void);// Set LED
void    yc_api_led_reset   (void);// Reset LED

/* Public objects ------------------------------------------------------------*/
/* Body of private functions -------------------------------------------------*/
/**
  * @Func       : yc_api_led_init    
  * @brief      : Init. LED driver
  * @pre-cond.  : SysClk function
  * @post-cond. : LED driver init. and ready to be used
  * @parameters : void
  * @retval     : int8_t -> (value == 0) = OK; (value < 0) = ERROR
  */
int8_t yc_api_led_init(void)
{
    // Init. LED driver
    if(GPIO.Open() != 0)
    {
        return LED_API_ERROR;
    }    
	// OK
	return LED_API_OK;	
}

/**
  * @Func       : yc_api_led_deinit    
  * @brief      : Deinitializes LED driver
  * @pre-cond.  : yc_api_led_init
  * @post-cond. : LED API deinit.
  * @parameters : void
  * @retval     : int8_t -> (value == 0) = OK; (value < 0) = ERROR
  */
int8_t yc_api_led_deinit(void)
{
    // Deinit. battery driver
    if(GPIO.Close() != 0)
    {
        return LED_API_ERROR;
    }    
	// OK
	return LED_API_OK;	
}

/**
  * @Func       : yc_api_led_set    
  * @brief      : Turn on the LED
  * @pre-cond.  : yc_api_led_init
  * @post-cond. : LED ON
  * @parameters : void
  * @retval     : void
  */
void yc_api_led_set(void)
{    	
    GPIO.Write(eLed, GPIO_PIN_SET);
}

/**
  * @Func       : yc_api_led_reset    
  * @brief      : Turn off the LED
  * @pre-cond.  : yc_api_led_init 
  * @post-cond. : LED OFF
  * @parameters : void
  * @retval     : void
  */
void yc_api_led_reset(void)
{
    GPIO.Write(eLed, GPIO_PIN_RESET);
}

/*****************************END OF FILE**************************************/