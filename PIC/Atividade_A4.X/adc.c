/**
 ******************************************************************************
 * @Company    : Yhan Christian Souza Silva
 * @file       : adc.c
 * @author     : Yhan Christian Souza Silva
 * @date       : 18/11/2023
 * @brief      : Arquivo source com funções, defines para uso do ADC
 ******************************************************************************
 */

/* Includes ------------------------------------------------------------------*/
#include "adc.h"

/* Public objects ------------------------------------------------------------*/

/* Bodies of private functions -----------------------------------------------*/

/* Bodies of public functions ------------------------------------------------*/
int iConfigADC(int iNumChannels) {
    /*Limita a configuração de quantidade canais entre 1 e 4
     Caso esteja fora destes valores retorna erro*/
    if(iNumChannels < 1 || iNumChannels > 4) {
        return ADC_INV_PARAM;
    }
    /*Habilita ADC*/
    ADON |= 0x01;
    
    /*Define quais pinos são analógicos*/
    ADCON1 = (ADCON1 & 0xF0) | (unsigned char)(0x0F - iNumChannels);

    /*Configura Registrador TRIS*/
    TRISA |= (0x0F << (4 - iNumChannels));
        
    /*Configura A/D 
     * ADCS - Fosc/16
     * ACQT - 4 TAD 
       ADFM - Right justified */
    ADCON2 = 0x95;
    
    return ADC_OK;
}

int iAnalogRead(int iChannel) {
    /*Limita do canal 0 ao canal 3*/
    if(iChannel < 0 || iChannel > 3) {
        return ADC_INV_PARAM;
    }
    /*Verifica Channel e escreve em CHS*/
    ADCON0 |= (iChannel << 4);

    /*Habilita conversão AD*/
    GO_nDONE = TRUE;

    while (GO_nDONE) {
    }
    return ((ADRESH << 8 ) | ADRESL);
}

/*****************************EN1D OF FILE**************************************/