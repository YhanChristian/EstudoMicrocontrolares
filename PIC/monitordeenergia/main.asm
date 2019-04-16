
_configureMcu:

;main.c,34 :: 		void configureMcu() {
;main.c,35 :: 		CMCON = 0x07;   // Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;main.c,36 :: 		ADCON1 = 0x0B;  // Configuração ADC pg. 266
	MOVLW       11
	MOVWF       ADCON1+0 
;main.c,37 :: 		ADCON2 = 0x38;
	MOVLW       56
	MOVWF       ADCON2+0 
;main.c,38 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_main:

;main.c,43 :: 		void main(){
;main.c,46 :: 		unsigned short current[4] = {123,210,132,213}, i;
	MOVLW       123
	MOVWF       main_current_L0+0 
	MOVLW       210
	MOVWF       main_current_L0+1 
	MOVLW       132
	MOVWF       main_current_L0+2 
	MOVLW       213
	MOVWF       main_current_L0+3 
	MOVLW       220
	MOVWF       main_voltage_L0+0 
	MOVLW       0
	MOVWF       main_voltage_L0+1 
	MOVLW       220
	MOVWF       main_voltage_L0+2 
	MOVLW       0
	MOVWF       main_voltage_L0+3 
	MOVLW       220
	MOVWF       main_voltage_L0+4 
	MOVLW       0
	MOVWF       main_voltage_L0+5 
	MOVLW       220
	MOVWF       main_voltage_L0+6 
	MOVLW       0
	MOVWF       main_voltage_L0+7 
	CLRF        main_activePower_L0+0 
	CLRF        main_activePower_L0+1 
	CLRF        main_activePower_L0+2 
	CLRF        main_activePower_L0+3 
	CLRF        main_activePower_L0+4 
	CLRF        main_activePower_L0+5 
	CLRF        main_activePower_L0+6 
	CLRF        main_activePower_L0+7 
;main.c,49 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;main.c,50 :: 		initDisplay();
	CALL        _initDisplay+0, 0
;main.c,51 :: 		while(1){
L_main0:
;main.c,56 :: 		for (i=0; i<4; i++) activePower[i] = calcPower(current[i],voltage[i]);
	CLRF        main_i_L0+0 
L_main2:
	MOVLW       4
	SUBWF       main_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main3
	MOVF        main_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       main_activePower_L0+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(main_activePower_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       main_current_L0+0
	MOVWF       FSR0 
	MOVLW       hi_addr(main_current_L0+0)
	MOVWF       FSR0H 
	MOVF        main_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_calcPower_current+0 
	MOVLW       main_voltage_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(main_voltage_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_calcPower_voltage+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_calcPower_voltage+1 
	CALL        _calcPower+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	INCF        main_i_L0+0, 1 
	GOTO        L_main2
L_main3:
;main.c,57 :: 		showDisplay(current, voltage, activePower);
	MOVLW       main_current_L0+0
	MOVWF       FARG_showDisplay_current+0 
	MOVLW       hi_addr(main_current_L0+0)
	MOVWF       FARG_showDisplay_current+1 
	MOVLW       main_voltage_L0+0
	MOVWF       FARG_showDisplay_voltage+0 
	MOVLW       hi_addr(main_voltage_L0+0)
	MOVWF       FARG_showDisplay_voltage+1 
	MOVLW       main_activePower_L0+0
	MOVWF       FARG_showDisplay_activePower+0 
	MOVLW       hi_addr(main_activePower_L0+0)
	MOVWF       FARG_showDisplay_activePower+1 
	CALL        _showDisplay+0, 0
;main.c,58 :: 		}
	GOTO        L_main0
;main.c,59 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_initDisplay:

;main.c,66 :: 		void initDisplay() {
;main.c,67 :: 		LCD_INIT();
	CALL        _Lcd_Init+0, 0
;main.c,68 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,69 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,70 :: 		}
L_end_initDisplay:
	RETURN      0
; end of _initDisplay

_showDisplay:

;main.c,74 :: 		void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]){
;main.c,79 :: 		for (i = 0; i < 4; i++){
	CLRF        showDisplay_i_L0+0 
L_showDisplay5:
	MOVLW       4
	SUBWF       showDisplay_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_showDisplay6
;main.c,80 :: 		LCD_chr(i + 1, 1, 'C');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,81 :: 		LCD_chr(i + 1, 2, i + 1 + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,82 :: 		digit[0] = voltage[i] / 100;
	MOVF        showDisplay_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_showDisplay_voltage+0, 0 
	MOVWF       FLOC__showDisplay+2 
	MOVF        R1, 0 
	ADDWFC      FARG_showDisplay_voltage+1, 0 
	MOVWF       FLOC__showDisplay+3 
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MOVWF       FLOC__showDisplay+0 
	MOVF        R1, 0 
	MOVWF       FLOC__showDisplay+1 
	MOVF        FLOC__showDisplay+0, 0 
	MOVWF       showDisplay_digit_L0+0 
;main.c,83 :: 		digit[1] = voltage[i] / 10 - (digit[0]) * 10;
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MULWF       FLOC__showDisplay+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       showDisplay_digit_L0+1 
;main.c,84 :: 		digit[2] = voltage[i] % 10;
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MOVWF       showDisplay_digit_L0+2 
;main.c,85 :: 		LCD_chr(i + 1, 4,digit[0] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,86 :: 		LCD_chr(i + 1, 5,digit[1] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+1, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,87 :: 		LCD_chr(i + 1, 6,digit[2] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+2, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,88 :: 		LCD_chr(i + 1, 7,'V');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       86
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,79 :: 		for (i = 0; i < 4; i++){
	INCF        showDisplay_i_L0+0, 1 
;main.c,89 :: 		}
	GOTO        L_showDisplay5
L_showDisplay6:
;main.c,92 :: 		for (i = 0; i < 4; i++){
	CLRF        showDisplay_i_L0+0 
L_showDisplay8:
	MOVLW       4
	SUBWF       showDisplay_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_showDisplay9
;main.c,93 :: 		LCD_chr(i + 1, 1, 'C');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,94 :: 		LCD_chr(i + 1, 2, i + 1 + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,95 :: 		digit[0] = current[i] / 100;
	MOVF        showDisplay_i_L0+0, 0 
	ADDWF       FARG_showDisplay_current+0, 0 
	MOVWF       FLOC__showDisplay+2 
	MOVLW       0
	ADDWFC      FARG_showDisplay_current+1, 0 
	MOVWF       FLOC__showDisplay+3 
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       100
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__showDisplay+0 
	MOVF        FLOC__showDisplay+0, 0 
	MOVWF       showDisplay_digit_L0+0 
;main.c,96 :: 		digit[1] = current[i] / 10 - (digit[0]) * 10;
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVLW       10
	MULWF       FLOC__showDisplay+0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBWF       R0, 0 
	MOVWF       showDisplay_digit_L0+1 
;main.c,97 :: 		digit[2] = current[i] % 10;
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       showDisplay_digit_L0+2 
;main.c,98 :: 		LCD_chr(i + 1, 9,digit[0] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,99 :: 		LCD_chr(i + 1, 10,digit[1] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       10
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+1, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,100 :: 		LCD_chr(i + 1, 11,digit[2] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+2, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,101 :: 		LCD_chr(i + 1, 12,'V');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       86
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,92 :: 		for (i = 0; i < 4; i++){
	INCF        showDisplay_i_L0+0, 1 
;main.c,102 :: 		}
	GOTO        L_showDisplay8
L_showDisplay9:
;main.c,105 :: 		for (i = 0; i < 4; i++){
	CLRF        showDisplay_i_L0+0 
L_showDisplay11:
	MOVLW       4
	SUBWF       showDisplay_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_showDisplay12
;main.c,106 :: 		LCD_chr(i + 1, 1, 'C');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,107 :: 		LCD_chr(i + 1, 2, i + 1 + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,108 :: 		digit[0] = activePower[i] / 10000;
	MOVF        showDisplay_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_showDisplay_activePower+0, 0 
	MOVWF       FLOC__showDisplay+2 
	MOVF        R1, 0 
	ADDWFC      FARG_showDisplay_activePower+1, 0 
	MOVWF       FLOC__showDisplay+3 
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MOVWF       FLOC__showDisplay+0 
	MOVF        R1, 0 
	MOVWF       FLOC__showDisplay+1 
	MOVF        FLOC__showDisplay+0, 0 
	MOVWF       showDisplay_digit_L0+0 
;main.c,109 :: 		digit[1] = activePower[i] / 1000 - (digit[0]) * 10;
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MULWF       FLOC__showDisplay+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__showDisplay+0 
	MOVF        FLOC__showDisplay+0, 0 
	MOVWF       showDisplay_digit_L0+1 
;main.c,110 :: 		digit[2] = activePower[i] / 100 - ((digit[0]) * 100 + (digit[1]) * 10);
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MULWF       showDisplay_digit_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       10
	MULWF       FLOC__showDisplay+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       FLOC__showDisplay+0 
	MOVF        FLOC__showDisplay+0, 0 
	MOVWF       showDisplay_digit_L0+2 
;main.c,111 :: 		digit[3] = activePower[i] / 10 - ((digit[0]) * 1000 + (digit[1]) * 100 + (digit[2]) * 10);
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MULWF       showDisplay_digit_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R3 
	MOVLW       100
	MULWF       showDisplay_digit_L0+1 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	ADDWF       R3, 1 
	MOVLW       10
	MULWF       FLOC__showDisplay+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R2, 1 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       showDisplay_digit_L0+3 
;main.c,112 :: 		digit[4] = activePower[i] % 10;
	MOVFF       FLOC__showDisplay+2, FSR0
	MOVFF       FLOC__showDisplay+3, FSR0H
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
	MOVWF       showDisplay_digit_L0+4 
;main.c,113 :: 		LCD_chr(i + 1, 14,digit[0] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,114 :: 		LCD_chr(i + 1, 15,digit[1] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       15
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+1, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,115 :: 		LCD_chr(i + 1, 16,digit[2] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+2, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,116 :: 		LCD_chr(i + 1, 17,digit[3] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       17
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+3, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,117 :: 		LCD_chr(i + 1, 18,digit[4] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+4, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,118 :: 		LCD_chr(i + 1, 19,'W');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       19
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       87
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,105 :: 		for (i = 0; i < 4; i++){
	INCF        showDisplay_i_L0+0, 1 
;main.c,119 :: 		}
	GOTO        L_showDisplay11
L_showDisplay12:
;main.c,120 :: 		}
L_end_showDisplay:
	RETURN      0
; end of _showDisplay

_calcPower:

;main.c,124 :: 		unsigned int calcPower(unsigned short current, int voltage){
;main.c,126 :: 		activePower = current * voltage;
	MOVF        FARG_calcPower_current+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_calcPower_voltage+0, 0 
	MOVWF       R4 
	MOVF        FARG_calcPower_voltage+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;main.c,127 :: 		return activePower;
;main.c,128 :: 		}
L_end_calcPower:
	RETURN      0
; end of _calcPower
