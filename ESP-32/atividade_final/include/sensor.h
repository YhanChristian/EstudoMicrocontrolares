#ifndef _SENSOR_H_
#define _SENSOR_H_

/*Libs include */

#include <Arduino.h>

/* Defines */

#define SENSOR_PIN 32 /* ADC1_4 (Heltec LoRa v2 board)*/

/* Functions Prototype */

float readSensor();

#endif