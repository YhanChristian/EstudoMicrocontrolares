#ifndef _KEYBOARD_H_
#define _KEYBOARD_H_

/*Libs include */

#include <Arduino.h>

/* Defines */

#define BUTTON 12

#define PRESSED LOW
#define LOOSE HIGH

/* Functions Prototype */

void keyboardInit(int pin);
bool readKeyboard(unsigned char key);

#endif