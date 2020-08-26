#ifndef _DISPLAY_H
#define _DISPLAY_H

/*Libs include */

#include <Arduino.h>
#include <Wire.h>
#include "Adafruit_GFX.h"
#include "Adafruit_SSD1306.h"

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

/* Functions Prototype */

void initDisplay();
void showDisplay(float value);

#endif