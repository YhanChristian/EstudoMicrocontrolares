/*Libs include */

#include "output.h"

/*Config outputs, parameters: none  */

void initOutput()
{
    Serial.begin(BAUD_RATE);
    pinMode(LED_HEART_BEAT, OUTPUT);
    pinMode(OUT_01, OUTPUT);

}