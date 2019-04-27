
_startSDCard:

;SDCard.c,22 :: 		void startSDCard() {
;SDCard.c,25 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;SDCard.c,26 :: 		SDCardOK = MMc_Fat_Init();
	CALL        _Mmc_Fat_Init+0, 0
	MOVF        R0, 0 
	MOVWF       _SDCardOK+0 
;SDCard.c,27 :: 		LCD_Out(1, 1, "Start SDCard");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_SDCard+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_SDCard+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SDCard.c,28 :: 		while(SDCardOK != 0) {
L_startSDCard0:
	MOVF        _SDCardOK+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_startSDCard1
;SDCard.c,29 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;SDCard.c,30 :: 		SDCardOK = MMc_Fat_Init();
	CALL        _Mmc_Fat_Init+0, 0
	MOVF        R0, 0 
	MOVWF       _SDCardOK+0 
;SDCard.c,31 :: 		}
	GOTO        L_startSDCard0
L_startSDCard1:
;SDCard.c,33 :: 		LCD_Out(1, 1, "Verify file name");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_SDCard+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_SDCard+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SDCard.c,34 :: 		for(i = 0; i < 100; i++) {
	CLRF        startSDCard_i_L0+0 
L_startSDCard2:
	MOVLW       100
	SUBWF       startSDCard_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_startSDCard3
;SDCard.c,35 :: 		filename[10] = (i / 10) + 48;
	MOVLW       10
	MOVWF       R4 
	MOVF        startSDCard_i_L0+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVLW       48
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       _filename+10 
;SDCard.c,36 :: 		filename[11] = (i / 10) + 48;
	MOVF        R0, 0 
	MOVWF       _filename+11 
;SDCard.c,37 :: 		if(Mmc_Fat_Assign(&filename, 0) == 0) break;
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	CLRF        FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_startSDCard5
	GOTO        L_startSDCard3
L_startSDCard5:
;SDCard.c,38 :: 		else MMC_Fat_Close();
	CALL        _Mmc_Fat_Close+0, 0
;SDCard.c,34 :: 		for(i = 0; i < 100; i++) {
	INCF        startSDCard_i_L0+0, 1 
;SDCard.c,39 :: 		}
	GOTO        L_startSDCard2
L_startSDCard3:
;SDCard.c,40 :: 		}
L_end_startSDCard:
	RETURN      0
; end of _startSDCard

_writeFileSDCard:

;SDCard.c,42 :: 		void writeFileSDCard(unsigned short current[4], int voltage[4], unsigned int activePower[4]) {
;SDCard.c,47 :: 		Mmc_Fat_Assign(&filename, 0xA0);
	MOVLW       _filename+0
	MOVWF       FARG_Mmc_Fat_Assign_name+0 
	MOVLW       hi_addr(_filename+0)
	MOVWF       FARG_Mmc_Fat_Assign_name+1 
	MOVLW       160
	MOVWF       FARG_Mmc_Fat_Assign_attrib+0 
	CALL        _Mmc_Fat_Assign+0, 0
;SDCard.c,51 :: 		dataToWrite[0] = voltage[0] / 100;
	MOVFF       FARG_writeFileSDCard_voltage+0, FSR0
	MOVFF       FARG_writeFileSDCard_voltage+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+0 
;SDCard.c,52 :: 		dataToWrite[1] = voltage[0] / 10 - (dataToWrite[0]) * 10;
	MOVFF       FARG_writeFileSDCard_voltage+0, FSR0
	MOVFF       FARG_writeFileSDCard_voltage+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+1 
;SDCard.c,53 :: 		dataToWrite[2] = voltage[0] % 10;
	MOVFF       FARG_writeFileSDCard_voltage+0, FSR0
	MOVFF       FARG_writeFileSDCard_voltage+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+2 
;SDCard.c,55 :: 		dataToWrite[4] = voltage[1] / 100;
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+4 
;SDCard.c,56 :: 		dataToWrite[5] = voltage[1] / 10 - (dataToWrite[4]) * 10;
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+5 
;SDCard.c,57 :: 		dataToWrite[6] = voltage[1] % 10;
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+6 
;SDCard.c,59 :: 		dataToWrite[8] = voltage[2] / 100;
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+8 
;SDCard.c,60 :: 		dataToWrite[9] = voltage[2] / 10 - (dataToWrite[8]) * 10;
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+9 
;SDCard.c,61 :: 		dataToWrite[10] = voltage[2] % 10;
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+10 
;SDCard.c,63 :: 		dataToWrite[12] = voltage[3] / 100;
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+12 
;SDCard.c,64 :: 		dataToWrite[13] = voltage[3] / 10 - (dataToWrite[12]) * 10;
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+13 
;SDCard.c,65 :: 		dataToWrite[14] = voltage[3] % 10;
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_voltage+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_voltage+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+14 
;SDCard.c,67 :: 		dataToWrite[16] = current[0] / 100;
	MOVFF       FARG_writeFileSDCard_current+0, FSR0
	MOVFF       FARG_writeFileSDCard_current+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       100
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+16 
;SDCard.c,68 :: 		dataToWrite[17] = current[0] / 10 - (dataToWrite[16]) * 10;
	MOVFF       FARG_writeFileSDCard_current+0, FSR0
	MOVFF       FARG_writeFileSDCard_current+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+17 
;SDCard.c,69 :: 		dataToWrite[18] = current[0] % 10;
	MOVFF       FARG_writeFileSDCard_current+0, FSR0
	MOVFF       FARG_writeFileSDCard_current+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+18 
;SDCard.c,71 :: 		dataToWrite[20] = current[1] / 100;
	MOVLW       1
	ADDWF       FARG_writeFileSDCard_current+0, 0 
	MOVWF       FLOC__writeFileSDCard+2 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_current+1, 0 
	MOVWF       FLOC__writeFileSDCard+3 
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       100
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+20 
;SDCard.c,72 :: 		dataToWrite[21] = current[1] / 10 - (dataToWrite[20]) * 10;
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+21 
;SDCard.c,73 :: 		dataToWrite[22] = current[1] % 10;
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+22 
;SDCard.c,75 :: 		dataToWrite[24] = current[2] / 100;
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_current+0, 0 
	MOVWF       FLOC__writeFileSDCard+2 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_current+1, 0 
	MOVWF       FLOC__writeFileSDCard+3 
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       100
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+24 
;SDCard.c,76 :: 		dataToWrite[25] = current[2] / 10 - (dataToWrite[24]) * 10;
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+25 
;SDCard.c,77 :: 		dataToWrite[26] = current[2] % 10;
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+26 
;SDCard.c,79 :: 		dataToWrite[28] = current[3] / 100;
	MOVLW       3
	ADDWF       FARG_writeFileSDCard_current+0, 0 
	MOVWF       FLOC__writeFileSDCard+2 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_current+1, 0 
	MOVWF       FLOC__writeFileSDCard+3 
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       100
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+28 
;SDCard.c,80 :: 		dataToWrite[29] = current[3] / 10 - (dataToWrite[28]) * 10;
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+29 
;SDCard.c,81 :: 		dataToWrite[30] = current[3] % 10;
	MOVFF       FLOC__writeFileSDCard+2, FSR0
	MOVFF       FLOC__writeFileSDCard+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+30 
;SDCard.c,83 :: 		dataToWrite[32] = activePower[0] / 10000;
	MOVFF       FARG_writeFileSDCard_activePower+0, FSR0
	MOVFF       FARG_writeFileSDCard_activePower+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+32 
;SDCard.c,84 :: 		dataToWrite[33] = activePower[0] / 1000 - (dataToWrite[32]) * 10;
	MOVFF       FARG_writeFileSDCard_activePower+0, FSR0
	MOVFF       FARG_writeFileSDCard_activePower+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+33 
;SDCard.c,85 :: 		dataToWrite[34] = activePower[0] / 100 - ((dataToWrite[32]) * 100 + (dataToWrite[33]) * 10);
	MOVFF       FARG_writeFileSDCard_activePower+0, FSR0
	MOVFF       FARG_writeFileSDCard_activePower+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       100
	MULWF       writeFileSDCard_dataToWrite_L0+32 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+34 
;SDCard.c,86 :: 		dataToWrite[35] = activePower[0] / 10 - ((dataToWrite[32]) * 1000 + (dataToWrite[33]) * 1000 + (dataToWrite[34]) * 10);
	MOVFF       FARG_writeFileSDCard_activePower+0, FSR0
	MOVFF       FARG_writeFileSDCard_activePower+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+32 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+33 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	ADDWF       R3, 1 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+35 
;SDCard.c,87 :: 		dataToWrite[36] = activePower[0] % 10;
	MOVFF       FARG_writeFileSDCard_activePower+0, FSR0
	MOVFF       FARG_writeFileSDCard_activePower+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+36 
;SDCard.c,89 :: 		dataToWrite[38] = activePower[1] / 10000;
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+38 
;SDCard.c,90 :: 		dataToWrite[39] = activePower[1] / 1000 - (dataToWrite[38]) * 10;
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+39 
;SDCard.c,91 :: 		dataToWrite[40] = activePower[1] / 100 - ((dataToWrite[38]) * 100 + (dataToWrite[39]) * 10);
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       100
	MULWF       writeFileSDCard_dataToWrite_L0+38 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+40 
;SDCard.c,92 :: 		dataToWrite[41] = activePower[1] / 10 - ((dataToWrite[38]) * 1000 + (dataToWrite[39]) * 1000 + (dataToWrite[40]) * 10);
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+38 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+39 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	ADDWF       R3, 1 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+41 
;SDCard.c,93 :: 		dataToWrite[42] = activePower[1] % 10;
	MOVLW       2
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+42 
;SDCard.c,95 :: 		dataToWrite[44] = activePower[2] / 10000;
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+44 
;SDCard.c,96 :: 		dataToWrite[45] = activePower[2] / 1000 - (dataToWrite[44]) * 10;
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+45 
;SDCard.c,97 :: 		dataToWrite[46] = activePower[2] / 100 - ((dataToWrite[44]) * 100 + (dataToWrite[45]) * 10);
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       100
	MULWF       writeFileSDCard_dataToWrite_L0+44 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+46 
;SDCard.c,98 :: 		dataToWrite[47] = activePower[2] / 10 - ((dataToWrite[44]) * 1000 + (dataToWrite[45]) * 1000 + (dataToWrite[46]) * 10);
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+44 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+45 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	ADDWF       R3, 1 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+47 
;SDCard.c,99 :: 		dataToWrite[48] = activePower[2] % 10;
	MOVLW       4
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+48 
;SDCard.c,101 :: 		dataToWrite[50] = activePower[3] / 10000;
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       16
	MOVWF       R4 
	MOVLW       39
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeFileSDCard+1 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+50 
;SDCard.c,102 :: 		dataToWrite[51] = activePower[3] / 1000 - (dataToWrite[50]) * 10;
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+51 
;SDCard.c,103 :: 		dataToWrite[52] = activePower[3] / 100 - ((dataToWrite[50]) * 100 + (dataToWrite[51]) * 10);
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       100
	MULWF       writeFileSDCard_dataToWrite_L0+50 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__writeFileSDCard+0 
	MOVF        FLOC__writeFileSDCard+0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+52 
;SDCard.c,104 :: 		dataToWrite[53] = activePower[3] / 10 - ((dataToWrite[50]) * 1000 + (dataToWrite[51]) * 1000 + (dataToWrite[52]) * 10);
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+50 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       232
	MULWF       writeFileSDCard_dataToWrite_L0+51 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	ADDWF       R3, 1 
	MOVLW       10
	MULWF       FLOC__writeFileSDCard+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+53 
;SDCard.c,105 :: 		dataToWrite[54] = activePower[3] % 10;
	MOVLW       6
	ADDWF       FARG_writeFileSDCard_activePower+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_writeFileSDCard_activePower+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeFileSDCard_dataToWrite_L0+54 
;SDCard.c,109 :: 		for(i = 0; i < 55; i++) dataToWrite[i] = dataToWrite[i] + 48;
	CLRF        writeFileSDCard_i_L0+0 
L_writeFileSDCard7:
	MOVLW       55
	SUBWF       writeFileSDCard_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeFileSDCard8
	MOVLW       writeFileSDCard_dataToWrite_L0+0
	MOVWF       R1 
	MOVLW       hi_addr(writeFileSDCard_dataToWrite_L0+0)
	MOVWF       R2 
	MOVF        writeFileSDCard_i_L0+0, 0 
	ADDWF       R1, 1 
	BTFSC       STATUS+0, 0 
	INCF        R2, 1 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       48
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INCF        writeFileSDCard_i_L0+0, 1 
	GOTO        L_writeFileSDCard7
L_writeFileSDCard8:
;SDCard.c,111 :: 		dataToWrite[3] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+3 
;SDCard.c,112 :: 		dataToWrite[7] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+7 
;SDCard.c,113 :: 		dataToWrite[11] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+11 
;SDCard.c,114 :: 		dataToWrite[15] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+15 
;SDCard.c,115 :: 		dataToWrite[19] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+19 
;SDCard.c,116 :: 		dataToWrite[23] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+23 
;SDCard.c,117 :: 		dataToWrite[27] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+27 
;SDCard.c,118 :: 		dataToWrite[31] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+31 
;SDCard.c,119 :: 		dataToWrite[37] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+37 
;SDCard.c,120 :: 		dataToWrite[43] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+43 
;SDCard.c,121 :: 		dataToWrite[49] = ';';
	MOVLW       59
	MOVWF       writeFileSDCard_dataToWrite_L0+49 
;SDCard.c,122 :: 		dataToWrite[55] = '\r\n';
	MOVLW       13
	MOVWF       writeFileSDCard_dataToWrite_L0+55 
;SDCard.c,126 :: 		Mmc_Fat_Append();
	CALL        _Mmc_Fat_Append+0, 0
;SDCard.c,127 :: 		Mmc_Fat_Write(dataToWrite, 56);
	MOVLW       writeFileSDCard_dataToWrite_L0+0
	MOVWF       FARG_Mmc_Fat_Write_fdata+0 
	MOVLW       hi_addr(writeFileSDCard_dataToWrite_L0+0)
	MOVWF       FARG_Mmc_Fat_Write_fdata+1 
	MOVLW       56
	MOVWF       FARG_Mmc_Fat_Write_len+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Fat_Write_len+1 
	CALL        _Mmc_Fat_Write+0, 0
;SDCard.c,128 :: 		MMC_Fat_Close();
	CALL        _Mmc_Fat_Close+0, 0
;SDCard.c,129 :: 		}
L_end_writeFileSDCard:
	RETURN      0
; end of _writeFileSDCard
