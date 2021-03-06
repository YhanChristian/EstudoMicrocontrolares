
/*Libs include */

#include "keyboard.h"

/* Config pin INPUT_PULLUP, parameter pin */ 

void initKeyboard(int pin)
{
    pinMode(pin, INPUT_PULLUP);
}

/*Read Keyboard, parameter key (pin), return key state*/

bool readKeyboard(unsigned char key)
{
    return digitalRead(key);
}