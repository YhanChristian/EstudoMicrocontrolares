#ifndef _MQTT_H_
#define _MQTT_H_

/* Functions Prototype */

void connectToWiFi();
void verifyWifiConnect();
void connectToMQTT();
void verifyMQTTConnect();
void publishDataToMQTT(float value);

#endif