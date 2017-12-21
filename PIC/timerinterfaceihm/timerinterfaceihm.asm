
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;timerinterfaceihm.c,61 :: 		void interrupt() {
;timerinterfaceihm.c,62 :: 		if(TMR2IF_bit) {
	BTFSS      TMR2IF_bit+0, 1
	GOTO       L_interrupt0
;timerinterfaceihm.c,63 :: 		TMR2IF_bit = 0x00;
	BCF        TMR2IF_bit+0, 1
;timerinterfaceihm.c,64 :: 		tmr02Trigger = ~tmr02Trigger;
	MOVLW      1
	XORWF      _flagA+0, 1
;timerinterfaceihm.c,65 :: 		if(tmr02Trigger) {
	BTFSS      _flagA+0, 0
	GOTO       L_interrupt1
;timerinterfaceihm.c,66 :: 		tmr02Counter[0]++;
	INCF       _tmr02Counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tmr02Counter+1, 1
;timerinterfaceihm.c,67 :: 		tmr02Counter[1]++;
	INCF       _tmr02Counter+2, 1
	BTFSC      STATUS+0, 2
	INCF       _tmr02Counter+3, 1
;timerinterfaceihm.c,68 :: 		if(tmr02Counter[0] == 490) {
	MOVF       _tmr02Counter+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt37
	MOVLW      234
	XORWF      _tmr02Counter+0, 0
L__interrupt37:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;timerinterfaceihm.c,69 :: 		oneSecond = ~oneSecond;
	MOVLW      2
	XORWF      _flagA+0, 1
;timerinterfaceihm.c,70 :: 		oneSecondActive = ~oneSecondActive;
	MOVLW      8
	XORWF      _flagB+0, 1
;timerinterfaceihm.c,71 :: 		tmr02Counter[0] = 0;
	CLRF       _tmr02Counter+0
	CLRF       _tmr02Counter+1
;timerinterfaceihm.c,72 :: 		}
L_interrupt2:
;timerinterfaceihm.c,73 :: 		if(tmr02Counter[1] == 30) {
	MOVLW      0
	XORWF      _tmr02Counter+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt38
	MOVLW      30
	XORWF      _tmr02Counter+2, 0
L__interrupt38:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;timerinterfaceihm.c,74 :: 		oneSecond = ~oneSecond;
	MOVLW      2
	XORWF      _flagA+0, 1
;timerinterfaceihm.c,75 :: 		updateDisplay = ~updateDisplay;
	MOVLW      4
	XORWF      _flagB+0, 1
;timerinterfaceihm.c,76 :: 		tmr02Counter[1] = 0;
	CLRF       _tmr02Counter+2
	CLRF       _tmr02Counter+3
;timerinterfaceihm.c,77 :: 		}
L_interrupt3:
;timerinterfaceihm.c,78 :: 		}
L_interrupt1:
;timerinterfaceihm.c,79 :: 		}
L_interrupt0:
;timerinterfaceihm.c,80 :: 		}
L_end_interrupt:
L__interrupt36:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;timerinterfaceihm.c,82 :: 		void main() {
;timerinterfaceihm.c,83 :: 		configureMcu();
	CALL       _configureMcu+0
;timerinterfaceihm.c,84 :: 		initDisplay();
	CALL       _initDisplay+0
;timerinterfaceihm.c,86 :: 		while(1) {
L_main4:
;timerinterfaceihm.c,87 :: 		TMR2ON_bit = 0x01;
	BSF        TMR2ON_bit+0, 2
;timerinterfaceihm.c,88 :: 		readButtons();
	CALL       _readButtons+0
;timerinterfaceihm.c,90 :: 		if(updateDisplay) display(2, timeSet);
	BTFSS      _flagB+0, 2
	GOTO       L_main6
	MOVLW      2
	MOVWF      FARG_display_line+0
	MOVF       _timeSet+0, 0
	MOVWF      FARG_display_value+0
	MOVF       _timeSet+1, 0
	MOVWF      FARG_display_value+1
	CALL       _display+0
L_main6:
;timerinterfaceihm.c,92 :: 		if(active) {
	BTFSS      _flagA+0, 7
	GOTO       L_main7
;timerinterfaceihm.c,93 :: 		if(oneSecond) {
	BTFSS      _flagA+0, 1
	GOTO       L_main8
;timerinterfaceihm.c,94 :: 		display(1, myTimer);
	MOVLW      1
	MOVWF      FARG_display_line+0
	MOVF       _myTimer+0, 0
	MOVWF      FARG_display_value+0
	MOVF       _myTimer+1, 0
	MOVWF      FARG_display_value+1
	CALL       _display+0
;timerinterfaceihm.c,95 :: 		myTimer++;
	INCF       _myTimer+0, 1
	BTFSC      STATUS+0, 2
	INCF       _myTimer+1, 1
;timerinterfaceihm.c,96 :: 		oneSecond = 0x00;
	BCF        _flagA+0, 1
;timerinterfaceihm.c,97 :: 		}
L_main8:
;timerinterfaceihm.c,98 :: 		}
	GOTO       L_main9
L_main7:
;timerinterfaceihm.c,100 :: 		myTimer = 0x00;
	CLRF       _myTimer+0
	CLRF       _myTimer+1
;timerinterfaceihm.c,101 :: 		if(encoderInc) {
	BTFSS      _flagA+0, 2
	GOTO       L_main10
;timerinterfaceihm.c,102 :: 		if(timeSet < 86399) timeSet++;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      1
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      81
	SUBWF      _timeSet+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      127
	SUBWF      _timeSet+0, 0
L__main40:
	BTFSC      STATUS+0, 0
	GOTO       L_main11
	INCF       _timeSet+0, 1
	BTFSC      STATUS+0, 2
	INCF       _timeSet+1, 1
L_main11:
;timerinterfaceihm.c,103 :: 		}
L_main10:
;timerinterfaceihm.c,104 :: 		if(encoderDec) {
	BTFSS      _flagA+0, 3
	GOTO       L_main12
;timerinterfaceihm.c,105 :: 		if(timeSet > 0) timeSet--;
	MOVF       _timeSet+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main41
	MOVF       _timeSet+0, 0
	SUBLW      0
L__main41:
	BTFSC      STATUS+0, 0
	GOTO       L_main13
	MOVLW      1
	SUBWF      _timeSet+0, 1
	BTFSS      STATUS+0, 0
	DECF       _timeSet+1, 1
L_main13:
;timerinterfaceihm.c,106 :: 		}
L_main12:
;timerinterfaceihm.c,107 :: 		}
L_main9:
;timerinterfaceihm.c,109 :: 		encoderDec = 0x00;
	BCF        _flagA+0, 3
;timerinterfaceihm.c,110 :: 		encoderInc = 0x00;
	BCF        _flagA+0, 2
;timerinterfaceihm.c,111 :: 		encoderPushButton = 0x00;
	BCF        _flagA+0, 6
;timerinterfaceihm.c,113 :: 		}
	GOTO       L_main4
;timerinterfaceihm.c,114 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;timerinterfaceihm.c,116 :: 		void configureMcu() {
;timerinterfaceihm.c,117 :: 		CMCON = 0x07;       // Desabilita comparadores
	MOVLW      7
	MOVWF      CMCON+0
;timerinterfaceihm.c,118 :: 		TRISB0_bit = 0x00;  // RB0 como saída
	BCF        TRISB0_bit+0, 0
;timerinterfaceihm.c,119 :: 		TRISA = 0x07;       // Defino pinos RA0, RA1 e RA2 como entrada
	MOVLW      7
	MOVWF      TRISA+0
;timerinterfaceihm.c,120 :: 		INTCON.GIE = 0x01;  // Habilita interrupção global
	BSF        INTCON+0, 7
;timerinterfaceihm.c,121 :: 		INTCON.PEIE = 0x01; // Habilita interrupção de periféricos
	BSF        INTCON+0, 6
;timerinterfaceihm.c,122 :: 		TMR2IE_bit = 0X01;  // Habilita interrupção do TMR2
	BSF        TMR2IE_bit+0, 1
;timerinterfaceihm.c,123 :: 		T2CON = 0x01;       // Config TMR2 Postscaler 1 Prescaler 4, timer desabilitado
	MOVLW      1
	MOVWF      T2CON+0
;timerinterfaceihm.c,124 :: 		PR2 =  pr2Value;    // Atribui a PR2 o valor da variavel pr2Value
	MOVF       _pr2Value+0, 0
	MOVWF      PR2+0
;timerinterfaceihm.c,127 :: 		active = 0x00;
	BCF        _flagA+0, 7
;timerinterfaceihm.c,128 :: 		encoderInc = 0x00;
	BCF        _flagA+0, 2
;timerinterfaceihm.c,129 :: 		encoderDec = 0x00;
	BCF        _flagA+0, 3
;timerinterfaceihm.c,130 :: 		encoderPushButton = 0x00;
	BCF        _flagA+0, 6
;timerinterfaceihm.c,131 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu

_initDisplay:

;timerinterfaceihm.c,133 :: 		void initDisplay() {
;timerinterfaceihm.c,134 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;timerinterfaceihm.c,135 :: 		Lcd_CMD(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;timerinterfaceihm.c,136 :: 		Lcd_CMD(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;timerinterfaceihm.c,137 :: 		display(1, myTimer);
	MOVLW      1
	MOVWF      FARG_display_line+0
	MOVF       _myTimer+0, 0
	MOVWF      FARG_display_value+0
	MOVF       _myTimer+1, 0
	MOVWF      FARG_display_value+1
	CALL       _display+0
;timerinterfaceihm.c,138 :: 		display(2, timeSet);
	MOVLW      2
	MOVWF      FARG_display_line+0
	MOVF       _timeSet+0, 0
	MOVWF      FARG_display_value+0
	MOVF       _timeSet+1, 0
	MOVWF      FARG_display_value+1
	CALL       _display+0
;timerinterfaceihm.c,139 :: 		}
L_end_initDisplay:
	RETURN
; end of _initDisplay

_display:

;timerinterfaceihm.c,141 :: 		void display(unsigned short line, unsigned int value) {
;timerinterfaceihm.c,149 :: 		hour = (value / 60) / 60;    // Obtem valor hora
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_display_value+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_value+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      display_hour_L0+0
;timerinterfaceihm.c,150 :: 		minute = (value - (hour * 3600)) / 60; // Resto da hora minutos
	MOVLW      0
	MOVWF      R0+1
	MOVLW      16
	MOVWF      R4+0
	MOVLW      14
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	SUBWF      FARG_display_value+0, 0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FARG_display_value+1, 0
	MOVWF      R0+1
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      display_minute_L0+0
;timerinterfaceihm.c,152 :: 		if(myTimer > 59) second = value - (minute * 60 + hour * 3600); // Resto de minutos segundos
	MOVF       _myTimer+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__display45
	MOVF       _myTimer+0, 0
	SUBLW      59
L__display45:
	BTFSC      STATUS+0, 0
	GOTO       L_display14
	MOVF       display_minute_L0+0, 0
	MOVWF      R0+0
	MOVLW      60
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__display+0
	MOVF       display_hour_L0+0, 0
	MOVWF      R0+0
	MOVLW      16
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       FLOC__display+0, 0
	ADDWF      R0+0, 1
	MOVF       R0+0, 0
	SUBWF      FARG_display_value+0, 0
	MOVWF      display_second_L0+0
	GOTO       L_display15
L_display14:
;timerinterfaceihm.c,154 :: 		second = value;
	MOVF       FARG_display_value+0, 0
	MOVWF      display_second_L0+0
;timerinterfaceihm.c,155 :: 		minute = 0;
	CLRF       display_minute_L0+0
;timerinterfaceihm.c,156 :: 		hour = 0;
	CLRF       display_hour_L0+0
;timerinterfaceihm.c,157 :: 		}
L_display15:
;timerinterfaceihm.c,160 :: 		time[0] = hour / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_hour_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+0
;timerinterfaceihm.c,161 :: 		time[1] = hour % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_hour_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+1
;timerinterfaceihm.c,162 :: 		time[2] = minute / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_minute_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+2
;timerinterfaceihm.c,163 :: 		time[3] = minute % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_minute_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+3
;timerinterfaceihm.c,164 :: 		time[4] = second / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_second_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+4
;timerinterfaceihm.c,165 :: 		time[5] = second % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_second_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+5
;timerinterfaceihm.c,169 :: 		lcd_chr(line, 5, time[0] + 48);
	MOVF       FARG_display_line+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      display_time_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;timerinterfaceihm.c,170 :: 		lcd_chr_cp(time[1] + 48);
	MOVLW      48
	ADDWF      display_time_L0+1, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,171 :: 		lcd_chr_cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,172 :: 		lcd_chr_cp(time[2] + 48);
	MOVLW      48
	ADDWF      display_time_L0+2, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,173 :: 		lcd_chr_cp(time[3] + 48);
	MOVLW      48
	ADDWF      display_time_L0+3, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,174 :: 		lcd_chr_cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,175 :: 		lcd_chr_cp(time[4] + 48);
	MOVLW      48
	ADDWF      display_time_L0+4, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,176 :: 		lcd_chr_cp(time[5] + 48);
	MOVLW      48
	ADDWF      display_time_L0+5, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,177 :: 		}
L_end_display:
	RETURN
; end of _display

_readButtons:

;timerinterfaceihm.c,179 :: 		void readButtons() {
;timerinterfaceihm.c,183 :: 		if(!encoderCLK) {
	BTFSC      PORTA+0, 1
	GOTO       L_readButtons16
;timerinterfaceihm.c,184 :: 		encoderFlag = 0x01;
	BSF        _flagA+0, 4
;timerinterfaceihm.c,185 :: 		encoderInc = 0x01;
	BSF        _flagA+0, 2
;timerinterfaceihm.c,186 :: 		}
	GOTO       L_readButtons17
L_readButtons16:
;timerinterfaceihm.c,188 :: 		if(!encoderDT) {
	BTFSC      PORTA+0, 2
	GOTO       L_readButtons18
;timerinterfaceihm.c,189 :: 		if(!encoderFlag) {
	BTFSC      _flagA+0, 4
	GOTO       L_readButtons19
;timerinterfaceihm.c,190 :: 		encoderFlag = 0x01;
	BSF        _flagA+0, 4
;timerinterfaceihm.c,191 :: 		encoderDec = 0x01;
	BSF        _flagA+0, 3
;timerinterfaceihm.c,192 :: 		}
L_readButtons19:
;timerinterfaceihm.c,193 :: 		}
L_readButtons18:
;timerinterfaceihm.c,194 :: 		}
L_readButtons17:
;timerinterfaceihm.c,195 :: 		if(encoderCLK) {
	BTFSS      PORTA+0, 1
	GOTO       L_readButtons20
;timerinterfaceihm.c,196 :: 		if(encoderDT) encoderFlag = 0x00;
	BTFSS      PORTA+0, 2
	GOTO       L_readButtons21
	BCF        _flagA+0, 4
L_readButtons21:
;timerinterfaceihm.c,197 :: 		}
L_readButtons20:
;timerinterfaceihm.c,199 :: 		if(!encoderSW) {
	BTFSC      PORTA+0, 0
	GOTO       L_readButtons22
;timerinterfaceihm.c,200 :: 		if(oneSecondActive) {
	BTFSS      _flagB+0, 3
	GOTO       L_readButtons23
;timerinterfaceihm.c,201 :: 		intCounter++;
	INCF       _intCounter+0, 1
;timerinterfaceihm.c,202 :: 		oneSecondActive = 0x00;
	BCF        _flagB+0, 3
;timerinterfaceihm.c,203 :: 		}
L_readButtons23:
;timerinterfaceihm.c,204 :: 		if(intCounter > 2) activeFlag = 0x01;
	MOVF       _intCounter+0, 0
	SUBLW      2
	BTFSC      STATUS+0, 0
	GOTO       L_readButtons24
	BSF        _flagB+0, 0
	GOTO       L_readButtons25
L_readButtons24:
;timerinterfaceihm.c,205 :: 		else encoderSWFlag = 0x01;
	BSF        _flagA+0, 5
L_readButtons25:
;timerinterfaceihm.c,207 :: 		}
L_readButtons22:
;timerinterfaceihm.c,209 :: 		if(encoderSWFlag && encoderSW) {
	BTFSS      _flagA+0, 5
	GOTO       L_readButtons28
	BTFSS      PORTA+0, 0
	GOTO       L_readButtons28
L__readButtons34:
;timerinterfaceihm.c,210 :: 		encoderPushButton = 0x01;
	BSF        _flagA+0, 6
;timerinterfaceihm.c,211 :: 		encoderSWFlag = 0x00;
	BCF        _flagA+0, 5
;timerinterfaceihm.c,212 :: 		intCounter = 0x00;
	CLRF       _intCounter+0
;timerinterfaceihm.c,213 :: 		}
L_readButtons28:
;timerinterfaceihm.c,215 :: 		if(activeFlag && encoderSW) {
	BTFSS      _flagB+0, 0
	GOTO       L_readButtons31
	BTFSS      PORTA+0, 0
	GOTO       L_readButtons31
L__readButtons33:
;timerinterfaceihm.c,216 :: 		active = ~active;
	MOVLW      128
	XORWF      _flagA+0, 1
;timerinterfaceihm.c,217 :: 		activeFlag = 0x00;
	BCF        _flagB+0, 0
;timerinterfaceihm.c,218 :: 		intCounter = 0x00;
	CLRF       _intCounter+0
;timerinterfaceihm.c,219 :: 		}
L_readButtons31:
;timerinterfaceihm.c,223 :: 		if(encoderPushButton) configureMode = ~configureMode;
	BTFSS      _flagA+0, 6
	GOTO       L_readButtons32
	MOVLW      2
	XORWF      _flagB+0, 1
L_readButtons32:
;timerinterfaceihm.c,224 :: 		}
L_end_readButtons:
	RETURN
; end of _readButtons
