#ifndef _KEYBOARD_H_
#define _KEYBOARD_H_

/*Libs include */

#include <Arduino.h>

/* Defines */

#define BUTTON 12

#define BTN_PRESSED LOW
#define BTN_LOOSE HIGH

/* Functions Prototype */

void keyboardInit(uint8_t pin);
bool readKeyboard(unsigned char key);

#endif