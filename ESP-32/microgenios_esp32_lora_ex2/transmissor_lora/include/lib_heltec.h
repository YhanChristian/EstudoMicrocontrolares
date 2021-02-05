#ifndef _LIB_1306_FONTS_
#define _LIB_1306_FONTS_

#include "lib_ssd1306.h"

/**
 * Logs; 
 */

#include "esp_log.h"
#include "esp_system.h"

#define I2C_SDA_PIN CONFIG_I2C_SDA_PIN        //default 4
#define I2C_SCL_PIN CONFIG_I2C_SCL_PIN        //default 15
#define I2C_CHANNEL CONFIG_I2C_CHANNEL        //default 0 
#define OLED_PIN_RESET CONFIG_OLED_PIN_RESET  //default 16


void ssd1306_start( void )
{
	/**
	 * Apenas um template para facilitar a configuração do display oled;
	 */
	ssd1306_config( I2C_SDA_PIN, I2C_SCL_PIN , I2C_CHANNEL, OLED_PIN_RESET );
}
#endif