#ifndef _LCD_CONFIG_H
#define _LCD_CONFIG_H

#include "driver/gpio.h"

#define MAX_ZOOM 2500
#define ITERATION 128

#define DATA_WIDTH 16

#define CLK_FREQ 20000000

#define BUFFER_SIZE 32000   

#define DISP_WIDTH 480
#define DISP_HEIGHT 800

/*
#define DB0_BIT GPIO_NUM_3
#define DB1_BIT GPIO_NUM_46
#define DB2_BIT GPIO_NUM_9
#define DB3_BIT GPIO_NUM_10
#define DB4_BIT GPIO_NUM_11
#define DB5_BIT GPIO_NUM_12
#define DB6_BIT GPIO_NUM_13
#define DB7_BIT GPIO_NUM_14

#define DB8_BIT GPIO_NUM_19
#define DB9_BIT GPIO_NUM_20
#define DB10_BIT GPIO_NUM_21
#define DB11_BIT GPIO_NUM_47
#define DB12_BIT GPIO_NUM_48
#define DB13_BIT GPIO_NUM_39
#define DB14_BIT GPIO_NUM_40
#define DB15_BIT GPIO_NUM_41
*/

#define DB0_BIT 0
#define DB1_BIT 1
#define DB2_BIT 2
#define DB3_BIT 3
#define DB4_BIT 4
#define DB5_BIT 5
#define DB6_BIT 6
#define DB7_BIT 7

#define DB8_BIT 8
#define DB9_BIT 9
#define DB10_BIT 10
#define DB11_BIT 11
#define DB12_BIT 12
#define DB13_BIT 13
#define DB14_BIT 14
#define DB15_BIT 15

#define CS_PIN 35
#define RD_PIN 37
#define RST_PIN 40
#define RS_PIN 41
#define WR_PIN 37

#endif