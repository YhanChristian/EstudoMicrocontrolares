/*
  Projeto: Gerenciamento de N tarefas
  Utilizado: PIC18F4550
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=SXZIC92f7zw&list=PLZ8dBTV2_5HQO03YC3RsgYvhwA375Ou79&index=17
*/

// -- Definiões de hardware --

#define output01 LATB0_bit
#define output02 LATB1_bit
#define motor LATB3_bit
#define button RB5_bit

// -- Prototipo com funções auxiliares --

void configureMcu();
void checkT0();
void baseTime();
void checkT1();
void readButton();


// -- Variáveis Globais --

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

// -- Funções Auxiliares --

void configureMcu() {
     ADCON1 = 0x01; // Todas IOs digitais
     TRISB = 0xF0;  //Configura de RB0 à RB3 como saída
     LATB = 0xF0;  //Inicializa o LATB
     TMR0H = 0x3C;   // Carrega registradores com valor 15536
     TMR0L = 0xB0;
     T0CON = 0x82; // Timer 0,  16 bits, prescaler 1:8
     TMR1H = 0x3C;  // Carrega registradores com valor 15536
     TMR1L = 0xB0;
     T1CON = 0xF1; // Timer 1,  16 bits, prescaler 1:8
     flagButton = 0x00;
}
// -- Checa Timer 0  e incrementa base tempo t1 e t2 --
void checkT0() {
     if(TMR0IF_bit) {
         TMR0IF_bit = 0x00;
         TMR0H = 0x3C;
         TMR0L = 0xB0;
         baseT1++;
         baseT2++;
         // -- Base de tempo de 100ms --
         baseTime();
     }
}
// -- Função para criar base de tempo t1 e t2 --
void baseTime() {
// -- A cada 200ms inverte saída 01 --
     if(baseT1 == 2) {
         baseT1 = 0;
         output01 = ~output01;
     }
// -- A cada 1s inverte saída 02 --
     if(baseT2 == 10) {
         baseT2 = 0;
         output02 = ~output02;
     }
}
// -- Função para checar Timer1 e criar base de tempo p/ manter acionado motor
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
                  motor = 0x00;
             }
         }
     }
}
// -- Função para leitura de botão utilizando resistor de PULL-UP  --
void readButton() {
     if(!button) flagButton = 0x01;
     if(button && flagButton) {
         flagButton = 0x00;
         motor = 0x01;
         motorControl = 0x00;
     }
}