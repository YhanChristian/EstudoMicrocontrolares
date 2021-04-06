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
 * Definições Gerais;
 */
#define TRUE  1
#define FALSE 0
#define DR_REG_RNG_BASE   0x3ff75144

/**
 * Debug?
 */
#define DEBUG 1

#endif 