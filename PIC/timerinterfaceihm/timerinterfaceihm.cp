#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontroladores/PIC/timerinterfaceihm/timerinterfaceihm.c"
#line 9 "C:/Users/Yhan Christian/Documents/EstudoMicrocontroladores/PIC/timerinterfaceihm/timerinterfaceihm.c"
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;



sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;
#line 35 "C:/Users/Yhan Christian/Documents/EstudoMicrocontroladores/PIC/timerinterfaceihm/timerinterfaceihm.c"
void configureMcu();
void initDisplay();
void display(unsigned short line, unsigned int value);
void readButtons();


unsigned short flagA, flagB;
#line 55 "C:/Users/Yhan Christian/Documents/EstudoMicrocontroladores/PIC/timerinterfaceihm/timerinterfaceihm.c"
unsigned short pr2Value = 255, intCounter = 0;
int tmr02Counter[2] = {(0,0)};
unsigned int myTimer = 0, timeSet =0;



void interrupt() {
 if(TMR2IF_bit) {
 TMR2IF_bit = 0x00;
  flagA.B0  = ~ flagA.B0 ;
 if( flagA.B0 ) {
 tmr02Counter[0]++;
 tmr02Counter[1]++;
 if(tmr02Counter[0] == 490) {
  flagA.B1  = ~ flagA.B1 ;
  flagB.B3  = ~ flagB.B3 ;
 tmr02Counter[0] = 0;
 }
 if(tmr02Counter[1] == 30) {
  flagA.B1  = ~ flagA.B1 ;
  flagB.B2  = ~ flagB.B2 ;
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

 if( flagB.B2 ) display(2, timeSet);

 if( flagA.B7 ) {
 if( flagA.B1 ) {
 display(1, myTimer);
 myTimer++;
  flagA.B1  = 0x00;
 }
 }
 else {
 myTimer = 0x00;
 if( flagA.B2 ) {
 if(timeSet < 86399) timeSet++;
 }
 if( flagA.B3 ) {
 if(timeSet > 0) timeSet--;
 }
 }

  flagA.B3  = 0x00;
  flagA.B2  = 0x00;
  flagA.B6  = 0x00;

 }
}

void configureMcu() {
 CMCON = 0x07;
 TRISB0_bit = 0x00;
 TRISA = 0x07;
 INTCON.GIE = 0x01;
 INTCON.PEIE = 0x01;
 TMR2IE_bit = 0X01;
 T2CON = 0x01;
 PR2 = pr2Value;


  flagA.B7  = 0x00;
  flagA.B2  = 0x00;
  flagA.B3  = 0x00;
  flagA.B6  = 0x00;
}

void initDisplay() {
 Lcd_Init();
 Lcd_CMD(_LCD_CLEAR);
 Lcd_CMD(_LCD_CURSOR_OFF);
 display(1, myTimer);
 display(2, timeSet);
}

void display(unsigned short line, unsigned int value) {
 unsigned short time[6], second, minute, hour;
#line 149 "C:/Users/Yhan Christian/Documents/EstudoMicrocontroladores/PIC/timerinterfaceihm/timerinterfaceihm.c"
 hour = (value / 60) / 60;
 minute = (value - (hour * 3600)) / 60;

 if(myTimer > 59) second = value - (minute * 60 + hour * 3600);
 else {
 second = value;
 minute = 0;
 hour = 0;
 }


 time[0] = hour / 10;
 time[1] = hour % 10;
 time[2] = minute / 10;
 time[3] = minute % 10;
 time[4] = second / 10;
 time[5] = second % 10;



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



 if(! PORTA.F1 ) {
  flagA.B4  = 0x01;
  flagA.B2  = 0x01;
 }
 else {
 if(! PORTA.F2 ) {
 if(! flagA.B4 ) {
  flagA.B4  = 0x01;
  flagA.B3  = 0x01;
 }
 }
 }
 if( PORTA.F1 ) {
 if( PORTA.F2 )  flagA.B4  = 0x00;
 }

 if(! PORTA.F0 ) {
 if( flagB.B3 ) {
 intCounter++;
  flagB.B3  = 0x00;
 }
 if(intCounter > 2)  flagB.B0  = 0x01;
 else  flagA.B5  = 0x01;

 }

 if( flagA.B5  &&  PORTA.F0 ) {
  flagA.B6  = 0x01;
  flagA.B5  = 0x00;
 intCounter = 0x00;
 }

 if( flagB.B0  &&  PORTA.F0 ) {
  flagA.B7  = ~ flagA.B7 ;
  flagB.B0  = 0x00;
 intCounter = 0x00;
 }



 if( flagA.B6 )  flagB.B1  = ~ flagB.B1 ;
}
