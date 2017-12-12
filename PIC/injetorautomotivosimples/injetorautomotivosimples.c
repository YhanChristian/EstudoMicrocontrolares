/*
  Projeto: Injetor Automotivo Simples
  Utilizado: PIC18F4550
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=BqfRvGqOTyY&list=PLZ8dBTV2_5HQO03YC3RsgYvhwA375Ou79&index=21
*/

// -- Definiões de hardware --

#define output01 LATB0_bit
#define output02 LATB1_bit
#define motor LATB3_bit
#define rpm01Output LATB4_bit
#define button RB5_bit
#define rpm02Output   LATB6_bit
#define rpm03Output   LATB7_bit

// -- Prototipo com funções auxiliares --

void configureMcu();
void checkT0();
void baseTime();
void checkT1();
void checkT2();
void readButton();


// -- Variáveis Globais --

unsigned baseT1 = 0, baseT2 = 0, motorControl = 6, baseTMR01 = 0;
unsigned short pr2Load = 125; // Valor carregado em PR2 para comparação do TMR2
short incRpm01 = 0, incRpm02 = 0, incRpm03 = 0; //Auxiliar temporização no TMR2 (RPM)
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

// -- Funções Auxiliares --

void configureMcu() {
     ADCON1 = 0x01; // Todas IOs digitais
     TRISB = 0x24;  //Configura PortB definindo entradas e saídas
     LATB = 0xE4;  //Inicializa o LATB
     TMR0H = 0x3C;   // Carrega registradores com valor 15536
     TMR0L = 0xB0;
     T0CON = 0x82; // Timer 0,  16 bits, prescaler 1:8
     TMR1H = 0x3C;  // Carrega registradores com valor 15536
     TMR1L = 0xB0;
     T1CON = 0xF1; // Timer 1,  16 bits, prescaler 1:8
     T2CON = 0x7C; // Timer 2, 8 bits, postscaler 1:16
     PR2 = pr2Load; // Carrega em PR2 valor de pr2Load
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

// -- Função para geração de pulsos RPM através do estouro do TMR2 --
void checkT2() {
     if(TMR2IF_bit) {
         TMR2IF_bit = 0x00;
         incRpm01++;
         incRpm02++;
         incRpm03++;
         
         // -- Gera Sinal Rpm 60-2
         if(incRpm01 < 116) rpm01Output = ~rpm01Output;
         else rpm01Output = 0x00;
         if(incRpm01 == 120) incRpm01 = 0;
        
         // -- Gera Sinal Rpm 36-1
         if(incRpm02 < 70) rpm02Output = ~rpm02Output;
         else rpm02Output = 0x00;
         if(incRpm02 == 72) incRpm02 = 0;
         
         // -- Gera Sinal Rpm 8-1
         if(incRpm03 < 14) rpm03Output = ~rpm03Output;
         else rpm03Output = 0x00;
         if(incRpm03 == 16) incRpm03 = 0;

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