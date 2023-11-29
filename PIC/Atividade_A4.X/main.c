/*
 * Atividade Prática A4 - Yhan Christian Souza Silva
 * Implemente um programa no PIC18F4520 para ajustar a velocidade
 * angular da ventoinha utilizando o trimpot conectado ao pino RA0.
 * + No display LCD deve ser mostrado o valor de tensão aplicada na entrada
 * do conversor ADC e o valor de duty cycle usado para a geração do sinal
 * PWM (para o controle de velocidade).
 * + Os leds conectados na PORTB devem permanecer apagados quando a
 * ventoinha estiver parada, porém os leds devem acender gradativamente
 * (um de cada vez) a medida que a velocidade da ventoinha aumenta.
 * + Quando a ventoinha atingir o seu limite máximo de velocidade angular,
 *  todos os leds devem estar acesos e o buzzer deve apitar a cada 1
 * segundo (1 segundo ligado e 1 segundo desligado).
 */

/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Public objects ------------------------------------------------------------*/
st_timers_t gstTimer1Seg = {
    .fTimerOverflow = FALSE,
    .iContador = 0
};

/* Interrupt service routine -------------------------------------------------*/
void __interrupt() isr(void) {
    if (INTCONbits.TMR0IF) {
        /*Recarrega valores registradores para estouro em 250ms*/
        TMR0H = 0x66;
        TMR0L = 0x5A;

        /*Incrementa Contador e verifica se atingiu 4(250 x 4 = 1000ms)*/
        gstTimer1Seg.iContador++;
        if (gstTimer1Seg.iContador == ONE_SECOND) {
            gstTimer1Seg.fTimerOverflow = ~gstTimer1Seg.fTimerOverflow;
            gstTimer1Seg.iContador = 0;
        }
        /*Limpa Flag de Interrupção Timer 0*/
        INTCONbits.TMR0IF = 0;
    }
}

/* Body of private functions -------------------------------------------------*/
float fGetVoltage(int iValue) {
    return (ADC_VREF * (float)iValue) / (float)ADC_MAX;
}

float fGetPercentDuty(int iValue) {
    return (PWM_PERCENT_MAX * (float)iValue) / (float)PWM_MAX;
}


void MsgInicialLcd() {
    /*Configura Display LCD 16x2*/
    LcdInit();
    /*Exibe Mensagem Inicial*/
    LcdSetCursor(1, 3);
    LcdPutStr("UNIFESP 2023");
    LcdSetCursor(2, 2);
    LcdPutStr("PPG Embarcados");
    __delay_ms(AGUARDA_MSG_LCD);

    /*Limpa Tela*/
    LcdClear();

    /*Informa Atividade*/
    LcdSetCursor(1, 3);
    LcdPutStr("Atividade A4");
    LcdSetCursor(2, 2);
    LcdPutStr("Yhan Christian");
    __delay_ms(AGUARDA_MSG_LCD);

    /*Limpa tela*/
    LcdClear();
}

void DispSystemParam(float fAdcVoltage, float fPercentDuty) {
    char szAdcVoltageDisp[15 + 1];
    char szPercentDutyDisp[15 + 1];

    /*Garante que o char terminará em '\0'*/
    memset(szAdcVoltageDisp, '\0', sizeof (szAdcVoltageDisp));
    memset(szPercentDutyDisp, '\0', sizeof (szPercentDutyDisp));

    /*Formata buffer e exibe LCD*/
    snprintf(szAdcVoltageDisp, sizeof (szAdcVoltageDisp), "ADC (V): %.1f",
            fAdcVoltage);
    snprintf(szPercentDutyDisp, sizeof (szPercentDutyDisp), "Duty(%%): %.2f",
            fPercentDuty);

    /*Imprime informações no Display 16x 2*/
    LcdSetCursor(1, 1);
    LcdPutStr(szAdcVoltageDisp);
    LcdSetCursor(2, 1);
    LcdPutStr(szPercentDutyDisp);

}

void SystemControl() {
    int iValue, iResult, iSt;
    float fVoltage, fPercentDuty;
    iValue = iResult = 0;
    fVoltage = fPercentDuty = 0;

    if (gstTimer1Seg.fTimerOverflow) {
        /*Realiza leitura do ADC*/
        iValue = iAnalogRead(POT_CHANNEL);

        /*Atualiza Valor PWM*/
        iSt = iPWMSetDuty(MOTOR_PIN, iValue);
        if (iSt) {
            /*A definir consequência de falha config PWM*/
        }

        /*Seta Leds de acordo com valor lido*/
        if (iValue > 0) {
            iResult = (iValue / VALOR_INC_LEDS) + 1;
        }
        setLedsOn((uint8_t) iResult);

        /*Verifica LED para escrever saída buzzer*/
        changeBuzzerState((iResult == 8) ?!readBuzzerState() : LOW);

        /*Atualiza Valor Tensão*/
        fVoltage = fGetVoltage(iValue);

        /*Atualiza Duty Cicle em %*/
        fPercentDuty = fGetPercentDuty(iValue);

        /*Atualiza Valores no Display */
        DispSystemParam(fVoltage, fPercentDuty);

        gstTimer1Seg.fTimerOverflow = FALSE;
    }
}

/* Setup Function ------------------------------------------------------------*/
void setup() {
    /* Variaveis Escopo */
    int iSt = 0;
    float fInitVoltage, fInitPwmDuty;
    fInitVoltage = fInitPwmDuty = 0.0;

    /*Configura Saídas*/
    configOutputs();

    /*Configura Entradas Analógicas*/
    iSt = iConfigADC(NUM_CHANNELS);
    if (iSt) {
        /*A definir consequência de falha config ADC*/
    }

    /*Configura Saída PWM*/
    iSt = iConfigPWM(MOTOR_PIN);
    if (iSt) {
        /*A definir consequência de falha config PWM*/
    }

    /*Mensagem Inicial LCD 16x2*/
    MsgInicialLcd();
    
    /*Atualiza Valores de tensão mantendo zerado*/
    DispSystemParam(fInitVoltage, fInitPwmDuty);
    
    /*Configura Interrupção Timer 0*/
    ConfigTimerZeroISR();
}

/* Main Function  ------------------------------------------------------------*/
void main(void) {

    /*Setup com configurações*/
    setup();

    /*Loop infinito Programa*/
    while (TRUE) {
        /*
         * Realiza leitura Potenciometro
         * Seta Leds de Saída e controle PWM sistema
         */
        SystemControl();
    }
}
