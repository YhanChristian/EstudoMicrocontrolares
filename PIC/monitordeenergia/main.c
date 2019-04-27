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

// -- SD Card Chip Select

sfr sbit Mmc_Chip_Select at RC6_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC6_bit;

// -- Protótipo de funções Auxiliares --
void configureMcu();
void initDisplay();
void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]);
unsigned int calcPower(unsigned short current, int voltage);
int readCurrent(unsigned short sensor);
int readVoltage(unsigned short circuit);

// -- Protótipo de funções externas --
extern void startSDCard();
extern void writeFileSDCard(unsigned short current[4], int voltage[4], unsigned int activePower[4]);

// -- Variáveis Globais --

unsigned short SDCardOK = 0;

// -- Setup MCU --

void configureMcu() {
     CMCON = 0x07;   // Desabilita comparadores
     ADCON1 = 0x07;  // Configuração ADC AN0 - AN7  pg. 266 datasheet
     ADCON2 = 0x38;
}


// -- Função Main --

void main(){
// - Variáveis Locais --

    unsigned short current[4] = {0, 0, 0, 0}, i;
    int voltage[4] = {0, 0, 0, 0};
    unsigned int activePower[4] = {0, 0, 0, 0};
    configureMcu();
    initDisplay();
    startSDCard();
    while(1){
        current[0] = readCurrent(1);
        current[1] = readCurrent(2);
        current[2] = readCurrent(3);
        current[3] = readCurrent(4);
        voltage[0] = readVoltage(1);
        voltage[1] = readVoltage(2);
        voltage[2] = readVoltage(3);
        voltage[3] = readVoltage(4);
        for (i = 0; i < 4; i++) activePower[i] = calcPower(current[i], voltage[i]);
        showDisplay(current, voltage, activePower);
        delay_ms(1000);
        writeFileSDCard(current, voltage, activePower);
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
          LCD_chr(i + 1, 12,'A');
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

// -- Leitura da corrente dos sensores TC --

int readCurrent(unsigned short sensor) {
    int time[2] = {0, 1024};
    int value = 0, relativeVoltage, readCurrentAmp;
    unsigned int i;
    for(i = 0; i < 254; i++) {
        value = ADC_Read(sensor - 1);
        if(time[0] < value) time[0] = value; // Obtem onda senoidal valores máximos
        if(time[1] > value) time[1] = value;
    }
    relativeVoltage = (time[0] - time[1]) * 0.13808; // Converte valor lido em mV
    readCurrentAmp = relativeVoltage * 0.707; // converte valor para RMS
    readCurrentAmp = readCurrentAmp * 2; //multipla valor para obter corrente lida
    
    if(readCurrentAmp < 0) readCurrentAmp = -readCurrentAmp;
    if(readCurrentAmp > 100) readCurrentAmp = 100;
    
    return readCurrentAmp;
}

int readVoltage(unsigned short circuit) {
     int tempValue = 0, pcm = 254;
     unsigned short i;
     float voltageAC = 0, conversion[2] = { 2.48, 220 }; // equivalencia entre circuito AC e saída opto acoplador
     
     for(i = 0; i < 254; i++) {
           pcm = ADC_Read(circuit + 3);
           if(pcm > tempValue) pcm = tempValue;
     }
     
     voltageAC =  tempValue * 0.0048828125;  //converte de PCM para tensão (até 5V --> 5/1024)
     voltageAC = voltageAC *(conversion[1] / conversion[0]);
     
     return voltageAC;
}