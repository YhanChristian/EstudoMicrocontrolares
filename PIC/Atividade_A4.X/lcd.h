/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : lcd.h
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo header com funções, defines para display LCD 16x2
 ******************************************************************************
 */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef LCD_H
#define	LCD_H

/* Includes ------------------------------------------------------------------*/
#include "config.h"
#include <string.h>
#include <stdbool.h>

/* Define --------------------------------------------------------------------*/

/* GPIO Display 16x2 */
#define LCD_D4 PORTDbits.RD4 /* PORTD RD4 */
#define LCD_D5 PORTDbits.RD5 /* PORTD RD5 */
#define LCD_D6 PORTDbits.RD6 /* PORTD RD6 */
#define LCD_D7 PORTDbits.RD7 /* PORTD RD7 */
#define LCD_RS PORTEbits.RE2 /* PORTE RE2 */
#define LCD_EN PORTEbits.RE1  /* PORTE RE1 */

/*Macro para Setar TRIS Dados e Comandos*/
#define LCD_DATA_PINS_TRIS_MASK 0xF0
#define SET_LCD_DATA_PINS_AS_OUTPUT() (TRISD &= ~LCD_DATA_PINS_TRIS_MASK)

#define LCD_CONTROL_PINS_TRIS_MASK 0x06
#define SET_LCD_CONTROL_PINS_AS_OUTPUT() (TRISE &= ~LCD_CONTROL_PINS_TRIS_MASK)

/* Typedef -------------------------------------------------------------------*/
enum {
    LCD_OK = 0,
    LCD_ERROR = 4000,
    LCD_INV_PARAM,
    LCD_MAX_ERRORS
};


/* Public objects ------------------------------------------------------------*/

/* Public function prototypes ------------------------------------------------*/
void LcdInit();
void LcdClear();
void LcdSetCursor(char x, char y);
void LcdPutChar(char c);
void LcdPutStr(char *str);

#endif	/* LCD_H */

/*****************************END OF FILE**************************************/