#line 1 "C:/Users/yhanc/Documents/EstudoMicrocontrolares/PIC/monitordeenergia/main.c"
#line 9 "C:/Users/yhanc/Documents/EstudoMicrocontrolares/PIC/monitordeenergia/main.c"
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
int readCurrent(unsigned short value);




void configureMcu() {
 CMCON = 0x07;
 ADCON1 = 0x0B;
 ADCON2 = 0x38;
}




void main(){


 unsigned short current[4] = {123,210,132,213}, i;
 int voltage[4] = {220,220,220,220};
 unsigned int activePower[4] = {0,0,0,0};
 configureMcu();
 initDisplay();
 while(1){
#line 56 "C:/Users/yhanc/Documents/EstudoMicrocontrolares/PIC/monitordeenergia/main.c"
 for (i=0; i<4; i++) activePower[i] = calcPower(current[i],voltage[i]);
 showDisplay(current, voltage, activePower);
 }
}






void initDisplay() {
 LCD_INIT();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Cmd(_LCD_CLEAR);
}



void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]){
 unsigned short i;
 char digit[5];


 for (i = 0; i < 4; i++){
 LCD_chr(i + 1, 1, 'C');
 LCD_chr(i + 1, 2, i + 1 + 48);
 digit[0] = voltage[i] / 100;
 digit[1] = voltage[i] / 10 - (digit[0]) * 10;
 digit[2] = voltage[i] % 10;
 LCD_chr(i + 1, 4,digit[0] + 48);
 LCD_chr(i + 1, 5,digit[1] + 48);
 LCD_chr(i + 1, 6,digit[2] + 48);
 LCD_chr(i + 1, 7,'V');
 }


 for (i = 0; i < 4; i++){
 LCD_chr(i + 1, 1, 'C');
 LCD_chr(i + 1, 2, i + 1 + 48);
 digit[0] = current[i] / 100;
 digit[1] = current[i] / 10 - (digit[0]) * 10;
 digit[2] = current[i] % 10;
 LCD_chr(i + 1, 9,digit[0] + 48);
 LCD_chr(i + 1, 10,digit[1] + 48);
 LCD_chr(i + 1, 11,digit[2] + 48);
 LCD_chr(i + 1, 12,'V');
 }


 for (i = 0; i < 4; i++){
 LCD_chr(i + 1, 1, 'C');
 LCD_chr(i + 1, 2, i + 1 + 48);
 digit[0] = activePower[i] / 10000;
 digit[1] = activePower[i] / 1000 - (digit[0]) * 10;
 digit[2] = activePower[i] / 100 - ((digit[0]) * 100 + (digit[1]) * 10);
 digit[3] = activePower[i] / 10 - ((digit[0]) * 1000 + (digit[1]) * 100 + (digit[2]) * 10);
 digit[4] = activePower[i] % 10;
 LCD_chr(i + 1, 14,digit[0] + 48);
 LCD_chr(i + 1, 15,digit[1] + 48);
 LCD_chr(i + 1, 16,digit[2] + 48);
 LCD_chr(i + 1, 17,digit[3] + 48);
 LCD_chr(i + 1, 18,digit[4] + 48);
 LCD_chr(i + 1, 19,'W');
 }
}



unsigned int calcPower(unsigned short current, int voltage){
 unsigned int activePower;
 activePower = current * voltage;
 return activePower;
}
