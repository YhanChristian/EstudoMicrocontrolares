/*
 * File:   uart.c
 * Author: User
 *
 * Created on 31 de Janeiro de 2021, 15:48
 */


#include <xc.h>
#include <stdint.h>        
#include <stdbool.h>  
#include "config.h"
#include "uart.h"

 void UART_Initialize(const uint16_t baud)
{
    //Seta TRISC6 (RX) e TRISC7 (TX)
    TRISC6  = OUTPUT;
    TRISC7 = INPUT;
    
    /* Inicializa registrador SPBRG como requirido
     * Configura BAUD-RATE como requirido
     */
    
    SPBRG = (_XTAL_FREQ / (long)(16UL * baud)) - 1; 
    
    /*
    Habilita modo assincrono
    Habilita transmissão e recepção de dados
    Habilita modo de 8bits
     */
    
    TXSTA = 0x24;
    RCSTA = 0x90;
}

char UART_TX_Empty()
{
    return TRMT;
}

char UART_Data_Ready()
{
    return RCIF;
}

char UART_Read()
{
   //Verifica Erro 
    if(OERR)
    {
        CREN = 0; //If error -> Reset 
        CREN = 1; //If error -> Reset 
    }
 
  while(!RCIF)
  {
      
  }
  RCIF = LOW; //Limpa Flag
  return RCREG;
}

char UART_Read_String(char *data, unsigned int length)
{
	for(int i = 0;i < length; i++)
    {
       data[i] = UART_Read(); 
    }		
}

void UART_Write(char data)
{
    while(!TXIF)
   {
       
   }
  TXIF = LOW; // Limpa Flag
  TXREG = data;
}

void UART_Write_String(char *data)
{
      for(int i = 0;data[i] != '\0'; i++)
      {
          UART_Write(data[i]);
      }
}