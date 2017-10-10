#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/frequencimetrosimples/frequencimetrosimples.c"
#line 12 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/frequencimetrosimples/frequencimetrosimples.c"
void configureMcu();
void initLcd();
void readFrequency();




char myFrequency[4];
unsigned short auxT1;




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


void main() {
 configureMcu();
 initLcd();
#line 48 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/frequencimetrosimples/frequencimetrosimples.c"
 while(1) {
 if(TMR1IF_bit) {
 TMR1IF_bit = 0x00;
 TMR1H = 0x3C;
 TMR1L = 0xB0;
 auxT1++;
 if(auxT1 == 10) {
 readFrequency();
  LATB0_bit  = ~ LATB0_bit ;
 auxT1 = 0x00;
 }
 }
 }
}

void configureMcu() {
 ADCON1 = 0x0F;
 T0CON = 0xE8;
 TRISB = 0x0E;
 LATB = 0x00;
 TMR0L = 0x00;
 T1CON = 0xB1;

 TMR1H = 0x3C;
 TMR1L = 0xB0;
}
void initLcd(){
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
}




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
 lcd_chr_cp('n');
 lcd_chr_cp('c');
 lcd_chr_cp('i');
 lcd_chr_cp('a');
 lcd_chr(2,6,myFrequency[0]);
 lcd_chr_cp (myFrequency[1]);
 lcd_chr_cp (myFrequency[2]);
 lcd_chr_cp (myFrequency[3]);
 lcd_chr_cp (myFrequency[4]);
 lcd_chr(2,12, 'H');
 lcd_chr_cp ('z');
}
