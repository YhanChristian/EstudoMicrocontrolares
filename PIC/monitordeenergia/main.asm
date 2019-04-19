
_configureMcu:

;main.c,35 :: 		void configureMcu() {
;main.c,36 :: 		CMCON = 0x07;   // Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;main.c,37 :: 		ADCON1 = 0x07;  // Configuração ADC AN0 - AN7  pg. 266 datasheet
	MOVLW       7
	MOVWF       ADCON1+0 
;main.c,38 :: 		ADCON2 = 0x38;
	MOVLW       56
	MOVWF       ADCON2+0 
;main.c,39 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_main:

;main.c,44 :: 		void main(){
;main.c,47 :: 		unsigned short current[4] = {0, 0, 0, 0}, i;
	CLRF        main_current_L0+0 
	CLRF        main_current_L0+1 
	CLRF        main_current_L0+2 
	CLRF        main_current_L0+3 
	CLRF        main_voltage_L0+0 
	CLRF        main_voltage_L0+1 
	CLRF        main_voltage_L0+2 
	CLRF        main_voltage_L0+3 
	CLRF        main_voltage_L0+4 
	CLRF        main_voltage_L0+5 
	CLRF        main_voltage_L0+6 
	CLRF        main_voltage_L0+7 
	CLRF        main_activePower_L0+0 
	CLRF        main_activePower_L0+1 
	CLRF        main_activePower_L0+2 
	CLRF        main_activePower_L0+3 
	CLRF        main_activePower_L0+4 
	CLRF        main_activePower_L0+5 
	CLRF        main_activePower_L0+6 
	CLRF        main_activePower_L0+7 
;main.c,50 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;main.c,51 :: 		initDisplay();
	CALL        _initDisplay+0, 0
;main.c,52 :: 		while(1){
L_main0:
;main.c,53 :: 		current[0] = readCurrent(1);
	MOVLW       1
	MOVWF       FARG_readCurrent_sensor+0 
	CALL        _readCurrent+0, 0
	MOVF        R0, 0 
	MOVWF       main_current_L0+0 
;main.c,54 :: 		current[1] = readCurrent(2);
	MOVLW       2
	MOVWF       FARG_readCurrent_sensor+0 
	CALL        _readCurrent+0, 0
	MOVF        R0, 0 
	MOVWF       main_current_L0+1 
;main.c,55 :: 		current[2] = readCurrent(3);
	MOVLW       3
	MOVWF       FARG_readCurrent_sensor+0 
	CALL        _readCurrent+0, 0
	MOVF        R0, 0 
	MOVWF       main_current_L0+2 
;main.c,56 :: 		current[3] = readCurrent(4);
	MOVLW       4
	MOVWF       FARG_readCurrent_sensor+0 
	CALL        _readCurrent+0, 0
	MOVF        R0, 0 
	MOVWF       main_current_L0+3 
;main.c,57 :: 		voltage[0] = readVoltage(1);
	MOVLW       1
	MOVWF       FARG_readVoltage_circuit+0 
	CALL        _readVoltage+0, 0
	MOVF        R0, 0 
	MOVWF       main_voltage_L0+0 
	MOVF        R1, 0 
	MOVWF       main_voltage_L0+1 
;main.c,58 :: 		voltage[1] = readVoltage(2);
	MOVLW       2
	MOVWF       FARG_readVoltage_circuit+0 
	CALL        _readVoltage+0, 0
	MOVF        R0, 0 
	MOVWF       main_voltage_L0+2 
	MOVF        R1, 0 
	MOVWF       main_voltage_L0+3 
;main.c,59 :: 		voltage[2] = readVoltage(3);
	MOVLW       3
	MOVWF       FARG_readVoltage_circuit+0 
	CALL        _readVoltage+0, 0
	MOVF        R0, 0 
	MOVWF       main_voltage_L0+4 
	MOVF        R1, 0 
	MOVWF       main_voltage_L0+5 
;main.c,60 :: 		voltage[3] = readVoltage(4);
	MOVLW       4
	MOVWF       FARG_readVoltage_circuit+0 
	CALL        _readVoltage+0, 0
	MOVF        R0, 0 
	MOVWF       main_voltage_L0+6 
	MOVF        R1, 0 
	MOVWF       main_voltage_L0+7 
;main.c,61 :: 		for (i = 0; i < 4; i++) activePower[i] = calcPower(current[i], voltage[i]);
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
;main.c,62 :: 		showDisplay(current, voltage, activePower);
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
;main.c,63 :: 		}
	GOTO        L_main0
;main.c,64 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_initDisplay:

;main.c,68 :: 		void initDisplay() {
;main.c,69 :: 		LCD_INIT();
	CALL        _Lcd_Init+0, 0
;main.c,70 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,71 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,72 :: 		}
L_end_initDisplay:
	RETURN      0
; end of _initDisplay

_showDisplay:

;main.c,76 :: 		void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]){
;main.c,81 :: 		for (i = 0; i < 4; i++){
	CLRF        showDisplay_i_L0+0 
L_showDisplay5:
	MOVLW       4
	SUBWF       showDisplay_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_showDisplay6
;main.c,82 :: 		LCD_chr(i + 1, 1, 'C');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,83 :: 		LCD_chr(i + 1, 2, i + 1 + 48);
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
;main.c,84 :: 		digit[0] = voltage[i] / 100;
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
;main.c,85 :: 		digit[1] = voltage[i] / 10 - (digit[0]) * 10;
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
;main.c,86 :: 		digit[2] = voltage[i] % 10;
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
;main.c,87 :: 		LCD_chr(i + 1, 4,digit[0] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,88 :: 		LCD_chr(i + 1, 5,digit[1] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+1, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,89 :: 		LCD_chr(i + 1, 6,digit[2] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+2, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,90 :: 		LCD_chr(i + 1, 7,'V');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       86
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,81 :: 		for (i = 0; i < 4; i++){
	INCF        showDisplay_i_L0+0, 1 
;main.c,91 :: 		}
	GOTO        L_showDisplay5
L_showDisplay6:
;main.c,94 :: 		for (i = 0; i < 4; i++){
	CLRF        showDisplay_i_L0+0 
L_showDisplay8:
	MOVLW       4
	SUBWF       showDisplay_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_showDisplay9
;main.c,95 :: 		LCD_chr(i + 1, 1, 'C');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,96 :: 		LCD_chr(i + 1, 2, i + 1 + 48);
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
;main.c,97 :: 		digit[0] = current[i] / 100;
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
;main.c,98 :: 		digit[1] = current[i] / 10 - (digit[0]) * 10;
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
;main.c,99 :: 		digit[2] = current[i] % 10;
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
;main.c,100 :: 		LCD_chr(i + 1, 9,digit[0] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,101 :: 		LCD_chr(i + 1, 10,digit[1] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       10
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+1, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,102 :: 		LCD_chr(i + 1, 11,digit[2] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+2, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,103 :: 		LCD_chr(i + 1, 12,'A');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       65
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,94 :: 		for (i = 0; i < 4; i++){
	INCF        showDisplay_i_L0+0, 1 
;main.c,104 :: 		}
	GOTO        L_showDisplay8
L_showDisplay9:
;main.c,107 :: 		for (i = 0; i < 4; i++){
	CLRF        showDisplay_i_L0+0 
L_showDisplay11:
	MOVLW       4
	SUBWF       showDisplay_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_showDisplay12
;main.c,108 :: 		LCD_chr(i + 1, 1, 'C');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,109 :: 		LCD_chr(i + 1, 2, i + 1 + 48);
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
;main.c,110 :: 		digit[0] = activePower[i] / 10000;
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
;main.c,111 :: 		digit[1] = activePower[i] / 1000 - (digit[0]) * 10;
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
;main.c,112 :: 		digit[2] = activePower[i] / 100 - ((digit[0]) * 100 + (digit[1]) * 10);
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
;main.c,113 :: 		digit[3] = activePower[i] / 10 - ((digit[0]) * 1000 + (digit[1]) * 100 + (digit[2]) * 10);
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
;main.c,114 :: 		digit[4] = activePower[i] % 10;
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
;main.c,115 :: 		LCD_chr(i + 1, 14,digit[0] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,116 :: 		LCD_chr(i + 1, 15,digit[1] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       15
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+1, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,117 :: 		LCD_chr(i + 1, 16,digit[2] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+2, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,118 :: 		LCD_chr(i + 1, 17,digit[3] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       17
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+3, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,119 :: 		LCD_chr(i + 1, 18,digit[4] + 48);
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       showDisplay_digit_L0+4, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,120 :: 		LCD_chr(i + 1, 19,'W');
	MOVF        showDisplay_i_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       19
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       87
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,107 :: 		for (i = 0; i < 4; i++){
	INCF        showDisplay_i_L0+0, 1 
;main.c,121 :: 		}
	GOTO        L_showDisplay11
L_showDisplay12:
;main.c,122 :: 		}
L_end_showDisplay:
	RETURN      0
; end of _showDisplay

_calcPower:

;main.c,126 :: 		unsigned int calcPower(unsigned short current, int voltage){
;main.c,128 :: 		activePower = current * voltage;
	MOVF        FARG_calcPower_current+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_calcPower_voltage+0, 0 
	MOVWF       R4 
	MOVF        FARG_calcPower_voltage+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;main.c,129 :: 		return activePower;
;main.c,130 :: 		}
L_end_calcPower:
	RETURN      0
; end of _calcPower

_readCurrent:

;main.c,134 :: 		int readCurrent(unsigned short sensor) {
;main.c,135 :: 		int time[2] = {0, 1024};
	CLRF        readCurrent_time_L0+0 
	CLRF        readCurrent_time_L0+1 
	MOVLW       0
	MOVWF       readCurrent_time_L0+2 
	MOVLW       4
	MOVWF       readCurrent_time_L0+3 
	CLRF        readCurrent_value_L0+0 
	CLRF        readCurrent_value_L0+1 
;main.c,138 :: 		for(i = 0; i < 254; i++) {
	CLRF        readCurrent_i_L0+0 
	CLRF        readCurrent_i_L0+1 
L_readCurrent14:
	MOVLW       0
	SUBWF       readCurrent_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readCurrent31
	MOVLW       254
	SUBWF       readCurrent_i_L0+0, 0 
L__readCurrent31:
	BTFSC       STATUS+0, 0 
	GOTO        L_readCurrent15
;main.c,139 :: 		value = ADC_Read(sensor - 1);
	DECF        FARG_readCurrent_sensor+0, 0 
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       readCurrent_value_L0+0 
	MOVF        R1, 0 
	MOVWF       readCurrent_value_L0+1 
;main.c,140 :: 		if(time[0] < value) time[0] = value; // Obtem onda senoidal valores máximos
	MOVLW       128
	XORWF       readCurrent_time_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readCurrent32
	MOVF        R0, 0 
	SUBWF       readCurrent_time_L0+0, 0 
L__readCurrent32:
	BTFSC       STATUS+0, 0 
	GOTO        L_readCurrent17
	MOVF        readCurrent_value_L0+0, 0 
	MOVWF       readCurrent_time_L0+0 
	MOVF        readCurrent_value_L0+1, 0 
	MOVWF       readCurrent_time_L0+1 
L_readCurrent17:
;main.c,141 :: 		if(time[1] > value) time[1] = value;
	MOVLW       128
	XORWF       readCurrent_value_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       readCurrent_time_L0+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readCurrent33
	MOVF        readCurrent_time_L0+2, 0 
	SUBWF       readCurrent_value_L0+0, 0 
L__readCurrent33:
	BTFSC       STATUS+0, 0 
	GOTO        L_readCurrent18
	MOVF        readCurrent_value_L0+0, 0 
	MOVWF       readCurrent_time_L0+2 
	MOVF        readCurrent_value_L0+1, 0 
	MOVWF       readCurrent_time_L0+3 
L_readCurrent18:
;main.c,138 :: 		for(i = 0; i < 254; i++) {
	INFSNZ      readCurrent_i_L0+0, 1 
	INCF        readCurrent_i_L0+1, 1 
;main.c,142 :: 		}
	GOTO        L_readCurrent14
L_readCurrent15:
;main.c,143 :: 		relativeVoltage = (time[0] - time[1]) * 0.13808; // Converte valor lido em mV
	MOVF        readCurrent_time_L0+2, 0 
	SUBWF       readCurrent_time_L0+0, 0 
	MOVWF       R0 
	MOVF        readCurrent_time_L0+3, 0 
	SUBWFB      readCurrent_time_L0+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVLW       216
	MOVWF       R4 
	MOVLW       100
	MOVWF       R5 
	MOVLW       13
	MOVWF       R6 
	MOVLW       124
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2int+0, 0
;main.c,144 :: 		readCurrentAmp = relativeVoltage * 0.707; // converte valor para RMS
	CALL        _int2double+0, 0
	MOVLW       244
	MOVWF       R4 
	MOVLW       253
	MOVWF       R5 
	MOVLW       52
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       readCurrent_readCurrentAmp_L0+0 
	MOVF        R1, 0 
	MOVWF       readCurrent_readCurrentAmp_L0+1 
;main.c,145 :: 		readCurrentAmp = readCurrentAmp * 2; //multipla valor para obter corrente lida
	MOVF        R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	MOVF        R2, 0 
	MOVWF       readCurrent_readCurrentAmp_L0+0 
	MOVF        R3, 0 
	MOVWF       readCurrent_readCurrentAmp_L0+1 
;main.c,147 :: 		if(readCurrentAmp < 0) readCurrentAmp = -readCurrentAmp;
	MOVLW       128
	XORWF       R3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readCurrent34
	MOVLW       0
	SUBWF       R2, 0 
L__readCurrent34:
	BTFSC       STATUS+0, 0 
	GOTO        L_readCurrent19
	MOVF        readCurrent_readCurrentAmp_L0+0, 0 
	SUBLW       0
	MOVWF       readCurrent_readCurrentAmp_L0+0 
	MOVF        readCurrent_readCurrentAmp_L0+1, 0 
	MOVWF       readCurrent_readCurrentAmp_L0+1 
	MOVLW       0
	SUBFWB      readCurrent_readCurrentAmp_L0+1, 1 
L_readCurrent19:
;main.c,148 :: 		if(readCurrentAmp > 100) readCurrentAmp = 100;
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       readCurrent_readCurrentAmp_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readCurrent35
	MOVF        readCurrent_readCurrentAmp_L0+0, 0 
	SUBLW       100
L__readCurrent35:
	BTFSC       STATUS+0, 0 
	GOTO        L_readCurrent20
	MOVLW       100
	MOVWF       readCurrent_readCurrentAmp_L0+0 
	MOVLW       0
	MOVWF       readCurrent_readCurrentAmp_L0+1 
L_readCurrent20:
;main.c,150 :: 		return readCurrentAmp;
	MOVF        readCurrent_readCurrentAmp_L0+0, 0 
	MOVWF       R0 
	MOVF        readCurrent_readCurrentAmp_L0+1, 0 
	MOVWF       R1 
;main.c,151 :: 		}
L_end_readCurrent:
	RETURN      0
; end of _readCurrent

_readVoltage:

;main.c,153 :: 		int readVoltage(unsigned short circuit) {
;main.c,154 :: 		int tempValue = 0, pcm = 254;
	CLRF        readVoltage_tempValue_L0+0 
	CLRF        readVoltage_tempValue_L0+1 
	MOVLW       82
	MOVWF       readVoltage_conversion_L0+0 
	MOVLW       184
	MOVWF       readVoltage_conversion_L0+1 
	MOVLW       30
	MOVWF       readVoltage_conversion_L0+2 
	MOVLW       128
	MOVWF       readVoltage_conversion_L0+3 
	MOVLW       0
	MOVWF       readVoltage_conversion_L0+4 
	MOVLW       0
	MOVWF       readVoltage_conversion_L0+5 
	MOVLW       92
	MOVWF       readVoltage_conversion_L0+6 
	MOVLW       134
	MOVWF       readVoltage_conversion_L0+7 
;main.c,158 :: 		for(i = 0; i < 254; i++) {
	CLRF        readVoltage_i_L0+0 
L_readVoltage21:
	MOVLW       254
	SUBWF       readVoltage_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_readVoltage22
;main.c,159 :: 		pcm = ADC_Read(circuit + 3);
	MOVLW       3
	ADDWF       FARG_readVoltage_circuit+0, 0 
	MOVWF       FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;main.c,160 :: 		if(pcm > tempValue) pcm = tempValue;
	MOVLW       128
	XORWF       readVoltage_tempValue_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readVoltage37
	MOVF        R0, 0 
	SUBWF       readVoltage_tempValue_L0+0, 0 
L__readVoltage37:
	BTFSC       STATUS+0, 0 
	GOTO        L_readVoltage24
L_readVoltage24:
;main.c,158 :: 		for(i = 0; i < 254; i++) {
	INCF        readVoltage_i_L0+0, 1 
;main.c,161 :: 		}
	GOTO        L_readVoltage21
L_readVoltage22:
;main.c,163 :: 		voltageAC =  tempValue * 0.0048828125;  //converte de PCM para tensão (até 5V --> 5/1024)
	MOVF        readVoltage_tempValue_L0+0, 0 
	MOVWF       R0 
	MOVF        readVoltage_tempValue_L0+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       119
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__readVoltage+0 
	MOVF        R1, 0 
	MOVWF       FLOC__readVoltage+1 
	MOVF        R2, 0 
	MOVWF       FLOC__readVoltage+2 
	MOVF        R3, 0 
	MOVWF       FLOC__readVoltage+3 
	MOVF        readVoltage_conversion_L0+0, 0 
	MOVWF       R4 
	MOVF        readVoltage_conversion_L0+1, 0 
	MOVWF       R5 
	MOVF        readVoltage_conversion_L0+2, 0 
	MOVWF       R6 
	MOVF        readVoltage_conversion_L0+3, 0 
	MOVWF       R7 
	MOVF        readVoltage_conversion_L0+4, 0 
	MOVWF       R0 
	MOVF        readVoltage_conversion_L0+5, 0 
	MOVWF       R1 
	MOVF        readVoltage_conversion_L0+6, 0 
	MOVWF       R2 
	MOVF        readVoltage_conversion_L0+7, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
;main.c,164 :: 		voltageAC = voltageAC *(conversion[1] / conversion[0]);
	MOVF        FLOC__readVoltage+0, 0 
	MOVWF       R4 
	MOVF        FLOC__readVoltage+1, 0 
	MOVWF       R5 
	MOVF        FLOC__readVoltage+2, 0 
	MOVWF       R6 
	MOVF        FLOC__readVoltage+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
;main.c,166 :: 		return voltageAC;
	CALL        _double2int+0, 0
;main.c,167 :: 		}
L_end_readVoltage:
	RETURN      0
; end of _readVoltage
