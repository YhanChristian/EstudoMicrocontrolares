/*
  Projeto: Sistema de Irrigacao do Solo
  Utilizado: PIC18F4550
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=n-jxNHvd5WY&index=11&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

// -- Configuracao pinos LCD --
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D7 at RB4_bit;
sbit LCD_D6 at RB5_bit;
sbit LCD_D5 at RB6_bit;
sbit LCD_D4 at RB7_bit;

// -- Direçao IOs
sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB4_bit;
sbit LCD_D6_Direction at TRISB5_bit;
sbit LCD_D5_Direction at TRISB6_bit;
sbit LCD_D4_Direction at TRISB7_bit;

// -- Definicao de Hardware --
#define output LATD0_bit

// -- Pototipo funçoes externas --
extern int dht11(unsigned short type);
extern void initDht11();

// -- Prototipo funçoes auxiliares --
void configureMcu();
void readTemperature();
int readHumidity();

// -- Variaveis globais --
unsigned short flagA;
#define switchInfo flagA.B0

unsigned int timerCounterAux = 0;



void main() {
     configureMcu();
     
     while(1) {
          output = ~output;
          delay_ms(1000);
     }
}

void configureMcu() {
     CMCON = 0x07; //Desabilita comparadores
     ADCON1 = 0x0F; //Desabilita portas analogicas
     TRISD0_bit = 0x00; // Configura D0 como saida
     LATD0_bit = 0x00;
}