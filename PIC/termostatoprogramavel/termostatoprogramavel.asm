
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;termostatoprogramavel.c,48 :: 		void interrupt() {
;termostatoprogramavel.c,49 :: 		if(TMR2IF_bit) {
	BTFSS      TMR2IF_bit+0, 1
	GOTO       L_interrupt0
;termostatoprogramavel.c,50 :: 		TMR2IF_bit = 0x00;
	BCF        TMR2IF_bit+0, 1
;termostatoprogramavel.c,51 :: 		myCounter01++;
	INCF       _myCounter01+0, 1
	BTFSC      STATUS+0, 2
	INCF       _myCounter01+1, 1
;termostatoprogramavel.c,52 :: 		testInterrupt =! testInterrupt;
	MOVLW      32
	XORWF      PORTB+0, 1
;termostatoprogramavel.c,53 :: 		}
L_interrupt0:
;termostatoprogramavel.c,54 :: 		}
L_end_interrupt:
L__interrupt34:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;termostatoprogramavel.c,57 :: 		void main() {
;termostatoprogramavel.c,58 :: 		configureMcu();
	CALL       _configureMcu+0
;termostatoprogramavel.c,59 :: 		while(1) {
L_main1:
;termostatoprogramavel.c,60 :: 		readButtons();
	CALL       _readButtons+0
;termostatoprogramavel.c,61 :: 		readTemperature();
	CALL       _readTemperature+0
;termostatoprogramavel.c,62 :: 		}
	GOTO       L_main1
;termostatoprogramavel.c,63 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;termostatoprogramavel.c,65 :: 		void configureMcu() {
;termostatoprogramavel.c,66 :: 		CMCON = 0x07; // Desabilita-se comparadores
	MOVLW      7
	MOVWF      CMCON+0
;termostatoprogramavel.c,67 :: 		TRISB0_bit = 0x00;  // Configura RB0 como saída
	BCF        TRISB0_bit+0, 0
;termostatoprogramavel.c,68 :: 		TRISB1_bit = 0x00;  // Configura RB1 como saída
	BCF        TRISB1_bit+0, 1
;termostatoprogramavel.c,69 :: 		TRISB3_bit = 0x01;  //Configura RB3 como entrada
	BSF        TRISB3_bit+0, 3
;termostatoprogramavel.c,70 :: 		TRISB4_bit = 0x01;  // Configura RB4 como entrada
	BSF        TRISB4_bit+0, 4
;termostatoprogramavel.c,71 :: 		TRISB5_bit = 0x00; //Configura RB5 como saída (testes da interrupção)
	BCF        TRISB5_bit+0, 5
;termostatoprogramavel.c,72 :: 		Soft_SPI_Init(); // Inicia-se software SPI
	CALL       _Soft_SPI_Init+0
;termostatoprogramavel.c,73 :: 		INTCON.GIE = 0x01; // Habilita-se interrupção global
	BSF        INTCON+0, 7
;termostatoprogramavel.c,74 :: 		INTCON.PEIE = 0x01; // Interrupção dos periféricos
	BSF        INTCON+0, 6
;termostatoprogramavel.c,75 :: 		TMR2IE_bit = 0x01; // Habilita interrupção no Timer 02
	BSF        TMR2IE_bit+0, 1
;termostatoprogramavel.c,76 :: 		T2CON = 0x78; // Timer 2 inicia desligado, postscaler 1:16, prescaler 1:1 (página 55 do datasheet PIC16F628A)
	MOVLW      120
	MOVWF      T2CON+0
;termostatoprogramavel.c,77 :: 		setEnable = 0x00;
	BCF        _flagButton+0, 4
;termostatoprogramavel.c,78 :: 		initDht11();
	CALL       _initDht11+0
;termostatoprogramavel.c,79 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu

_readTemperature:

;termostatoprogramavel.c,81 :: 		void readTemperature() {
;termostatoprogramavel.c,85 :: 		if(myButton01 || myButton02 || setEnable) {
	BTFSC      _flagButton+0, 2
	GOTO       L__readTemperature30
	BTFSC      _flagButton+0, 3
	GOTO       L__readTemperature30
	BTFSC      _flagButton+0, 4
	GOTO       L__readTemperature30
	GOTO       L_readTemperature5
L__readTemperature30:
;termostatoprogramavel.c,86 :: 		if(!setEnable) {
	BTFSC      _flagButton+0, 4
	GOTO       L_readTemperature6
;termostatoprogramavel.c,87 :: 		setEnable = 0x01;
	BSF        _flagButton+0, 4
;termostatoprogramavel.c,88 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,89 :: 		TMR2ON_bit = 0x01;
	BSF        TMR2ON_bit+0, 2
;termostatoprogramavel.c,90 :: 		}
L_readTemperature6:
;termostatoprogramavel.c,91 :: 		if(myCounter01 < 500)setEnable = 0x01;
	MOVLW      128
	XORWF      _myCounter01+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readTemperature38
	MOVLW      244
	SUBWF      _myCounter01+0, 0
L__readTemperature38:
	BTFSC      STATUS+0, 0
	GOTO       L_readTemperature7
	BSF        _flagButton+0, 4
	GOTO       L_readTemperature8
L_readTemperature7:
;termostatoprogramavel.c,93 :: 		setEnable = 0x00;
	BCF        _flagButton+0, 4
;termostatoprogramavel.c,94 :: 		TMR2ON_bit = 0x00;
	BCF        TMR2ON_bit+0, 2
;termostatoprogramavel.c,95 :: 		for(i = 0; i < 3; i++) {
	CLRF       readTemperature_i_L0+0
L_readTemperature9:
	MOVLW      3
	SUBWF      readTemperature_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_readTemperature10
;termostatoprogramavel.c,96 :: 		enable7seg01 = 0x00;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,97 :: 		enable7seg02 = 0x00;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,98 :: 		Soft_SPI_Write(0);
	CLRF       FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,99 :: 		enable7seg01 = 0x01;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,100 :: 		enable7seg02 = 0x01;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,101 :: 		delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_readTemperature12:
	DECFSZ     R13+0, 1
	GOTO       L_readTemperature12
	DECFSZ     R12+0, 1
	GOTO       L_readTemperature12
	DECFSZ     R11+0, 1
	GOTO       L_readTemperature12
;termostatoprogramavel.c,102 :: 		enable7seg01 = 0x00;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,103 :: 		enable7seg02 = 0x00;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,104 :: 		Soft_SPI_Write(255);
	MOVLW      255
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,105 :: 		enable7seg01 = 0x01;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,106 :: 		enable7seg02 = 0x01;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,107 :: 		delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_readTemperature13:
	DECFSZ     R13+0, 1
	GOTO       L_readTemperature13
	DECFSZ     R12+0, 1
	GOTO       L_readTemperature13
	DECFSZ     R11+0, 1
	GOTO       L_readTemperature13
;termostatoprogramavel.c,95 :: 		for(i = 0; i < 3; i++) {
	INCF       readTemperature_i_L0+0, 1
;termostatoprogramavel.c,108 :: 		}
	GOTO       L_readTemperature9
L_readTemperature10:
;termostatoprogramavel.c,109 :: 		}
L_readTemperature8:
;termostatoprogramavel.c,110 :: 		if(myButton01) {
	BTFSS      _flagButton+0, 2
	GOTO       L_readTemperature14
;termostatoprogramavel.c,111 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,112 :: 		if(setTemperature >= maxTemp) setTemperature = 40;
	MOVLW      40
	SUBWF      _setTemperature+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_readTemperature15
	MOVLW      40
	MOVWF      _setTemperature+0
	GOTO       L_readTemperature16
L_readTemperature15:
;termostatoprogramavel.c,113 :: 		else setTemperature++;
	INCF       _setTemperature+0, 1
L_readTemperature16:
;termostatoprogramavel.c,114 :: 		}
L_readTemperature14:
;termostatoprogramavel.c,116 :: 		if(myButton02) {
	BTFSS      _flagButton+0, 3
	GOTO       L_readTemperature17
;termostatoprogramavel.c,117 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,118 :: 		if(setTemperature <= minTemp) setTemperature = 1;
	MOVF       _setTemperature+0, 0
	SUBLW      1
	BTFSS      STATUS+0, 0
	GOTO       L_readTemperature18
	MOVLW      1
	MOVWF      _setTemperature+0
	GOTO       L_readTemperature19
L_readTemperature18:
;termostatoprogramavel.c,119 :: 		else setTemperature--;
	DECF       _setTemperature+0, 1
L_readTemperature19:
;termostatoprogramavel.c,120 :: 		}
L_readTemperature17:
;termostatoprogramavel.c,121 :: 		value = setTemperature * 100;
	MOVF       _setTemperature+0, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_value_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_value_L0+1
;termostatoprogramavel.c,122 :: 		}
	GOTO       L_readTemperature20
L_readTemperature5:
;termostatoprogramavel.c,125 :: 		temp = dht11(2);
	MOVLW      2
	MOVWF      FARG_dht11_type+0
	CALL       _dht11+0
;termostatoprogramavel.c,126 :: 		value = temp;
	MOVF       R0+0, 0
	MOVWF      readTemperature_value_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_value_L0+1
;termostatoprogramavel.c,127 :: 		}
L_readTemperature20:
;termostatoprogramavel.c,128 :: 		value = value / 100;
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       readTemperature_value_L0+0, 0
	MOVWF      R0+0
	MOVF       readTemperature_value_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_value_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_value_L0+1
;termostatoprogramavel.c,129 :: 		digit02 = value / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,130 :: 		digit01 = value % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       readTemperature_value_L0+0, 0
	MOVWF      R0+0
	MOVF       readTemperature_value_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit01_L0+0
;termostatoprogramavel.c,131 :: 		digit02 = bcdData(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,132 :: 		digit01 = bcdData(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit01_L0+0
;termostatoprogramavel.c,135 :: 		enable7seg01 = 0;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,136 :: 		Soft_SPI_Write(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,137 :: 		enable7seg01 = 1;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,139 :: 		enable7seg02 = 0;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,140 :: 		Soft_SPI_Write(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,141 :: 		enable7seg02 = 1;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,142 :: 		myButton01 = 0x00;
	BCF        _flagButton+0, 2
;termostatoprogramavel.c,143 :: 		myButton02 = 0x00;
	BCF        _flagButton+0, 3
;termostatoprogramavel.c,144 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_readTemperature21:
	DECFSZ     R13+0, 1
	GOTO       L_readTemperature21
	DECFSZ     R12+0, 1
	GOTO       L_readTemperature21
	DECFSZ     R11+0, 1
	GOTO       L_readTemperature21
	NOP
;termostatoprogramavel.c,145 :: 		}
L_end_readTemperature:
	RETURN
; end of _readTemperature

_readButtons:

;termostatoprogramavel.c,147 :: 		void readButtons() {
;termostatoprogramavel.c,148 :: 		if(button01) flagButton01 = 0x01;
	BTFSS      PORTB+0, 3
	GOTO       L_readButtons22
	BSF        _flagButton+0, 0
L_readButtons22:
;termostatoprogramavel.c,149 :: 		if(!button01 && flagButton01) {
	BTFSC      PORTB+0, 3
	GOTO       L_readButtons25
	BTFSS      _flagButton+0, 0
	GOTO       L_readButtons25
L__readButtons32:
;termostatoprogramavel.c,150 :: 		myButton01 = 0x01;
	BSF        _flagButton+0, 2
;termostatoprogramavel.c,151 :: 		flagButton01 = 0x00;
	BCF        _flagButton+0, 0
;termostatoprogramavel.c,152 :: 		}
L_readButtons25:
;termostatoprogramavel.c,154 :: 		if(button02) flagButton02 = 0x01;
	BTFSS      PORTB+0, 4
	GOTO       L_readButtons26
	BSF        _flagButton+0, 1
L_readButtons26:
;termostatoprogramavel.c,155 :: 		if(!button02 && flagButton02) {
	BTFSC      PORTB+0, 4
	GOTO       L_readButtons29
	BTFSS      _flagButton+0, 1
	GOTO       L_readButtons29
L__readButtons31:
;termostatoprogramavel.c,156 :: 		myButton02 = 0x01;
	BSF        _flagButton+0, 3
;termostatoprogramavel.c,157 :: 		flagButton02 = 0x00;
	BCF        _flagButton+0, 1
;termostatoprogramavel.c,158 :: 		}
L_readButtons29:
;termostatoprogramavel.c,159 :: 		}
L_end_readButtons:
	RETURN
; end of _readButtons
