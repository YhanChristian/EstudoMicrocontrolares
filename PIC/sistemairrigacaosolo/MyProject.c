/*
  Projeto: Sistema de Irrigacao do Solo
  Utilizado: PIC18F4550
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=n-jxNHvd5WY&index=11&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

// -- Configuracao pinos LCD --
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

// -- Direçao IOs
sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;

// -- Definicao de Hardware --
#define output LATD0_bit

// -- Pototipo funçoes externas --
extern int dht11(unsigned short type);
extern void initDht11();

// -- Prototipo funçoes auxiliares --
void configureMcu();
void initDisplay();
int groundHumidity();
void readTemperature();
void readHumidity();


// -- Variaveis globais --
unsigned short flagA;
#define switchInfo flagA.B0

unsigned int timerCounterAux = 0;
unsigned short digit01, digit02, digit03;


// -- Interrupçao p/ gerar 1 segundo --

void interrupt() {
     if(TMR0IF_bit) {
          TMR0IF_bit = 0x00;
          TMR0L = 0xFF;
          TMR0H = 0x7F;
          timerCounterAux++;
          
          if(timerCounterAux == 180) {
                timerCounterAux = 0;
                switchInfo = ~switchInfo;
                output = ~output;
          }
     }
}

void main() {
     configureMcu();
     initDisplay();
     initDht11();

     while(1) {
          readTemperature();
          delay_ms(150);
          readHumidity();
          delay_ms(150);
     }
}

void configureMcu() {
     CMCON = 0x07; //Desabilita comparadores
     ADCON1 = 0x0E; //Habilita AN0, VDD e VSS como referencia
     ADCON0 = 0x00; // Seleciona AN0
     ADC_Init(); // Inicia ADC
     INTCON = 0xE0; // Habilita interrupçoes externa, habilita TMR0
     OSCCON = 0x72; //Configura OSC interno 8MHz
     TRISD0_bit = 0x00; // Configura D0 como saida
     LATD0_bit = 0x00;
     TMR1IE_bit = 0x01; // Habilita TMR1
     T0CON = 0x80; // TMR0, 16bits, inc ciclo maquina, prescaler 1:2 (pg. 127)
     TMR0L = 0xFF; //byte menos significativo
     TMR0H = 0x7F; //byte mais significativo
}

// -- Funcao para inicializar display --
void initDisplay() {
     Lcd_INIT();
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Cmd(_LCD_CLEAR);
}

int groundHumidity() {
    int value;
    value = ADC_Read(0);
    value = value * 0.09765625; //Valor retornado em % (100/1024)
    return value;
}

void readTemperature() {
    int temp;
    temp = dht11(2);

    // -- Separa digitos --
    temp = temp / 100;
    digit01 = temp / 10;
    digit02 = temp % 10;

    // -- Plota no Display LCD --
    lcd_out(1, 1, "Temperatura:");
    lcd_chr(1, 14, digit01 + 48);
    lcd_chr_cp(digit02 + 48);
}

void readHumidity() {
     int hum01, hum02;
     hum01 = dht11(1);
     hum02 = groundHumidity();

     // -- Plota na tela e separa digitos --
     if(switchInfo) {
          hum01 = hum01 / 100;
          digit01 = hum01 / 10;
          digit02 = hum01 % 10;
          lcd_out(2, 1, "Umidade Ar:");
          lcd_chr(2, 14, digit01 + 48);
          lcd_chr_cp(digit02 + 48);
     }

     else {
          digit01 = hum02 / 100;
          digit02 = hum02 / 10 - digit01 * 10;
          digit03 = hum02 % 10;
          lcd_out(2, 1, "Umid. Solo:");
          lcd_chr(2,13, digit01 + 48);
          lcd_chr_cp(digit02 + 48);
          lcd_chr_cp(digit03 + 48);
     }
}
