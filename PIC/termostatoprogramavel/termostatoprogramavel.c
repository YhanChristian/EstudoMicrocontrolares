/*
  Projeto: Termostato programavel
  Utilizado: PIC16F628A
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=66T8XE1tf_s&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

// -- Definição de hardware --
#define enable7seg01 PORTB.F0
#define enable7seg02 PORTB.F1
#define button01 PORTB.F3
#define button02 PORTB.F4
#define output PORTB.F5

// -- Conexão SPI via software --
sbit SoftSpi_CLK at RA0_bit;
sbit SoftSpi_SDI at RA1_bit;
sbit SoftSpi_SDO at RA2_bit;

sbit SoftSpi_CLK_Direction at TRISA0_bit;
sbit SoftSpi_SDI_Direction at TRISA1_bit;
sbit SoftSpi_SDO_Direction at TRISA2_bit;

// -- Protótipo de funções Externas --
extern unsigned short bcdData(unsigned short digit);
extern int dht11(unsigned short type);
extern void initDht11();

// -- Protótipo de funções Auxiliares --
void configureMcu();
void readTemperature();
void adjustTemperature(int set, int temperature, unsigned short type);
void readButtons();


// -- Variáveis globais --
int myCounter01;
unsigned short flags, setTemperature;
#define flagButton01 flags.F0
#define flagButton02 flags.F1
#define myButton01 flags.F2
#define myButton02 flags.F3
#define setEnable flags.F4
#define adjustMode flags.F5

// -- Constantes --
#define maxTemp 40
#define minTemp 1

//-- Interrupção --
void interrupt() {
     if(TMR2IF_bit) {
          TMR2IF_bit = 0x00;
          myCounter01++;
     }
}

// -- Função Principal --
void main() {
    configureMcu();
    while(1) {
      readButtons();
      readTemperature();
    }
}
// -- Funções Auxiliares --
void configureMcu() {
    CMCON = 0x07; // Desabilita-se comparadores
    TRISB0_bit = 0x00;  // Configura RB0 como saída
    TRISB1_bit = 0x00;  // Configura RB1 como saída
    TRISB3_bit = 0x01;  //Configura RB3 como entrada
    TRISB4_bit = 0x01;  // Configura RB4 como entrada
    TRISB5_bit = 0x00; //Configura RB5 como saída
    Soft_SPI_Init(); // Inicia-se software SPI
    INTCON.GIE = 0x01; // Habilita-se interrupção global
    INTCON.PEIE = 0x01; // Interrupção dos periféricos
    TMR2IE_bit = 0x01; // Habilita interrupção no Timer 02
    T2CON = 0x78; // Timer 2 inicia desligado, postscaler 1:16, prescaler 1:1 (página 55 do datasheet PIC16F628A)
    setEnable = 0x00;
    output = 0x00;
    initDht11();
}

void readTemperature() {
    unsigned short digit01, digit02, i;
    int temp, value;

    if(myButton01 || myButton02 || setEnable) {
        if(!setEnable) {
            setEnable = 0x01;
            myCounter01 = 0x00;
            TMR2ON_bit = 0x01;
        }
        if(myCounter01 < 500)setEnable = 0x01;
        else {
            setEnable = 0x00;
            TMR2ON_bit = 0x00;
            for(i = 0; i < 3; i++) {
                 enable7seg01 = 0x00;
                 enable7seg02 = 0x00;
                 Soft_SPI_Write(0);
                 enable7seg01 = 0x01;
                 enable7seg02 = 0x01;
                 delay_ms(400);
                 enable7seg01 = 0x00;
                 enable7seg02 = 0x00;
                 Soft_SPI_Write(255);
                 enable7seg01 = 0x01;
                 enable7seg02 = 0x01;
                 delay_ms(400);
            }
        }
        if(myButton01) {
            myCounter01 = 0x00;
            if(setTemperature >= maxTemp) setTemperature = maxTemp;
            else setTemperature++;
        }

        if(myButton02) {
            myCounter01 = 0x00;
            if(setTemperature <= minTemp) setTemperature = minTemp;
            else setTemperature--;
        }
        value = setTemperature * 100;
    }

    else {
        temp = dht11(2);
        value = temp;
        // -- Sistema para aquecimento --
        adjustMode = 0x00;
        adjustTemperature(setTemperature * 100, temp, adjustMode);
    }
    value = value / 100;
    digit02 = value / 10;
    digit01 = value % 10;
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
    myButton01 = 0x00;
    myButton02 = 0x00;
    delay_ms(100);
}

void adjustTemperature(int set, int temperature, unsigned short type) {
     if(!type) {
     // -- Se temperature > set + 5ºC desliga aquecedor --
         if(temperature > (set + 500)) output = 0x00;
         else output = 0x01;
     }
     
     // -- Por enquanto n utilizado modo de resfriamento --
    /*
     else {
          if(temperature > set) output = 0x00;
          else output = 0x01;
     }  */
}

void readButtons() {
     if(button01) flagButton01 = 0x01;
     if(!button01 && flagButton01) {
          myButton01 = 0x01;
          flagButton01 = 0x00;
     }

     if(button02) flagButton02 = 0x01;
     if(!button02 && flagButton02) {
          myButton02 = 0x01;
          flagButton02 = 0x00;
     }
}