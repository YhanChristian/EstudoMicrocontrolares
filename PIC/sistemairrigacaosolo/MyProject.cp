#line 1 "Z:/home/yhanchristian/Documentos/EstudoMicrocontrolares/PIC/sistemairrigacaosolo/MyProject.c"
#line 9 "Z:/home/yhanchristian/Documentos/EstudoMicrocontrolares/PIC/sistemairrigacaosolo/MyProject.c"
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






extern int dht11(unsigned short type);
extern void initDht11();


void configureMcu();
void initDisplay();
int groundHumidity();
void readTemperature();
void readHumidity();
void turnOnWaterPump(unsigned short status);
void exhaustFan(unsigned int temperature, float threshold);



unsigned short flagA;


unsigned int timerCounterAux = 0;
unsigned short digit01, digit02, digit03, pwmDuty = 10;
unsigned short pwm2Duty = 80;




void interrupt() {
 if(TMR0IF_bit) {
 TMR0IF_bit = 0x00;
 TMR0L = 0xFF;
 TMR0H = 0x7F;
 timerCounterAux++;

 if(timerCounterAux == 180) {
 timerCounterAux = 0;
  flagA.B0  = ~ flagA.B0 ;
 }
 }
}

void main() {
 configureMcu();
 initDisplay();
 initDht11();

 while(1) {
 readTemperature();
 delay_ms(150);
 readHumidity();
 delay_ms(150);
 }
}

void configureMcu() {
 CMCON = 0x07;
 ADCON1 = 0x0E;
 ADCON0 = 0x00;
 ADC_Init();
 INTCON = 0xE0;
 OSCCON = 0x72;

 TRISD = 0x02;
 LATD0_bit = 0x00;
 LATD1_bit = 0x00;
 TMR1IE_bit = 0x01;
 T0CON = 0x80;
 TMR0L = 0xFF;
 TMR0H = 0x7F;
 PWM1_Init(5000);
 PWM2_Init(5000);
}


void initDisplay() {
 Lcd_INIT();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
}

int groundHumidity() {
 int value;
 value = ADC_Read(0);
 value = value * 0.09765625;
 value = 100 - value;
 return value;
}

void readTemperature() {
 int temp;
 temp = dht11(2);


 exhaustFan(temp, 25.4);


 temp = temp / 100;
 digit01 = temp / 10;
 digit02 = temp % 10;


 lcd_out(1, 1, "Temperatura:");
 lcd_chr(1, 14, digit01 + 48);
 lcd_chr_cp(digit02 + 48);
}

void readHumidity() {
 int hum01, hum02;
 hum01 = dht11(1);
 hum02 = groundHumidity();
#line 152 "Z:/home/yhanchristian/Documentos/EstudoMicrocontrolares/PIC/sistemairrigacaosolo/MyProject.c"
 if( LATD1_bit ) {
 if(hum02 <= 40) turnOnWaterPump(1);
 else {
 if(hum02 >= 65) turnOnWaterPump(0);
 }
 }
 else turnOnWaterPump(0);


 if( flagA.B0 ) {
 hum01 = hum01 / 100;
 digit01 = hum01 / 10;
 digit02 = hum01 % 10;
 lcd_out(2, 1, "Umidade Ar:");
 lcd_chr(2, 14, digit01 + 48);
 lcd_chr_cp(digit02 + 48);
 }

 else {
 digit01 = hum02 / 100;
 digit02 = hum02 / 10 - digit01 * 10;
 digit03 = hum02 % 10;
 lcd_out(2, 1, "Umid. Solo:");
 lcd_chr(2,13, digit01 + 48);
 lcd_chr_cp(digit02 + 48);
 lcd_chr_cp(digit03 + 48);
 }
}

void turnOnWaterPump(unsigned short status) {
 if(status == 1) {
 PWM1_Start();
 PWM1_Set_Duty(100);
  LATD0_bit  = 0x01;
 }
 else {
 PWM1_Stop();
  LATD0_bit  = 0x00;
 }
}



void exhaustFan(unsigned int temperature, float threshold) {
 if(temperature > threshold * 100) {
 if(pwm2Duty < 254) pwm2Duty++;
 PWM2_Start();
 PWM2_Set_Duty(pwm2Duty);
 }
 else {
 if (pwm2Duty > 80)pwm2Duty--;
 PWM2_Set_Duty(pwm2Duty);
 if(pwm2Duty <= 80) PWM2_Stop();
 }
}
