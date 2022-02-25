
//========================== Bibliotecas Auxiliares ============================
#include <xc.h>
#include <stdint.h>        
#include <stdbool.h>  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"  //Arquivo de configuração MCU
#include "lcd.h"    //Biblioteca Display LCD 16x2
#include "adc.h"    //Biblioteca funções ADC
#include "pwm.h"    //Biblioteca funções PWM
#include "uart.h"   //Biblioteca funções UART

//====================== Protótipo Funções Auxiliares ==========================

void Inicia_Config();
uint16_t Leitura_Vin();
uint16_t Leitura_Vout();
void Disp_Info(uint16_t vin, uint16_t vout);

//================================== Ma6t-------in ======================================

void main(void) 
{
    //Inicia IOs, config de ADC, PWM e Display    
    Inicia_Config(); 
    
    //Loop infinito
    
    while(TRUE)
    {
        //Chama função para exibir tensão de entrada e saida
        Disp_Info(Leitura_Vin(), Leitura_Vout());
        __delay_ms(TEMPO_1SEG);
    }
}


//============================== Funções Auxiliares ============================

void Inicia_Config()
{
    CMCON = 0x07; //Desabilita Comparadores
    //TRISB0 = OUTPUT; Teste realizado com saída RB0 
    ADC_Initialize(); //Inicia ADC
    PWM_Initialize(); //Inicia PWM
    Lcd_Initialize(); //Inicializa Display LCD
    Lcd_Clear(); //Limpa Display
    UART_Initialize(BAUD_RATE); //Inicia comunicação UART BAUD 9600bps
}

uint16_t Leitura_Vin()
{
    uint16_t leTensaoSaida = PWM_Duty(1023);
    return leTensaoSaida;

}

uint16_t Leitura_Vout()
{
    uint16_t leTensaoEntrada = ADC_Read(0);
    return leTensaoEntrada;
}

void Disp_Info(uint16_t vin, uint16_t vout)
{ 
   //Cria-se Chars para conversão
   char *tensaoEntradaConvertido, *tensaoSaidaConvertido;
   char tensaoEntradaNovo[BUFFER_SIZE], tensaoSaidaNovo[BUFFER_SIZE];
   
   //Realiza leitura do valor do ADC e converte para float
   float leituraVin = (vin * 5.0) / 1023.0;
   float leituraVout = (vout * 5.0) / 1023.0;
   
   //Converte Float para String
   tensaoEntradaConvertido = ftoa(leituraVin, &vin);
   strncpy(tensaoEntradaNovo,tensaoEntradaConvertido, CONVERT_SIZE);
   tensaoSaidaConvertido = ftoa(leituraVout, &vout);
   strncpy(tensaoSaidaNovo,tensaoSaidaConvertido, CONVERT_SIZE);
   
   //Exibe os dados no display
   Lcd_Set_Cursor(1,1);
   Lcd_Write_String("Vin:  ");
   Lcd_Write_String(tensaoEntradaNovo);
   Lcd_Set_Cursor(2,1);
   Lcd_Write_String("Vout: ");
   Lcd_Write_String(tensaoSaidaNovo);
   
   //Envia os dados via Serial
   UART_Write_String("Vin: ");
   UART_Write_String(tensaoEntradaNovo);
   UART_Write_String(" Vout: ");
   UART_Write_String(tensaoSaidaNovo);
   UART_Write(10); //Realimentação linha
   UART_Write(13); //Pula linha
   
}


