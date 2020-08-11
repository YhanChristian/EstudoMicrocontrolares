#ifndef _RTOS_H_
#define _RTOS_H_

/*Libs include */

#include "display.h"
#include "mqtt.h"
#include "keyboard.h"
#include "output.h"
#include "sensor.h"

#include <Arduino.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

/* Functions Prototype */

void initRTOS();

#endif