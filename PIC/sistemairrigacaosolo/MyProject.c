/*
  Projeto: Sistema de Igirracao do Solo
  Utilizado: PIC18F4550
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=n-jxNHvd5WY&index=11&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ
*/

// -- Definicao de Hardware --

#define output LATD0_bit

// -- Prototipo funcoes auxiliares --

void configureMcu();

void main() {
     configureMcu();
     
     while(1) {
          output = ~output;
     }
}

void configureMcu() {
     CMCON = 0x07; //Desabilita comparadores
     ADCON1 = 0x0F; //Desabilita portas analogicas
     LATD0_bit = 0x00; //Define pino D0 como saida digital
}

