/*
  Projeto:  Monitor de Energia c/ Sensor TC e PIC
  Utilizado: PIC18F4550
  Autor: Yhan Christian Souza Silva
  Referências: https://www.youtube.com/watch?v=Xs-ULkhnGf0&list=PLZ8dBTV2_5HS_YaI8C4hsTzehRSgPjuxQ&index=19
*/

// -- Conexões LCD --
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

// -- Direção pino io --
sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;

// -- Protótipo de funções Auxiliares --
void configureMcu();
void initDisplay();
void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]);
unsigned int calcPower(unsigned short current, int voltage);
int readCurrent(unsigned short value);


// -- Setup MCU --

void configureMcu() {
     CMCON = 0x07;   // Desabilita comparadores
     ADCON1 = 0x0B;  // Configuração ADC pg. 266
     ADCON2 = 0x38;
}


// -- Função Main --

void main(){
// - Variáveis Locais --

    unsigned short current[4] = {123,210,132,213}, i;
    int voltage[4] = {220,220,220,220};
    unsigned int activePower[4] = {0,0,0,0};
    configureMcu();
    initDisplay();
    while(1){
            /* corrente[0] = LeCorrente(1);
             corrente[1] = LeCorrente(2);
             corrente[2] = LeCorrente(3);
             corrente[3] = LeCorrente(4);         */
             for (i=0; i<4; i++) activePower[i] = calcPower(current[i],voltage[i]);
             showDisplay(current, voltage, activePower);
    }
}




// -- Inicializa o Display

void initDisplay() {
     LCD_INIT();
     Lcd_Cmd(_LCD_CURSOR_OFF);
     Lcd_Cmd(_LCD_CLEAR);
}

// -- Plota dados tela display 20 x 4

void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]){
     unsigned short  i;
     char digit[5];

     // -- Tensão --
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

     // -- Corrente --
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

     // -- Potência --
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

// -- Calcula potência --

unsigned int calcPower(unsigned short current, int voltage){
    unsigned int activePower;
    activePower = current * voltage;
    return activePower;
}

/* int LeCorrente(unsigned short nIn){
     int TEMP[2] = {0,0};
     int PCMVal = 0,
         RelVolt = 0,
         Ampere = 0;
     unsigned short iterations = 254,
                    i;

  //Leitura de corrente da entrada
  //TRISC.B2 = 0;

                             //nout+InSelectADJ1
          TEMP[0] =0;
          TEMP[1] = 1024;
          for ( i = 0; i < iterations; i++ ){
              //PORTC.B2=!PORTC.B2;
              PCMVal = ADC_Read(nIn-1);              //numero da saida começa em 1 - primeira saida ANA utilizada é 5
                if ( TEMP[0] < PCMVal ){
                   //Obtem maximo (para sinal senoidal/AC)
                    TEMP[0] = PCMVal;
                }
                if ( TEMP[1] > PCMVal ){
                   //Obtem maximo (para sinal senoidal/AC)
                    TEMP[1] = PCMVal;
                }
          }
                   //Calcula a amplitude e converte para corrente (de pico - 141,4 A)
          RelVolt =  (TEMP[0]-TEMP[1])*0.13808;           // Converte PCM para mV

         Ampere = RelVolt*0.707; //COnverte para valor RMS
         Ampere = Ampere*2;

          if (Ampere < 0 ){
               Ampere = -Ampere;
          }

          if (Ampere > 100){
             Ampere = 100;
          }

          return Ampere;
}
*/

