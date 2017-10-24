#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/gerenciamentoNTarefas/gerenciamentoNTarefas.c"
#line 17 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/gerenciamentoNTarefas/gerenciamentoNTarefas.c"
void configureMcu();
void checkT0();
void baseTime();
void checkT1();
void readButton();




unsigned baseT1 = 0, baseT2 = 0, motorControl = 6, baseTMR01 = 0;
bit flagButton;

void main() {
 configureMcu();
 while(1) {
 readButton();
 checkT0();
 checkT1();
 }
}



void configureMcu() {
 ADCON1 = 0x01;
 TRISB = 0xF0;
 LATB = 0xF0;
 TMR0H = 0x3C;
 TMR0L = 0xB0;
 T0CON = 0x82;
 TMR1H = 0x3C;
 TMR1L = 0xB0;
 T1CON = 0xF1;
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

void readButton() {
 if(! LATB5_bit ) flagButton = 0x01;
 if( LATB5_bit  && flagButton) {
 flagButton = 0x00;
  LATB3_bit  = 0x01;
 motorControl = 0x00;
 }
}
