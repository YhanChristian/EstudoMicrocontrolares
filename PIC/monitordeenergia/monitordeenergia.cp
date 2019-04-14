#line 1 "C:/Users/yhanc/Documents/EstudoMicrocontrolares/PIC/monitordeenergia/monitordeenergia.c"
#line 9 "C:/Users/yhanc/Documents/EstudoMicrocontrolares/PIC/monitordeenergia/monitordeenergia.c"
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
void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]);
unsigned int calcPower(unsigned short current, int voltage);

void main() {
 configureMcu();
 initDisplay();
}

void configureMcu() {
 CMCON = 0x07;
 ADCON1 = 0x0E;
}

void initDisplay() {
 Lcd_Init();
 Lcd_Cmd(LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
}

void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]) {

}


unsigned int calcPower(unsigned short current, int voltage) {
 unsigned int activePower;
 activePower = current * voltage;
 return activePower;
}
