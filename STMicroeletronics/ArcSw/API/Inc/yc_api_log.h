
/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva MEI
  * @file       : yc_api_log.h
  * @author     : Yhan Christian Souza Silva 
  * @version	: V0.0 
  * @date       : 15/06/2021
  * @brief      : Header file of log API
  ******************************************************************************
*/ 

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __YC_API_LOG_H
#define __YC_API_LOG_H

/* Includes ------------------------------------------------------------------*/  
/* Define --------------------------------------------------------------------*/
/* Typedef -------------------------------------------------------------------*/
/* Public objects ------------------------------------------------------------*/
int8_t  yc_api_log_init     (void);// Initialize log API
int8_t  yc_api_log_deinit   (void);// Deinitialize log API
int8_t  yc_api_log_print    (void);// Print the log about battery

#endif /* __YC_API_LOG_H */
/*****************************END OF FILE**************************************/