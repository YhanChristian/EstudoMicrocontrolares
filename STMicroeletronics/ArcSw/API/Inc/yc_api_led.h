/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva MEI
  * @file       : yc_api_led.h
  * @author     : Yhan Christian Souza Silva 
  * @version	: V0.0 
  * @date       : 15/06/2021
  * @brief      : Header file of LED API
  ******************************************************************************
*/ 


/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __YC_API_LED_H
#define __YC_API_LED_H

/* Includes ------------------------------------------------------------------*/  
/* Define --------------------------------------------------------------------*/
/* Typedef -------------------------------------------------------------------*/
/* Public objects ------------------------------------------------------------*/
int8_t   yc_api_led_init    (void);// Initialize LED API
int8_t   yc_api_led_deinit  (void);// Deinitialize LED API
void     yc_api_led_set     (void);// Set LED
void     yc_api_led_reset   (void);// Reset LED

#endif /* __YC_API_LED_H */
/*****************************END OF FILE**************************************/