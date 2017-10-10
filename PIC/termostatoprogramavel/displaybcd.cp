#line 1 "C:/Users/Yhan Christian/Documents/EstudoMicrocontrolares/PIC/termostatoprogramavel/displaybcd.c"
unsigned short bcdData(unsigned short digit){
 unsigned short returnData;




 switch(digit) {
 case 0:
 returnData = 0b0111111;
 break;

 case 1:
 returnData = 0b0000110;
 break;

 case 2:
 returnData = 0b1011011;
 break;

 case 3:
 returnData = 0b1001111;
 break;

 case 4:
 returnData = 0b1100110;
 break;

 case 5:
 returnData = 0b1101101;
 break;

 case 6:
 returnData = 0b1111101;
 break;

 case 7:
 returnData = 0b0000111;
 break;

 case 8:
 returnData = 0b1111111;
 break;

 case 9:
 returnData = 0b1101111;
 break;
 }
 return ~returnData;
}
