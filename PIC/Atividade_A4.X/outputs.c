/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : outputs.c
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo source com funções, defines para saídas digitais
 ******************************************************************************
 */


/* Includes ------------------------------------------------------------------*/
#include "outputs.h"

/* Public objects ------------------------------------------------------------*/

/* Bodies of private functions -----------------------------------------------*/
void pinMode(volatile unsigned char *pcTris, uint8_t uiPin, bool fMode) {
    if (!fMode) {
        // Configurar como saída
        *pcTris &= ~(1 << uiPin);
    } else {
        // Configurar como entrada
        *pcTris |= (1 << uiPin);
    }
}

void digitalWrite(volatile unsigned char *pcLat, uint8_t uiPin, bool fState) {
    if (fState) {
        // Setar o pino
        *pcLat |= (1 << uiPin);
    } else {
        // Limpar o pino
        *pcLat &= ~(1 << uiPin);
    }
}

bool digitalRead(volatile unsigned char *pcPort, uint8_t uiPin) {
    return (*pcPort & (1 << uiPin)) != 0;
}

/* Bodies of public functions ------------------------------------------------*/
void configOutputs() {
    int i = 0;
    // Configura Leds como saída e inicia com todos desligados
    for (i = GPIO_LED_0; i < MAX_LEDS; i++) {
        pinMode(&TRISB, (uint8_t) i, OUTPUT);
        digitalWrite(&LATB, (uint8_t) i, LOW);
    }
    // Configura Buzzer e Começa com ele desligado
    pinMode(&TRISC, GPIO_BUZZER, OUTPUT);
    digitalWrite(&LATC, GPIO_BUZZER, LOW);
}

int setLedsOn(uint8_t uiNumLeds) {
    int i = 0;
    if (uiNumLeds > MAX_LEDS) {
        return GPIO_INV_PARAM;
    }
    //Garante Leds em Zero
    LATB = CLEAR_ALL_BITS;

    //Liga somente LEDS passados pelo param
    for (i = 0; i < uiNumLeds; i++) {
        digitalWrite(&LATB, (uint8_t) i, HIGH);
    }

    return GPIO_OK;
}

void changeBuzzerState(bool fState) {
    digitalWrite(&LATC, GPIO_BUZZER, fState);
}

bool readBuzzerState() {
    return digitalRead(&PORTC, GPIO_BUZZER);
}

/*****************************EN1D OF FILE**************************************/