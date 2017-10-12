
_main:

;termostatoprogramavel.c,29 :: 		void main() {
;termostatoprogramavel.c,30 :: 		configureMcu();
	CALL       _configureMcu+0
;termostatoprogramavel.c,31 :: 		while(1) {
L_main0:
;termostatoprogramavel.c,32 :: 		readTemperature();
	CALL       _readTemperature+0
;termostatoprogramavel.c,33 :: 		delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
;termostatoprogramavel.c,34 :: 		}
	GOTO       L_main0
;termostatoprogramavel.c,35 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;termostatoprogramavel.c,37 :: 		void configureMcu() {
;termostatoprogramavel.c,38 :: 		CMCON = 0x07; // Desabilita-se comparadores
	MOVLW      7
	MOVWF      CMCON+0
;termostatoprogramavel.c,39 :: 		TRISB0_bit = 0;  // Configura RB0 como saída
	BCF        TRISB0_bit+0, 0
;termostatoprogramavel.c,40 :: 		TRISB1_bit = 0;  // Configura RB1 como saída
	BCF        TRISB1_bit+0, 1
;termostatoprogramavel.c,41 :: 		Soft_SPI_Init(); // Inicia-se software SPI
	CALL       _Soft_SPI_Init+0
;termostatoprogramavel.c,42 :: 		initDht11();
	CALL       _initDht11+0
;termostatoprogramavel.c,43 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu

_readTemperature:

;termostatoprogramavel.c,45 :: 		void readTemperature() {
;termostatoprogramavel.c,48 :: 		temp = dht11(2);
	MOVLW      2
	MOVWF      FARG_dht11_type+0
	CALL       _dht11+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_temp_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_temp_L0+1
;termostatoprogramavel.c,49 :: 		temp = temp / 100;
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_temp_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_temp_L0+1
;termostatoprogramavel.c,50 :: 		digit02 = temp / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,51 :: 		digit01 = temp % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       readTemperature_temp_L0+0, 0
	MOVWF      R0+0
	MOVF       readTemperature_temp_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit01_L0+0
;termostatoprogramavel.c,52 :: 		digit02 = bcdData(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,53 :: 		digit01 = bcdData(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit01_L0+0
;termostatoprogramavel.c,56 :: 		enable7seg01 = 0;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,57 :: 		Soft_SPI_Write(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,58 :: 		enable7seg01 = 1;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,60 :: 		enable7seg02 = 0;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,61 :: 		Soft_SPI_Write(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,62 :: 		enable7seg02 = 1;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,63 :: 		}
L_end_readTemperature:
	RETURN
; end of _readTemperature
