
/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva MEI
  * @file       : yc_api_battery.h
  * @author     : Yhan Christian Souza Silva 
  * @version	: V0.0 
  * @date       : 15/06/2021
  * @brief      : Header file of battery API
  ******************************************************************************
*/ 

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __YC_API_BATTERY_H
#define __YC_API_BATTERY_H

/* Includes ------------------------------------------------------------------*/  
/* Define --------------------------------------------------------------------*/
/* Typedef -------------------------------------------------------------------*/
/* Public objects ------------------------------------------------------------*/
int8_t   yc_api_battery_init     (void);// Initialize the battery API
int8_t   yc_api_battery_deinit   (void);// Deinitialize the battery API
int32_t  yc_api_battery_value    (void);// Read battery value

#endif /* __YC_API_BATTERY_H */
/*****************************END OF FILE**************************************/