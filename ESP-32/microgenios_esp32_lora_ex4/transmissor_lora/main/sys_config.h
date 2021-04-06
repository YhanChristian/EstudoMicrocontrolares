#ifndef _SYSCONFIG__H
#define _SYSCONFIG__H

/**
 * Definições das GPIOs
 */

#define LED_BUILDING         ( 25 ) 
#define GPIO_OUTPUT_PIN_SEL  ( 1ULL<<LED_BUILDING )

#define BUTTON               ( 0 )
#define GPIO_INPUT_PIN_SEL   ( 1ULL<<BUTTON )

/**
 * Configurãção da rede WiFi do USUÁRIO;
 */
#define WIFI_SSID       "Seu SSID"
#define WIFI_PASSWORD   "Sua senha WiFi"

/**
 * Configuração do MQTT;
 */
#define MQTT_SERVER 	"Servidor MQTT"
#define MQTT_PORTA 		"Porta"
#define MQTT_USERNAME 	"username"
#define MQTT_PASSWORD 	"password"

#define TOPIC_SUBSCRIBE "sub_topico"
#define TOPIC_PUBLISH 	"pub_topico"

/**
 * Configuração de Rede ao habilitar IP fixo atribui IPs abaixo;
 */
#define IP_FIXO 0
#define IP_ADDRESS 		"192.168.0.80"
#define GATEWAY_ADDRESS "192.168.0.1"
#define NETMASK_ADDRESS "255.255.255.0"

/**
 * Definições Gerais;
 */
#define TRUE  1
#define FALSE 0
#define DR_REG_RNG_BASE   0x3ff75144
 

/**
 * Debug?
 */
#define DEBUG 0
 

#endif 