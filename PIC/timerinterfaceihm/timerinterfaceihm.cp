#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/timerinterfaceihm/timerinterfaceihm.c"
#line 12 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/timerinterfaceihm/timerinterfaceihm.c"
void configureMcu();


unsigned short flags;

short pr2Value = 255;
int tmr02Counter = 0;





void interrupt() {
 if(TMR2IF_bit) {
 TMR2IF_bit = 0x00;
  flags.B0  = ~ flags.B0 ;
 if( flags.B0 ) {
 tmr02Counter++;
 if(tmr02Counter == 490) {
  PORTB.F0  = ~ PORTB.F0 ;
 tmr02Counter = 0;
 }
 }
 }

}

void main() {
 configureMcu();
 while(1) {
 TMR2ON_bit = 0x01;
 }
}

void configureMcu() {
 CMCON = 0x07;
 TRISB0_bit = 0x00;
 INTCON.GIE = 0x01;
 INTCON.PEIE = 0x01;
 TMR2IE_bit = 0X01;
 T2CON = 0x01;
 PR2 = pr2Value;
}
