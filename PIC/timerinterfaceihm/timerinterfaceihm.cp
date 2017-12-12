#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/timerinterfaceihm/timerinterfaceihm.c"
#line 9 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/timerinterfaceihm/timerinterfaceihm.c"
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








void configureMcu();
void initDisplay();
void display();


unsigned short flags;



short pr2Value = 255;
int tmr02Counter = 0;
unsigned int myTimer = 0;





void interrupt() {
 if(TMR2IF_bit) {
 TMR2IF_bit = 0x00;
  flags.B0  = ~ flags.B0 ;
 if( flags.B0 ) {
 tmr02Counter++;
 if(tmr02Counter == 490) {
  flags.B1  = ~ flags.B1 ;
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

 if( flags.B1 ) {
 myTimer++;
  flags.B1  = 0;
 }
 }
}

void configureMcu() {
 CMCON = 0x07;
 TRISB0_bit = 0x00;
 INTCON.GIE = 0x01;
 INTCON.PEIE = 0x01;
 TMR2IE_bit = 0X01;
 T2CON = 0x01;
 PR2 = pr2Value;
}

void initDisplay() {
 Lcd_Init();
 Lcd_CMD(_LCD_CLEAR);
 Lcd_CMD(_LCD_CURSOR_OFF);
}

void display() {
 unsigned short time[6], second, minute, hour;
#line 101 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/timerinterfaceihm/timerinterfaceihm.c"
 hour = (myTimer / 60) / 60;
 minute = (myTimer - (hour * 3600)) / 60;

 if(myTimer < 59) second = myTimer - (minute * 60 + hour * 3600);
 else {
 second = myTimer;
 minute = 0;
 hour = 0;
 }


 time[0] = hour / 10;
 time[1] = hour % 10;
 time[2] = minute / 10;
 time[3] = minute % 10;
 time[4] = second / 10;
 time[5] = second % 10;



 lcd_chr(1, 5, time[0] + 48);
 lcd_chr_cp(time[1] + 48);
 lcd_chr_cp(':');
 lcd_chr_cp(time[2] + 48);
 lcd_chr_cp(time[3] + 48);
 lcd_chr_cp(':');
 lcd_chr_cp(time[4] + 48);
 lcd_chr_cp(time[5] + 48);
}
