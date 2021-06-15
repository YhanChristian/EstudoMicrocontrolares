
/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva MEI
  * @file       : yc_api_sys.h
  * @author     : Yhan Christian Souza Silva 
  * @version	: V0.0 
  * @date       : 15/06/2021
  * @brief      : Header file of SYS API
  ******************************************************************************
*/ 

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __YC_API_SYS_H
#define __YC_API_SYS_H

/* Includes ------------------------------------------------------------------*/  
/* Define --------------------------------------------------------------------*/
/* Typedef -------------------------------------------------------------------*/
/* Public objects ------------------------------------------------------------*/
int8_t  yc_api_sys_init  (void);     // Initialize HW API
void    yc_api_sys_delay (uint32_t); // Delay

#endif /* __EA_API_SYS_H */
/*****************************END OF FILE**************************************/