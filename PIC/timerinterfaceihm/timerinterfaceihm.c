/*
  Projeto: timer com interface IHM programável
  Utilizado: PIC16F628A
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=Nn6nwPWSO_A&index=7&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

// -- Conexões LCD --
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

// -- Direção pino io --

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;

// -- Definição de hardware --
#define encoderSW PORTA.F0
#define encoderCLK PORTA.F1
#define encoderDT PORTA.F2
#define output PORTB.F0

// -- Protótipo de funções Auxiliares --
void configureMcu();
void initDisplay();
void display(unsigned short line, unsigned int value);
void readButtons();
unsigned short controlCharge(unsigned long long value01, unsigned long long value02);

// -- Variáveis globais --
unsigned short flagA = 0, flagB = 0;
#define tmr02Trigger flagA.B0
#define oneSecond flagA.B1
#define encoderInc flagA.B2
#define encoderDec flagA.B3
#define encoderFlag flagA.B4
#define encoderSWFlag flagA.B5
#define encoderPushButton flagA.B6
#define active flagA.B7
#define activeFlag flagB.B0
#define configureMode flagB.B1
#define updateDisplay flagB.B2
#define oneSecondActive flagB.B3

unsigned short pr2Value = 255, intCounter = 0;
int tmr02Counter[2] = {(0,0)};
unsigned int myTimer = 0, timeSet =0;

//-- Interrupção p/ geração de tempo de 1s --

void interrupt() {
     if(TMR2IF_bit) {
          TMR2IF_bit = 0x00;
          tmr02Trigger = ~tmr02Trigger;
          if(tmr02Trigger) {
               tmr02Counter[0]++;
               tmr02Counter[1]++;
               if(tmr02Counter[0] == 490) {
                    oneSecond = ~oneSecond;
                    oneSecondActive = ~oneSecondActive;
                    tmr02Counter[0] = 0;
               }
               if(tmr02Counter[1] == 30) {
                    oneSecond = ~oneSecond;
                    updateDisplay = ~updateDisplay;
                    tmr02Counter[1] = 0;
               }
          }
     }
}

void main() {
     configureMcu();
     initDisplay();

     while(1) {
         TMR2ON_bit = 0x01;
         readButtons();
         
         if(updateDisplay) display(2, timeSet);
         
         if(active) {
              if(oneSecond) {
                    display(1, myTimer);
                    myTimer++;
                    oneSecond = 0x00;
                    active = ControlCharge(myTimer, timeSet);
              }
         }
         else {
              myTimer = 0x00;
              if(encoderInc) {
                   if(timeSet < 86399) timeSet++;
              }
              if(encoderDec) {
                   if(timeSet > 0) timeSet--;
              }
         }

        encoderDec = 0x00;
        encoderInc = 0x00;
        encoderPushButton = 0x00;

     }
}

void configureMcu() {
     CMCON = 0x07;       // Desabilita comparadores
     TRISB0_bit = 0x00;  // RB0 como saída
     TRISA = 0x07;       // Defino pinos RA0, RA1 e RA2 como entrada
     INTCON.GIE = 0x01;  // Habilita interrupção global
     INTCON.PEIE = 0x01; // Habilita interrupção de periféricos
     TMR2IE_bit = 0X01;  // Habilita interrupção do TMR2
     T2CON = 0x01;       // Config TMR2 Postscaler 1 Prescaler 4, timer desabilitado
     PR2 =  pr2Value;    // Atribui a PR2 o valor da variavel pr2Value
     
     // -- Iniciando com variáveis zeradas --
     active = 0x00;
     encoderInc = 0x00;
     encoderDec = 0x00;
     encoderPushButton = 0x00;
}

void initDisplay() {
     Lcd_Init();
     Lcd_CMD(_LCD_CLEAR);
     Lcd_CMD(_LCD_CURSOR_OFF);
     display(1, myTimer);
     display(2, timeSet);
}

void display(unsigned short line, unsigned int value) {
     unsigned short time[6], second, minute, hour;     // Cria-se vetor timer, e variaveis second, minute, hour
 
 /*  1 min = 60s
     1 hora = 3600s ( 60 *60)
     Para conversões e para obter o resto é necessário realizar alguns calculos pois
     utiliza-se uma variável int
 */
     hour = (value / 60) / 60;    // Obtem valor hora
     minute = (value - (hour * 3600)) / 60; // Resto da hora minutos
     
     if(myTimer > 59) second = value - (minute * 60 + hour * 3600); // Resto de minutos segundos
     else {
          second = value;
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

     lcd_chr(line, 5, time[0] + 48);
     lcd_chr_cp(time[1] + 48);
     lcd_chr_cp(':');
     lcd_chr_cp(time[2] + 48);
     lcd_chr_cp(time[3] + 48);
     lcd_chr_cp(':');
     lcd_chr_cp(time[4] + 48);
     lcd_chr_cp(time[5] + 48);
}

void readButtons() {

//  -- Rotativo --

     if(!encoderCLK) {
          encoderFlag = 0x01;
          encoderInc = 0x01;
     }
     else {
          if(!encoderDT) {
                if(!encoderFlag) {
                     encoderFlag = 0x01;
                     encoderDec = 0x01;
                }
          }
     }
     if(encoderCLK) {
          if(encoderDT) encoderFlag = 0x00;
     }
     
     if(!encoderSW) {
          if(oneSecondActive) {
               intCounter++;
               oneSecondActive = 0x00;
          }
          if(intCounter > 2) activeFlag = 0x01;
          else encoderSWFlag = 0x01;
          
     }
     
     if(encoderSWFlag && encoderSW) {
          encoderPushButton = 0x01;
          encoderSWFlag = 0x00;
          intCounter = 0x00;
     }
     
     if(activeFlag && encoderSW) {
          active = ~active;
          activeFlag = 0x00;
          intCounter = 0x00;
     }
     
// -- Trata botões --

     if(encoderPushButton) configureMode = ~configureMode;
}

// -- Controle acionamento carga, fica ligado enquanto timer n atinge tempo setado --
unsigned short controlCharge(unsigned long long value01, unsigned long long value02) {
     if(value01 > value02) output = 0x00;
     else output = 0x01;
     return output;
}