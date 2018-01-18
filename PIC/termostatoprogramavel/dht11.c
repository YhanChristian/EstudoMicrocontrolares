/*
  Biblioteca DHT11 Desenvolvida por Josias Martins Bobsien P&D
  Utilizado: PIC16F628A - 8MHz
  Alterações realizadas por Yhan Christian Souza Silva
*/

sbit dhtData at RB2_bit;
sbit dhtData_Direction at TRISB2_bit;

unsigned short myData1;

#define D0B0 myData1.F0
#define D0B1 myData1.F1
#define D0B2 myData1.F2
#define D0B3 myData1.F3
#define D0B4 myData1.F4
#define D0B5 myData1.F5
#define D0B6 myData1.F6
#define D0B7 myData1.F7

int sendDhtData[4];

void initDht11(){
   dhtData_Direction = 0;
   dhtData = 1;
   delay_ms(1000);

}

unsigned short startDht11(){
   unsigned short time = 0;
   dhtData = 0;
   delay_ms(18);
   dhtData = 1;
   dhtData_Direction = 1;
   time = 0;
   while (dhtData && time <= 40){
        time++;
        delay_us(1);
   }
   time = 0;
   while (!dhtData && time <= 80){
          time++;
          delay_us(1);
   }
   time = 0;
   while (dhtData && time <= 80){
          time++;
          delay_us(1);
   }
}

int dht11(unsigned short type){
      int time = 0;
      unsigned short result = 0, i = 0, byte;
      startDht11();
      dhtData_Direction = 1;
      byte = 0;
      
      // -- Obtem os 4 bytes de dados --
      for (byte=0; byte <= 3; byte++){
          i=1;
          for (i=1; i<=8;i++){
            while(!dhtData); //Aguarda proxima borda de subida
            result = 0;
            time = 0;
            while (dhtData){
                   time++;
                   if (time >= 2 && !result ){
                       result = 1;
                  }
            }
            switch (i) {
              case 8:
                D0B0 = result;
                break;
              case 7:
                D0B1 = result;
                break;
              case 6:
                D0B2 = result;
                break;
              case 5:
                D0B3 = result;
                break;
              case 4:
                D0B4 = result;
                break;
              case 3:
                D0B5 = result;
                break;
              case 2:
                D0B6 = result;
                break;
              case 1:
                D0B7 = result;
                break;
              }
            }
        sendDhtData[byte] = myData1;
        }

      dhtData_Direction = 0;
      dhtData = 1;
      if (type == 1 ){
            return sendDhtData[0] * 100 + sendDhtData[1];
      }
      if (type == 2 ){
            return sendDhtData[2] * 100 + sendDhtData[3];
      }
}
