#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/termostatoprogramavel.c"
#line 12 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/termostatoprogramavel.c"
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

void main() {
 configureMcu();
 while(1) {
 readTemperature();
 delay_ms(200);
 }
}

void configureMcu() {
 CMCON = 0x07;
 TRISB0_bit = 0;
 TRISB1_bit = 0;
 Soft_SPI_Init();
 initDht11();
}

void readTemperature() {
 unsigned short digit01, digit02;
 int temp;
 temp = dht11(2);
 temp = temp / 100;
 digit02 = temp / 10;
 digit01 = temp % 10;
 digit02 = bcdData(digit02);
 digit01 = bcdData(digit01);


  PORTB.F0  = 0;
 Soft_SPI_Write(digit02);
  PORTB.F0  = 1;

  PORTB.F1  = 0;
 Soft_SPI_Write(digit01);
  PORTB.F1  = 1;
}
