unsigned short bcdData(unsigned short digit){
     unsigned short returnData;

// -- Inverte-se o envio dos bits, pois envia-se o nibble mais significativo em
// -- seguida o menos significativo --

     switch(digit) {
         case 0:                       //abcdefg
              returnData = 0b0111111;// 1111110;
         break;

         case 1:
              returnData = 0b0000110;// 0110000;
         break;
              
         case 2:
              returnData = 0b1011011;// 1101101;
         break;

         case 3:
              returnData = 0b1001111;// 1111001;
         break;

         case 4:
              returnData = 0b1100110; //0110011;
         break;

         case 5:
              returnData = 0b1101101;//1011011;
         break;

         case 6:
              returnData = 0b1111101;//1011111;
         break;

         case 7:
              returnData = 0b0000111;//1110000;
         break;
              
         case 8:
              returnData = 0b1111111;//1111111;
         break;
              
         case 9:
              returnData = 0b1101111;//1111011;
         break;
     }
    return ~returnData;
}