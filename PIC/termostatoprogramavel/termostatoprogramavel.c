/*
  Projeto: Termostato programaval
  Utilizado: PIC16F628A
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=66T8XE1tf_s&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

#define enable7seg01 PORTB.F0
#define enable7seg02 PORTB.F1

// -- Conexão SPI via software
sbit SoftSpi_CLK at RA0_bit;
sbit SoftSpi_SDI at RA1_bit;
sbit SoftSpi_SDO at RA2_bit;

sbit SoftSpi_CLK_Direction at TRISA0_bit;
sbit SoftSpi_SDI_Direction at TRISA1_bit;
sbit SoftSpi_SDO_Direction at TRISA2_bit;

// -- Protótipo de funções Externas --
extern unsigned short bcdData(unsigned short digit);

// -- Protótipo de funções Auxiliares --

void configureMcu();

void main() {
    unsigned short counter, digit01, digit02;
    configureMcu();
    while(1) {
        for(counter = 0; counter < 100; counter ++) {
            
            digit02 = counter / 10;
            digit01 = counter % 10;
            digit02 = bcdData(digit02);
            digit01 = bcdData(digit01);
            
            // -- Envia primeiro digito --
           enable7seg01 = 0;
           Soft_SPI_Write(digit02);
           enable7seg01 = 1;
           
           // -- Envia segundo digito --
           enable7seg02 = 0;
           Soft_SPI_Write(digit01);
           enable7seg02 = 1;
           
           delay_ms(200);
        }
        counter = 0;
    }
}

void configureMcu() {
     CMCON = 0x07; // Desabilita-se comparadores
     TRISB = 0x0D; // Configura-se RB0 e RB1 como saída
     Soft_SPI_Init(); // Inicia-se software SPI
}