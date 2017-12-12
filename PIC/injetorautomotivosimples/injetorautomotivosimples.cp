#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/injetorautomotivosimples/injetorautomotivosimples.c"
#line 20 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/injetorautomotivosimples/injetorautomotivosimples.c"
void configureMcu();
void checkT0();
void baseTime();
void checkT1();
void checkT2();
void readButton();




unsigned baseT1 = 0, baseT2 = 0, motorControl = 6, baseTMR01 = 0;
unsigned short pr2Load = 125;
short incRpm01 = 0, incRpm02 = 0, incRpm03 = 0;
bit flagButton;

void main() {
 configureMcu();
 while(1) {
 checkT0();
 checkT1();
 checkT2();
 readButton();
 }
}



void configureMcu() {
 ADCON1 = 0x01;
 TRISB = 0x24;
 LATB = 0xE4;
 TMR0H = 0x3C;
 TMR0L = 0xB0;
 T0CON = 0x82;
 TMR1H = 0x3C;
 TMR1L = 0xB0;
 T1CON = 0xF1;
 T2CON = 0x7C;
 PR2 = pr2Load;
 flagButton = 0x00;
}

void checkT0() {
 if(TMR0IF_bit) {
 TMR0IF_bit = 0x00;
 TMR0H = 0x3C;
 TMR0L = 0xB0;
 baseT1++;
 baseT2++;

 baseTime();
 }
}

void baseTime() {

 if(baseT1 == 2) {
 baseT1 = 0;
  LATB0_bit  = ~ LATB0_bit ;
 }

 if(baseT2 == 10) {
 baseT2 = 0;
  LATB1_bit  = ~ LATB1_bit ;
 }
}

void checkT1() {
 if(TMR1IF_bit) {
 TMR1IF_bit = 0x00;
 TMR1H = 0x3C;
 TMR1L = 0xB0;
 baseTMR01++;
 if(baseTMR01 == 10) {
 baseTMR01 = 0;
 motorControl++;
 if(motorControl == 5) {
 motorControl = 6;
  LATB3_bit  = 0x00;
 }
 }
 }
}


void checkT2() {
 if(TMR2IF_bit) {
 TMR2IF_bit = 0x00;
 incRpm01++;
 incRpm02++;
 incRpm03++;


 if(incRpm01 < 116)  LATB4_bit  = ~ LATB4_bit ;
 else  LATB4_bit  = 0x00;
 if(incRpm01 == 120) incRpm01 = 0;


 if(incRpm02 < 70)  LATB6_bit  = ~ LATB6_bit ;
 else  LATB6_bit  = 0x00;
 if(incRpm02 == 72) incRpm02 = 0;


 if(incRpm03 < 14)  LATB7_bit  = ~ LATB7_bit ;
 else  LATB7_bit  = 0x00;
 if(incRpm03 == 16) incRpm03 = 0;

 }
}


void readButton() {
 if(! RB5_bit ) flagButton = 0x01;
 if( RB5_bit  && flagButton) {
 flagButton = 0x00;
  LATB3_bit  = 0x01;
 motorControl = 0x00;
 }
}
