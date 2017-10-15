#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/termostatoprogramavel.c"
#line 16 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/termostatoprogramavel.c"
sbit SoftSpi_CLK at RA0_bit;
sbit SoftSpi_SDI at RA1_bit;
sbit SoftSpi_SDO at RA2_bit;

sbit SoftSpi_CLK_Direction at TRISA0_bit;
sbit SoftSpi_SDI_Direction at TRISA1_bit;
sbit SoftSpi_SDO_Direction at TRISA2_bit;


extern unsigned short bcdData(unsigned short digit);
extern int dht11(unsigned short type);
extern void initDht11();


void configureMcu();
void readTemperature();
void readButtons();
void setupTemperature();


unsigned short flagButton;





int myCounter01, value;


void interrupt() {
 if(TMR2IF_bit) {
 TMR2IF_bit = 0x00;
 myCounter01++;
  PORTB.F5  =!  PORTB.F5 ;
 }
}


void main() {
 configureMcu();
 while(1) {
 readTemperature();
 delay_ms(200);
 }
}

void configureMcu() {
 CMCON = 0x07;
 TRISB0_bit = 0x00;
 TRISB1_bit = 0x00;
 TRISB3_bit = 0x01;
 TRISB4_bit = 0x01;
 TRISB5_bit = 0x00;
 Soft_SPI_Init();
 INTCON.GIE = 0x01;
 INTCON.PEIE = 0x01;
 TMR2IE_bit = 0x01;
 T2CON = 0x78;
  flagButton.F4  = 0x00;
 initDht11();
}

void readTemperature() {
 unsigned short digit01, digit02;
 int temp;
 setupTemperature();
 temp = dht11(2);
 value = temp;
 value = value / 100;
 digit02 = value / 10;
 digit01 = value % 10;
 digit02 = bcdData(digit02);
 digit01 = bcdData(digit01);


  PORTB.F0  = 0;
 Soft_SPI_Write(digit02);
  PORTB.F0  = 1;

  PORTB.F1  = 0;
 Soft_SPI_Write(digit01);
  PORTB.F1  = 1;
}


void setupTemperature() {
 unsigned short i ,setTemperature;
 if ( flagButton.F2  ||  flagButton.F3  ||  flagButton.F4 ) {
 if(! flagButton.F4 ) {
  flagButton.F4  = 0x01;
 myCounter01 = 0x00;
 TMR2ON_bit = 0x01;
 }

 if(myCounter01 < 500)  flagButton.F4  = 0x01;
 else {
  flagButton.F4  = 0x00;
 TMR2ON_bit = 0x00;
 }

 for (i = 0; i < 3; i++) {
  PORTB.F0  = 0x00;
  PORTB.F1  = 0x00;
 Soft_SPI_Write(0);
  PORTB.F0  = 0x01;
  PORTB.F1  = 0x01;
 delay_ms(500);
  PORTB.F0  = 0x00;
  PORTB.F1  = 0x00;
 Soft_SPI_Write(255);
  PORTB.F0  = 0x01;
  PORTB.F1  = 0x01;
 delay_ms(500);
 }
 }
 if( flagButton.F2 ) {
 myCounter01 = 0x00;
 if(setTemperature > 40) setTemperature = 40;
 else setTemperature++;
 }

 if( flagButton.F3 ) {
 myCounter01 = 0x00;
 if(setTemperature < 1) setTemperature = 1;
 else setTemperature--;
 }

 value = setTemperature * 100;
}


void readButtons() {
 if( PORTB.F3 )  flagButton.F0  = 0x01;
 if(! PORTB.F3  &&  flagButton.F0 ) {
  flagButton.F2  = 0x01;
  flagButton.F0  = 0x00;
 }

 if( PORTB.F4 )  flagButton.F1  = 0x01;
 if(! PORTB.F4  &&  flagButton.F1 ) {
  flagButton.F3  = 0x01;
  flagButton.F1  = 0x00;
 }
}
