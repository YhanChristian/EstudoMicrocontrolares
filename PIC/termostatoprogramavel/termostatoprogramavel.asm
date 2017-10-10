
_main:

;termostatoprogramavel.c,27 :: 		void main() {
;termostatoprogramavel.c,29 :: 		configureMcu();
	CALL       _configureMcu+0
;termostatoprogramavel.c,30 :: 		while(1) {
L_main0:
;termostatoprogramavel.c,31 :: 		for(counter = 0; counter < 100; counter ++) {
	CLRF       main_counter_L0+0
L_main2:
	MOVLW      100
	SUBWF      main_counter_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main3
;termostatoprogramavel.c,33 :: 		digit02 = counter / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       main_counter_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      main_digit02_L0+0
;termostatoprogramavel.c,34 :: 		digit01 = counter % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       main_counter_L0+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      main_digit01_L0+0
;termostatoprogramavel.c,35 :: 		digit02 = bcdData(digit02);
	MOVF       main_digit02_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      main_digit02_L0+0
;termostatoprogramavel.c,36 :: 		digit01 = bcdData(digit01);
	MOVF       main_digit01_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      main_digit01_L0+0
;termostatoprogramavel.c,39 :: 		enable7seg01 = 0;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,40 :: 		Soft_SPI_Write(digit02);
	MOVF       main_digit02_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,41 :: 		enable7seg01 = 1;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,44 :: 		enable7seg02 = 0;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,45 :: 		Soft_SPI_Write(digit01);
	MOVF       main_digit01_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,46 :: 		enable7seg02 = 1;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,48 :: 		delay_ms(200);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
;termostatoprogramavel.c,31 :: 		for(counter = 0; counter < 100; counter ++) {
	INCF       main_counter_L0+0, 1
;termostatoprogramavel.c,49 :: 		}
	GOTO       L_main2
L_main3:
;termostatoprogramavel.c,50 :: 		counter = 0;
	CLRF       main_counter_L0+0
;termostatoprogramavel.c,51 :: 		}
	GOTO       L_main0
;termostatoprogramavel.c,52 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;termostatoprogramavel.c,54 :: 		void configureMcu() {
;termostatoprogramavel.c,55 :: 		CMCON = 0x07; // Desabilita-se comparadores
	MOVLW      7
	MOVWF      CMCON+0
;termostatoprogramavel.c,56 :: 		TRISB = 0x0D; // Configura-se RB0 e RB1 como saída
	MOVLW      13
	MOVWF      TRISB+0
;termostatoprogramavel.c,57 :: 		Soft_SPI_Init(); // Inicia-se software SPI
	CALL       _Soft_SPI_Init+0
;termostatoprogramavel.c,58 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu
