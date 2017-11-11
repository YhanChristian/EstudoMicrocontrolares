/*
  Projeto: timer com interface IHM progrmável
  Utilizado: PIC16F628A
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=Nn6nwPWSO_A&index=7&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

// -- Definição de hardware --
#define oneSecond PORTB.F0

// -- Protótipo de funções Auxiliares --
void configureMcu();

// -- Variáveis globais --
unsigned short flags;
#define tmr02Trigger flags.B0
short pr2Value = 255;
int tmr02Counter = 0;



//-- Interrupção p/ geração de tempo de 1s --

void interrupt() {
     if(TMR2IF_bit) {
          TMR2IF_bit = 0x00;
          tmr02Trigger = ~tmr02Trigger;
          if(tmr02Trigger) {
               tmr02Counter++;
               if(tmr02Counter == 490) {
                    oneSecond = ~oneSecond;
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
     CMCON = 0x07;       // Desabilita comparadores
     TRISB0_bit = 0x00;    // RB0 como saída
     INTCON.GIE = 0x01;  // Habilita interrupção global
     INTCON.PEIE = 0x01; // Habilita interrupção de periféricos
     TMR2IE_bit = 0X01;  // Habilita interrupção do TMR2
     T2CON = 0x01;       // Config TMR2 Postscaler 1 Prescaler 4, timer desabilitado
     PR2 =  pr2Value;    // Atribui a PR2 o valor da variavel pr2Value
}


