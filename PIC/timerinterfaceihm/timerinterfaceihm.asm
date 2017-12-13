
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;timerinterfaceihm.c,49 :: 		void interrupt() {
;timerinterfaceihm.c,50 :: 		if(TMR2IF_bit) {
	BTFSS      TMR2IF_bit+0, 1
	GOTO       L_interrupt0
;timerinterfaceihm.c,51 :: 		TMR2IF_bit = 0x00;
	BCF        TMR2IF_bit+0, 1
;timerinterfaceihm.c,52 :: 		tmr02Trigger = ~tmr02Trigger;
	MOVLW      1
	XORWF      _flags+0, 1
;timerinterfaceihm.c,53 :: 		if(tmr02Trigger) {
	BTFSS      _flags+0, 0
	GOTO       L_interrupt1
;timerinterfaceihm.c,54 :: 		tmr02Counter++;
	INCF       _tmr02Counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tmr02Counter+1, 1
;timerinterfaceihm.c,55 :: 		if(tmr02Counter == 490) {
	MOVF       _tmr02Counter+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt10
	MOVLW      234
	XORWF      _tmr02Counter+0, 0
L__interrupt10:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;timerinterfaceihm.c,56 :: 		oneSecond = ~oneSecond;
	MOVLW      2
	XORWF      _flags+0, 1
;timerinterfaceihm.c,57 :: 		tmr02Counter = 0;
	CLRF       _tmr02Counter+0
	CLRF       _tmr02Counter+1
;timerinterfaceihm.c,58 :: 		}
L_interrupt2:
;timerinterfaceihm.c,59 :: 		}
L_interrupt1:
;timerinterfaceihm.c,60 :: 		}
L_interrupt0:
;timerinterfaceihm.c,61 :: 		}
L_end_interrupt:
L__interrupt9:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;timerinterfaceihm.c,63 :: 		void main() {
;timerinterfaceihm.c,64 :: 		configureMcu();
	CALL       _configureMcu+0
;timerinterfaceihm.c,65 :: 		initDisplay();
	CALL       _initDisplay+0
;timerinterfaceihm.c,66 :: 		while(1) {
L_main3:
;timerinterfaceihm.c,67 :: 		TMR2ON_bit = 0x01;
	BSF        TMR2ON_bit+0, 2
;timerinterfaceihm.c,68 :: 		display();
	CALL       _display+0
;timerinterfaceihm.c,69 :: 		if(oneSecond) {
	BTFSS      _flags+0, 1
	GOTO       L_main5
;timerinterfaceihm.c,70 :: 		myTimer++;
	INCF       _myTimer+0, 1
	BTFSC      STATUS+0, 2
	INCF       _myTimer+1, 1
;timerinterfaceihm.c,71 :: 		oneSecond = 0;
	BCF        _flags+0, 1
;timerinterfaceihm.c,72 :: 		}
L_main5:
;timerinterfaceihm.c,73 :: 		}
	GOTO       L_main3
;timerinterfaceihm.c,74 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;timerinterfaceihm.c,76 :: 		void configureMcu() {
;timerinterfaceihm.c,77 :: 		CMCON = 0x07;       // Desabilita comparadores
	MOVLW      7
	MOVWF      CMCON+0
;timerinterfaceihm.c,78 :: 		TRISB0_bit = 0x00;  // RB0 como saída
	BCF        TRISB0_bit+0, 0
;timerinterfaceihm.c,79 :: 		INTCON.GIE = 0x01;  // Habilita interrupção global
	BSF        INTCON+0, 7
;timerinterfaceihm.c,80 :: 		INTCON.PEIE = 0x01; // Habilita interrupção de periféricos
	BSF        INTCON+0, 6
;timerinterfaceihm.c,81 :: 		TMR2IE_bit = 0X01;  // Habilita interrupção do TMR2
	BSF        TMR2IE_bit+0, 1
;timerinterfaceihm.c,82 :: 		T2CON = 0x01;       // Config TMR2 Postscaler 1 Prescaler 4, timer desabilitado
	MOVLW      1
	MOVWF      T2CON+0
;timerinterfaceihm.c,83 :: 		PR2 =  pr2Value;    // Atribui a PR2 o valor da variavel pr2Value
	MOVF       _pr2Value+0, 0
	MOVWF      PR2+0
;timerinterfaceihm.c,84 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu

_initDisplay:

;timerinterfaceihm.c,86 :: 		void initDisplay() {
;timerinterfaceihm.c,87 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;timerinterfaceihm.c,88 :: 		Lcd_CMD(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;timerinterfaceihm.c,89 :: 		Lcd_CMD(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;timerinterfaceihm.c,90 :: 		}
L_end_initDisplay:
	RETURN
; end of _initDisplay

_display:

;timerinterfaceihm.c,92 :: 		void display() {
;timerinterfaceihm.c,100 :: 		hour = (myTimer / 60) / 60;    // Obtem valor hora
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _myTimer+0, 0
	MOVWF      R0+0
	MOVF       _myTimer+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      display_hour_L0+0
;timerinterfaceihm.c,101 :: 		minute = (myTimer - (hour * 3600)) / 60; // Resto da hora minutos
	MOVLW      0
	MOVWF      R0+1
	MOVLW      16
	MOVWF      R4+0
	MOVLW      14
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	SUBWF      _myTimer+0, 0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _myTimer+1, 0
	MOVWF      R0+1
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      display_minute_L0+0
;timerinterfaceihm.c,103 :: 		if(myTimer > 59) second = myTimer - (minute * 60 + hour * 3600); // Resto de minutos segundos
	MOVF       _myTimer+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__display15
	MOVF       _myTimer+0, 0
	SUBLW      59
L__display15:
	BTFSC      STATUS+0, 0
	GOTO       L_display6
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
	SUBWF      _myTimer+0, 0
	MOVWF      display_second_L0+0
	GOTO       L_display7
L_display6:
;timerinterfaceihm.c,105 :: 		second = myTimer;
	MOVF       _myTimer+0, 0
	MOVWF      display_second_L0+0
;timerinterfaceihm.c,106 :: 		minute = 0;
	CLRF       display_minute_L0+0
;timerinterfaceihm.c,107 :: 		hour = 0;
	CLRF       display_hour_L0+0
;timerinterfaceihm.c,108 :: 		}
L_display7:
;timerinterfaceihm.c,111 :: 		time[0] = hour / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_hour_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+0
;timerinterfaceihm.c,112 :: 		time[1] = hour % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_hour_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+1
;timerinterfaceihm.c,113 :: 		time[2] = minute / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_minute_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+2
;timerinterfaceihm.c,114 :: 		time[3] = minute % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_minute_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+3
;timerinterfaceihm.c,115 :: 		time[4] = second / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_second_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+4
;timerinterfaceihm.c,116 :: 		time[5] = second % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       display_second_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      display_time_L0+5
;timerinterfaceihm.c,120 :: 		lcd_chr(1, 5, time[0] + 48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      display_time_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;timerinterfaceihm.c,121 :: 		lcd_chr_cp(time[1] + 48);
	MOVLW      48
	ADDWF      display_time_L0+1, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,122 :: 		lcd_chr_cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,123 :: 		lcd_chr_cp(time[2] + 48);
	MOVLW      48
	ADDWF      display_time_L0+2, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,124 :: 		lcd_chr_cp(time[3] + 48);
	MOVLW      48
	ADDWF      display_time_L0+3, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,125 :: 		lcd_chr_cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,126 :: 		lcd_chr_cp(time[4] + 48);
	MOVLW      48
	ADDWF      display_time_L0+4, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,127 :: 		lcd_chr_cp(time[5] + 48);
	MOVLW      48
	ADDWF      display_time_L0+5, 0
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;timerinterfaceihm.c,128 :: 		}
L_end_display:
	RETURN
; end of _display
