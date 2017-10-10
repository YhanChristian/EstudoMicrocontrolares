#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/termostatoprogramavel.c"
#line 12 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/termostatoprogramavel.c"
sbit SoftSpi_CLK at RA0_bit;
sbit SoftSpi_SDI at RA1_bit;
sbit SoftSpi_SDO at RA2_bit;

sbit SoftSpi_CLK_Direction at TRISA0_bit;
sbit SoftSpi_SDI_Direction at TRISA1_bit;
sbit SoftSpi_SDO_Direction at TRISA2_bit;


extern unsigned short bcdData(unsigned short digit);



void configureMcu();

void main() {
 unsigned short counter, digit01, digit02;
 configureMcu();
 while(1) {
 for(counter = 0; counter < 100; counter ++) {

 digit02 = counter / 10;
 digit01 = counter % 10;
 digit02 = bcdData(digit02);
 digit01 = bcdData(digit01);


  PORTB.F0  = 0;
 Soft_SPI_Write(digit02);
  PORTB.F0  = 1;


  PORTB.F1  = 0;
 Soft_SPI_Write(digit01);
  PORTB.F1  = 1;

 delay_ms(200);
 }
 counter = 0;
 }
}

void configureMcu() {
 CMCON = 0x07;
 TRISB = 0x0D;
 Soft_SPI_Init();
}
