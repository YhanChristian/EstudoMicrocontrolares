/*Libs include */

#include "sensor.h"

/* Read sensor, return celsius degree */

float readSensor()
{
    float readSensor = analogRead(SENSOR_PIN);
    
    float celsius = ((readSensor / 4095.0) * 3300) / 10;

    /* Show temp on SerialMonitor */
    
    Serial.println("Temperatura Cº = " + String(celsius));
    
    return celsius;

}