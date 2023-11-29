/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : lcd.h
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo source com funções, defines para display LCD 16x2
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include <xc.h>
#include "lcd.h"

/* Private objects ------------------------------------------------------------*/

/* Bodies of private functions -----------------------------------------------*/
void LcdOut(char c) {
    if (c & 1) {
        LCD_D4 = 1;
    } else {
        LCD_D4 = 0;
    }
    if (c & 2) {
        LCD_D5 = 1;
    } else {
        LCD_D5 = 0;
    }
    if (c & 4) {
        LCD_D6 = 1;
    } else {
        LCD_D6 = 0;
    }
    if (c & 8) {
        LCD_D7 = 1;
    } else {
        LCD_D7 = 0;
    }
}

void LcdCmd(char c) {
    LCD_RS = 0;
    LcdOut(c);
    LCD_EN = 1;
    __delay_ms(4);
    LCD_EN = 0;
}

/* Bodies of public functions ------------------------------------------------*/
void LcdInit() {
    /*Configura pinos PORTD (RD4 à RD7)*/
    SET_LCD_DATA_PINS_AS_OUTPUT();

    /*Configura os pinos PORTE (RE1 E RE2)*/
    SET_LCD_CONTROL_PINS_AS_OUTPUT();

    /*Inicia Display*/
    LcdCmd(0x00);

    /*Aguarda LCD*/
    __delay_ms(20);

    LcdCmd(0x03);
    __delay_ms(5);
    LcdCmd(0x03);
    __delay_ms(11);
    LcdCmd(0x03);

    /*Realiza ocnfiguração Display LCD 16 x 2*/
    LcdCmd(0x02);
    LcdCmd(0x02);
    LcdCmd(0x08);
    LcdCmd(0x00);
    LcdCmd(0x0C);
    LcdCmd(0x00);
    LcdCmd(0x06);
}

void LcdClear() {
    LcdCmd(0x00);
    LcdCmd(0x01);
}

void LcdSetCursor(char x, char y) {
    char temp, k, j;
    if (x == 1) {
        temp = 0x80 + y - 1;
        k = temp >> 4;
        j = temp & 0x0F;
        LcdCmd(k);
        LcdCmd(j);
    } else if (x == 2) {
        temp = 0xC0 + y - 1;
        k = temp >> 4;
        j = temp & 0x0F;
        LcdCmd(k);
        LcdCmd(j);
    }
}

void LcdPutChar(char c) {
    char temp, y;
    temp = c & 0x0F;
    y = c & 0xF0;
    LCD_RS = 1;
    LcdOut(y >> 4); //Data transfer
    LCD_EN = 1;
    __delay_us(40);
    LCD_EN = 0;
    LcdOut(temp);
    LCD_EN = 1;
    __delay_us(40);
    LCD_EN = 0;
}

void LcdPutStr(char *str) {
    int i = 0;
    for (i = 0; str[i] != '\0'; i++) {
        LcdPutChar(str[i]);
    }
}

/*****************************EN1D OF FILE**************************************/