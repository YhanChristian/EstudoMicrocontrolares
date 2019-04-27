#line 1 "C:/Users/yhanc/Documents/EstudoMicrocontrolares/PIC/monitordeenergia/SDCard.c"
#line 10 "C:/Users/yhanc/Documents/EstudoMicrocontrolares/PIC/monitordeenergia/SDCard.c"
extern unsigned short SDCardOK;



char filename[] = "dataloggerxx.csv";



void startSDCard();
void writeFileSDCard(unsigned short current[4], int voltage[4], unsigned int activePower[4]);


void startSDCard() {
 unsigned short i;

 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 SDCardOK = MMc_Fat_Init();
 LCD_Out(1, 1, "Start SDCard");
 while(SDCardOK != 0) {
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 SDCardOK = MMc_Fat_Init();
 }

 LCD_Out(1, 1, "Verify file name");
 for(i = 0; i < 100; i++) {
 filename[10] = (i / 10) + 48;
 filename[11] = (i / 10) + 48;
 if(Mmc_Fat_Assign(&filename, 0) == 0) break;
 else MMC_Fat_Close();
 }
}

void writeFileSDCard(unsigned short current[4], int voltage[4], unsigned int activePower[4]) {
 char dataToWrite[56];
 unsigned short i;


 Mmc_Fat_Assign(&filename, 0xA0);



 dataToWrite[0] = voltage[0] / 100;
 dataToWrite[1] = voltage[0] / 10 - (dataToWrite[0]) * 10;
 dataToWrite[2] = voltage[0] % 10;

 dataToWrite[4] = voltage[1] / 100;
 dataToWrite[5] = voltage[1] / 10 - (dataToWrite[4]) * 10;
 dataToWrite[6] = voltage[1] % 10;

 dataToWrite[8] = voltage[2] / 100;
 dataToWrite[9] = voltage[2] / 10 - (dataToWrite[8]) * 10;
 dataToWrite[10] = voltage[2] % 10;

 dataToWrite[12] = voltage[3] / 100;
 dataToWrite[13] = voltage[3] / 10 - (dataToWrite[12]) * 10;
 dataToWrite[14] = voltage[3] % 10;

 dataToWrite[16] = current[0] / 100;
 dataToWrite[17] = current[0] / 10 - (dataToWrite[16]) * 10;
 dataToWrite[18] = current[0] % 10;

 dataToWrite[20] = current[1] / 100;
 dataToWrite[21] = current[1] / 10 - (dataToWrite[20]) * 10;
 dataToWrite[22] = current[1] % 10;

 dataToWrite[24] = current[2] / 100;
 dataToWrite[25] = current[2] / 10 - (dataToWrite[24]) * 10;
 dataToWrite[26] = current[2] % 10;

 dataToWrite[28] = current[3] / 100;
 dataToWrite[29] = current[3] / 10 - (dataToWrite[28]) * 10;
 dataToWrite[30] = current[3] % 10;

 dataToWrite[32] = activePower[0] / 10000;
 dataToWrite[33] = activePower[0] / 1000 - (dataToWrite[32]) * 10;
 dataToWrite[34] = activePower[0] / 100 - ((dataToWrite[32]) * 100 + (dataToWrite[33]) * 10);
 dataToWrite[35] = activePower[0] / 10 - ((dataToWrite[32]) * 1000 + (dataToWrite[33]) * 1000 + (dataToWrite[34]) * 10);
 dataToWrite[36] = activePower[0] % 10;

 dataToWrite[38] = activePower[1] / 10000;
 dataToWrite[39] = activePower[1] / 1000 - (dataToWrite[38]) * 10;
 dataToWrite[40] = activePower[1] / 100 - ((dataToWrite[38]) * 100 + (dataToWrite[39]) * 10);
 dataToWrite[41] = activePower[1] / 10 - ((dataToWrite[38]) * 1000 + (dataToWrite[39]) * 1000 + (dataToWrite[40]) * 10);
 dataToWrite[42] = activePower[1] % 10;

 dataToWrite[44] = activePower[2] / 10000;
 dataToWrite[45] = activePower[2] / 1000 - (dataToWrite[44]) * 10;
 dataToWrite[46] = activePower[2] / 100 - ((dataToWrite[44]) * 100 + (dataToWrite[45]) * 10);
 dataToWrite[47] = activePower[2] / 10 - ((dataToWrite[44]) * 1000 + (dataToWrite[45]) * 1000 + (dataToWrite[46]) * 10);
 dataToWrite[48] = activePower[2] % 10;

 dataToWrite[50] = activePower[3] / 10000;
 dataToWrite[51] = activePower[3] / 1000 - (dataToWrite[50]) * 10;
 dataToWrite[52] = activePower[3] / 100 - ((dataToWrite[50]) * 100 + (dataToWrite[51]) * 10);
 dataToWrite[53] = activePower[3] / 10 - ((dataToWrite[50]) * 1000 + (dataToWrite[51]) * 1000 + (dataToWrite[52]) * 10);
 dataToWrite[54] = activePower[3] % 10;



 for(i = 0; i < 55; i++) dataToWrite[i] = dataToWrite[i] + 48;

 dataToWrite[3] = ';';
 dataToWrite[7] = ';';
 dataToWrite[11] = ';';
 dataToWrite[15] = ';';
 dataToWrite[19] = ';';
 dataToWrite[23] = ';';
 dataToWrite[27] = ';';
 dataToWrite[31] = ';';
 dataToWrite[37] = ';';
 dataToWrite[43] = ';';
 dataToWrite[49] = ';';
 dataToWrite[55] = '\r\n';



 Mmc_Fat_Append();
 Mmc_Fat_Write(dataToWrite, 56);
 MMC_Fat_Close();
}
