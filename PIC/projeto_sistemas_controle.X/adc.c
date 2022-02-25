/*
 * File:   adc.c
 * Author: User
 *
 * Created on 29 de Janeiro de 2021, 11:04
 */

#include <xc.h>
#include <stdint.h>        
#include <stdbool.h>  
#include "config.h"
#include "adc.h"

void ADC_Initialize()
{
    ADCON0 = 0x81; //ADC ligado Fosc/16 taxa de conversao
    ADCON1 = 0xC0; //Configurado tens�o interna como refer�ncia  
}

uint16_t ADC_Read(uint8_t ch)
{
    //Se colocar Canal > 7 retorna o canal 0
    if (ch > 7) {
        return 0;
    }
        
  ADCON0 &= 0xC5;                //Limpa sele��o de sele��o
  ADCON0 |= ch << 3;            //Seta bit
  __delay_ms(TEMPO_AQUISICAO);  //Aguarda carga capacitor(tempo aquisi��o ADC) 
  GO_nDONE = 1;                 //Realiza convers�o A/D
  while(GO_nDONE);              //Aguarda convers�o A/D
  return ((ADRESH << 8)+ ADRESL); //Retorna valor convertido
}