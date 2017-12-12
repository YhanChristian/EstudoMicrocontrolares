/*
  Projeto: timer com interface IHM program�vel
  Utilizado: PIC16F628A
  Autor: Yhan Christian Souza Silva
  Refer�ncias: https://www.youtube.com/watch?v=Nn6nwPWSO_A&index=7&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

// -- Conex�es LCD --
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

// -- Dire��o pino io --

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;




// -- Defini��o de hardware --
#define output PORTB.F0

// -- Prot�tipo de fun��es Auxiliares --
void configureMcu();
void initDisplay();
void display();

// -- Vari�veis globais --
unsigned short flags;
#define tmr02Trigger flags.B0
#define oneSecond flags.B1

short pr2Value = 255;
int tmr02Counter = 0;
unsigned int myTimer = 0;



//-- Interrup��o p/ gera��o de tempo de 1s --

void interrupt() {
     if(TMR2IF_bit) {
          TMR2IF_bit = 0x00;
          tmr02Trigger = ~tmr02Trigger;
          if(tmr02Trigger) {
               tmr02Counter++;
               if(tmr02Counter == 490) {
                    oneSecond = ~oneSecond;
                    tmr02Counter = 0;
               }
          }
     }

}

void main() {
     configureMcu();
     while(1) {
         TMR2ON_bit = 0x01;
         display();
         
         if(oneSecond) {
              myTimer++;
              oneSecond = 0;
         }
     }
}

void configureMcu() {
     CMCON = 0x07;       // Desabilita comparadores
     TRISB0_bit = 0x00;  // RB0 como sa�da
     INTCON.GIE = 0x01;  // Habilita interrup��o global
     INTCON.PEIE = 0x01; // Habilita interrup��o de perif�ricos
     TMR2IE_bit = 0X01;  // Habilita interrup��o do TMR2
     T2CON = 0x01;       // Config TMR2 Postscaler 1 Prescaler 4, timer desabilitado
     PR2 =  pr2Value;    // Atribui a PR2 o valor da variavel pr2Value
}

void initDisplay() {
     Lcd_Init();
     Lcd_CMD(_LCD_CLEAR);
     Lcd_CMD(_LCD_CURSOR_OFF);
}

void display() {
     unsigned short time[6], second, minute, hour;     // Cria-se vetor timer, e variaveis second, minute, hour
 
 /*  1 min = 60s
     1 hora = 3600s
     Para convers�es e para obter o resto � necess�rio realizar alguns calculos pois
     utiliza-se uma vari�vel int
 */
     hour = (myTimer / 60) / 60;    // Obtem valor hora
     minute = (myTimer - (hour * 3600)) / 60; // Resto da hora minutos
     
     if(myTimer < 59) second = myTimer - (minute * 60 + hour * 3600); // Resto de minutos segundos
     else {
          second = myTimer;
          minute = 0;
          hour = 0;
     }
  
  // -- Calcula digitos 01 e 02 de hora, minuto, segundo --
     time[0] = hour / 10;
     time[1] = hour % 10;
     time[2] = minute / 10;
     time[3] = minute % 10;
     time[4] = second / 10;
     time[5] = second % 10;
     
  // -- Imprime dezenas e unidaddes de hora, minuto e segundo --

     lcd_chr(1, 5, time[0] + 48);
     lcd_chr_cp(time[1] + 48);
     lcd_chr_cp(':');
     lcd_chr_cp(time[2] + 48);
     lcd_chr_cp(time[3] + 48);
     lcd_chr_cp(':');
     lcd_chr_cp(time[4] + 48);
     lcd_chr_cp(time[5] + 48);
}