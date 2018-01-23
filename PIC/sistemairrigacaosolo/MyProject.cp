#line 1 "Z:/home/yhanchristian/Documents/EstudoMicrocontrolares/PIC/sistemairrigacaosolo/MyProject.c"
#line 9 "Z:/home/yhanchristian/Documents/EstudoMicrocontrolares/PIC/sistemairrigacaosolo/MyProject.c"
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D7 at RB4_bit;
sbit LCD_D6 at RB5_bit;
sbit LCD_D5 at RB6_bit;
sbit LCD_D4 at RB7_bit;


sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB4_bit;
sbit LCD_D6_Direction at TRISB5_bit;
sbit LCD_D5_Direction at TRISB6_bit;
sbit LCD_D4_Direction at TRISB7_bit;





extern int dht11(unsigned short type);
extern void initDht11();


void configureMcu();
void readTemperature();
void readHumidity();


unsigned short flagA;


unsigned int timerCounterAux = 0;



void main() {
 configureMcu();

 while(1) {
  LATD0_bit  = ~ LATD0_bit ;
 delay_ms(1000);
 }
}

void configureMcu() {
 CMCON = 0x07;
 ADCON1 = 0x0F;
 TRISD0_bit = 0x00;
 LATD0_bit = 0x00;
}
