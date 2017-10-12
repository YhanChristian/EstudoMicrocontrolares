#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/dht11.c"
#line 7 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/dht11.c"
sbit dhtData at RB2_bit;
sbit dhtData_Direction at TRISB2_bit;

unsigned short myData1;










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
 };
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


 for (byte=0; byte <= 3; byte++){
 i=1;
 for (i=1; i<=8;i++){
 while(!dhtData);
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
  myData1.F0  = result;
 break;
 case 7:
  myData1.F1  = result;
 break;
 case 6:
  myData1.F2  = result;
 break;
 case 5:
  myData1.F3  = result;
 break;
 case 4:
  myData1.F4  = result;
 break;
 case 3:
  myData1.F5  = result;
 break;
 case 2:
  myData1.F6  = result;
 break;
 case 1:
  myData1.F7  = result;
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
