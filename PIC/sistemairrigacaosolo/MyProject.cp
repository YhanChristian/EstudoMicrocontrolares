#line 1 "Z:/home/yhanchristian/Documents/EstudoMicrocontrolares/PIC/sistemairrigacaosolo/MyProject.c"
#line 14 "Z:/home/yhanchristian/Documents/EstudoMicrocontrolares/PIC/sistemairrigacaosolo/MyProject.c"
void configureMcu();

void main() {
 configureMcu();

 while(1) {
  LATD0_bit  = ~ LATD0_bit ;
 }
}

void configureMcu() {
 CMCON = 0x07;
 ADCON1 = 0x0F;
 LATD0_bit = 0x00;
}
