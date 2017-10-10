/*
  Projeto: Frequencimetro Simples 8 bits
  Utilizado: PIC18F4550
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=SXZIC92f7zw&list=PLZ8dBTV2_5HQO03YC3RsgYvhwA375Ou79&index=17
*/


#define output LATB0_bit

// -- Prototipo com funções auxiliares --
void configureMcu();
void initLcd();
void readFrequency();


// -- Variáveis

char myFrequency[8];
unsigned short auxT1;

// Conexões display LCD 16 x 2 utilizando 4bits MSB
// Será utilizado o portD

sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;

// -- Função Main --
void main() {
     configureMcu();
     initLcd();
  
 /* Loop Infinito testanto estouro do timer
 Variavel auxT1 incrementa até 10 para leitura de frequencia e mudança estado
  RB0 a cada 1s
 */
     while(1) {
       if(TMR1IF_bit) {
            TMR1IF_bit = 0x00;
            TMR1H = 0x3C;
            TMR1L = 0xB0;
            auxT1++;
            if(auxT1 == 10) {
                 readFrequency();
                 output = ~output;
                 auxT1 = 0x00;
            }
       }
     }
}

void configureMcu() {
     ADCON1 = 0x0F; // Todos IO's Digitais
     T0CON = 0xE8; // Timer 8 bits, prescaler 1:1, incrementa de low to high
     TRISB = 0x0E;
     LATB =  0x00;
     TMR0L = 0x00;
     T1CON = 0xB1; //Timer 16 bits, prescaler 1:8
// -- Carrega registradores TMR1, para base de tempo de 100ms --
     TMR1H = 0x3C;
     TMR1L = 0xB0;
}
void initLcd(){
     Lcd_Init();
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Cmd(_LCD_CLEAR);
}

// -- Função para leitura da frequencia através do TMR0L e conversão do valor
// para string para exibição em LCD 16x2

void readFrequency() {
     unsigned int frequency;
     frequency = TMR0L;
     FloatToStr(frequency, myFrequency);
     lcd_chr(1,4, 'F');
     lcd_chr_cp('r');
     lcd_chr_cp('e');
     lcd_chr_cp('q');
     lcd_chr_cp('u');
     lcd_chr_cp('e');
     lcd_chr_cp('e');
     lcd_chr_cp('n');
     lcd_chr_cp('c');
     lcd_chr_cp('i');
     lcd_chr_cp('a');
     lcd_chr(2,6,myFrequency[0]);                     //Imprime no LCD posição 0 da string txt
     lcd_chr_cp (myFrequency[1]);                     //Imprime no LCD posição 1 da string txt
     lcd_chr_cp (myFrequency[2]);                     //Imprime no LCD posição 2 da string txt
     lcd_chr_cp (myFrequency[3]);                     //Imprime no LCD posição 3 da string txt
     lcd_chr_cp (myFrequency[4]);                     //Imprime no LCD posição 4 da string txt
     lcd_chr(2,12, 'H');
     lcd_chr_cp ('z');
}

