
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;termostatoprogramavel.c,45 :: 		void interrupt() {
;termostatoprogramavel.c,46 :: 		if(TMR2IF_bit) {
	BTFSS      TMR2IF_bit+0, 1
	GOTO       L_interrupt0
;termostatoprogramavel.c,47 :: 		TMR2IF_bit = 0x00;
	BCF        TMR2IF_bit+0, 1
;termostatoprogramavel.c,48 :: 		myCounter01++;
	INCF       _myCounter01+0, 1
	BTFSC      STATUS+0, 2
	INCF       _myCounter01+1, 1
;termostatoprogramavel.c,49 :: 		testInterrupt =! testInterrupt;
	MOVLW      32
	XORWF      PORTB+0, 1
;termostatoprogramavel.c,50 :: 		}
L_interrupt0:
;termostatoprogramavel.c,51 :: 		}
L_end_interrupt:
L__interrupt33:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;termostatoprogramavel.c,54 :: 		void main() {
;termostatoprogramavel.c,55 :: 		configureMcu();
	CALL       _configureMcu+0
;termostatoprogramavel.c,56 :: 		while(1) {
L_main1:
;termostatoprogramavel.c,57 :: 		readTemperature();
	CALL       _readTemperature+0
;termostatoprogramavel.c,58 :: 		delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
;termostatoprogramavel.c,59 :: 		}
	GOTO       L_main1
;termostatoprogramavel.c,60 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;termostatoprogramavel.c,62 :: 		void configureMcu() {
;termostatoprogramavel.c,63 :: 		CMCON = 0x07; // Desabilita-se comparadores
	MOVLW      7
	MOVWF      CMCON+0
;termostatoprogramavel.c,64 :: 		TRISB0_bit = 0x00;  // Configura RB0 como saída
	BCF        TRISB0_bit+0, 0
;termostatoprogramavel.c,65 :: 		TRISB1_bit = 0x00;  // Configura RB1 como saída
	BCF        TRISB1_bit+0, 1
;termostatoprogramavel.c,66 :: 		TRISB3_bit = 0x01;  //Configura RB3 como entrada
	BSF        TRISB3_bit+0, 3
;termostatoprogramavel.c,67 :: 		TRISB4_bit = 0x01;  // Configura RB4 como entrada
	BSF        TRISB4_bit+0, 4
;termostatoprogramavel.c,68 :: 		TRISB5_bit = 0x00; //Configura RB5 como saída (testes da interrupção)
	BCF        TRISB5_bit+0, 5
;termostatoprogramavel.c,69 :: 		Soft_SPI_Init(); // Inicia-se software SPI
	CALL       _Soft_SPI_Init+0
;termostatoprogramavel.c,70 :: 		INTCON.GIE = 0x01; // Habilita-se interrupção global
	BSF        INTCON+0, 7
;termostatoprogramavel.c,71 :: 		INTCON.PEIE = 0x01; // Interrupção dos periféricos
	BSF        INTCON+0, 6
;termostatoprogramavel.c,72 :: 		TMR2IE_bit = 0x01; // Habilita interrupção no Timer 02
	BSF        TMR2IE_bit+0, 1
;termostatoprogramavel.c,73 :: 		T2CON = 0x78; // Timer 2 inicia desligado, postscaler 1:16, prescaler 1:1 (página 55 do datasheet PIC16F628A)
	MOVLW      120
	MOVWF      T2CON+0
;termostatoprogramavel.c,74 :: 		setEnable = 0x00;
	BCF        _flagButton+0, 4
;termostatoprogramavel.c,75 :: 		initDht11();
	CALL       _initDht11+0
;termostatoprogramavel.c,76 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu

_readTemperature:

;termostatoprogramavel.c,78 :: 		void readTemperature() {
;termostatoprogramavel.c,81 :: 		setupTemperature();
	CALL       _setupTemperature+0
;termostatoprogramavel.c,82 :: 		temp = dht11(2);
	MOVLW      2
	MOVWF      FARG_dht11_type+0
	CALL       _dht11+0
;termostatoprogramavel.c,83 :: 		value = temp;
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
;termostatoprogramavel.c,84 :: 		value = value / 100;
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
;termostatoprogramavel.c,85 :: 		digit02 = value / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,86 :: 		digit01 = value % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _value+0, 0
	MOVWF      R0+0
	MOVF       _value+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit01_L0+0
;termostatoprogramavel.c,87 :: 		digit02 = bcdData(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,88 :: 		digit01 = bcdData(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit01_L0+0
;termostatoprogramavel.c,91 :: 		enable7seg01 = 0;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,92 :: 		Soft_SPI_Write(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,93 :: 		enable7seg01 = 1;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,95 :: 		enable7seg02 = 0;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,96 :: 		Soft_SPI_Write(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,97 :: 		enable7seg02 = 1;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,98 :: 		}
L_end_readTemperature:
	RETURN
; end of _readTemperature

_setupTemperature:

;termostatoprogramavel.c,101 :: 		void setupTemperature() {
;termostatoprogramavel.c,103 :: 		if (myButton01 || myButton02 ||  setEnable) {
	BTFSC      _flagButton+0, 2
	GOTO       L__setupTemperature29
	BTFSC      _flagButton+0, 3
	GOTO       L__setupTemperature29
	BTFSC      _flagButton+0, 4
	GOTO       L__setupTemperature29
	GOTO       L_setupTemperature6
L__setupTemperature29:
;termostatoprogramavel.c,104 :: 		if(!setEnable) {
	BTFSC      _flagButton+0, 4
	GOTO       L_setupTemperature7
;termostatoprogramavel.c,105 :: 		setEnable = 0x01;
	BSF        _flagButton+0, 4
;termostatoprogramavel.c,106 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,107 :: 		TMR2ON_bit = 0x01;
	BSF        TMR2ON_bit+0, 2
;termostatoprogramavel.c,108 :: 		}
L_setupTemperature7:
;termostatoprogramavel.c,110 :: 		if(myCounter01 < 500) setEnable = 0x01;
	MOVLW      128
	XORWF      _myCounter01+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__setupTemperature38
	MOVLW      244
	SUBWF      _myCounter01+0, 0
L__setupTemperature38:
	BTFSC      STATUS+0, 0
	GOTO       L_setupTemperature8
	BSF        _flagButton+0, 4
	GOTO       L_setupTemperature9
L_setupTemperature8:
;termostatoprogramavel.c,112 :: 		setEnable = 0x00;
	BCF        _flagButton+0, 4
;termostatoprogramavel.c,113 :: 		TMR2ON_bit = 0x00;
	BCF        TMR2ON_bit+0, 2
;termostatoprogramavel.c,114 :: 		}
L_setupTemperature9:
;termostatoprogramavel.c,116 :: 		for (i = 0; i < 3; i++) {
	CLRF       setupTemperature_i_L0+0
L_setupTemperature10:
	MOVLW      3
	SUBWF      setupTemperature_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_setupTemperature11
;termostatoprogramavel.c,117 :: 		enable7seg01 = 0x00;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,118 :: 		enable7seg02 = 0x00;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,119 :: 		Soft_SPI_Write(0);
	CLRF       FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,120 :: 		enable7seg01 = 0x01;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,121 :: 		enable7seg02 = 0x01;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,122 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_setupTemperature13:
	DECFSZ     R13+0, 1
	GOTO       L_setupTemperature13
	DECFSZ     R12+0, 1
	GOTO       L_setupTemperature13
	DECFSZ     R11+0, 1
	GOTO       L_setupTemperature13
	NOP
	NOP
;termostatoprogramavel.c,123 :: 		enable7seg01 = 0x00;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,124 :: 		enable7seg02 = 0x00;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,125 :: 		Soft_SPI_Write(255);
	MOVLW      255
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,126 :: 		enable7seg01 = 0x01;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,127 :: 		enable7seg02 = 0x01;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,128 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_setupTemperature14:
	DECFSZ     R13+0, 1
	GOTO       L_setupTemperature14
	DECFSZ     R12+0, 1
	GOTO       L_setupTemperature14
	DECFSZ     R11+0, 1
	GOTO       L_setupTemperature14
	NOP
	NOP
;termostatoprogramavel.c,116 :: 		for (i = 0; i < 3; i++) {
	INCF       setupTemperature_i_L0+0, 1
;termostatoprogramavel.c,129 :: 		}
	GOTO       L_setupTemperature10
L_setupTemperature11:
;termostatoprogramavel.c,130 :: 		}
L_setupTemperature6:
;termostatoprogramavel.c,131 :: 		if(myButton01) {
	BTFSS      _flagButton+0, 2
	GOTO       L_setupTemperature15
;termostatoprogramavel.c,132 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,133 :: 		if(setTemperature > 40) setTemperature = 40;
	MOVF       setupTemperature_setTemperature_L0+0, 0
	SUBLW      40
	BTFSC      STATUS+0, 0
	GOTO       L_setupTemperature16
	MOVLW      40
	MOVWF      setupTemperature_setTemperature_L0+0
	GOTO       L_setupTemperature17
L_setupTemperature16:
;termostatoprogramavel.c,134 :: 		else setTemperature++;
	INCF       setupTemperature_setTemperature_L0+0, 1
L_setupTemperature17:
;termostatoprogramavel.c,135 :: 		}
L_setupTemperature15:
;termostatoprogramavel.c,137 :: 		if(myButton02) {
	BTFSS      _flagButton+0, 3
	GOTO       L_setupTemperature18
;termostatoprogramavel.c,138 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,139 :: 		if(setTemperature < 1) setTemperature = 1;
	MOVLW      1
	SUBWF      setupTemperature_setTemperature_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_setupTemperature19
	MOVLW      1
	MOVWF      setupTemperature_setTemperature_L0+0
	GOTO       L_setupTemperature20
L_setupTemperature19:
;termostatoprogramavel.c,140 :: 		else setTemperature--;
	DECF       setupTemperature_setTemperature_L0+0, 1
L_setupTemperature20:
;termostatoprogramavel.c,141 :: 		}
L_setupTemperature18:
;termostatoprogramavel.c,143 :: 		value = setTemperature * 100;
	MOVF       setupTemperature_setTemperature_L0+0, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
;termostatoprogramavel.c,144 :: 		}
L_end_setupTemperature:
	RETURN
; end of _setupTemperature

_readButtons:

;termostatoprogramavel.c,147 :: 		void readButtons() {
;termostatoprogramavel.c,148 :: 		if(button01) flagButton01 = 0x01;
	BTFSS      PORTB+0, 3
	GOTO       L_readButtons21
	BSF        _flagButton+0, 0
L_readButtons21:
;termostatoprogramavel.c,149 :: 		if(!button01 && flagButton01) {
	BTFSC      PORTB+0, 3
	GOTO       L_readButtons24
	BTFSS      _flagButton+0, 0
	GOTO       L_readButtons24
L__readButtons31:
;termostatoprogramavel.c,150 :: 		myButton01 = 0x01;
	BSF        _flagButton+0, 2
;termostatoprogramavel.c,151 :: 		flagButton01 = 0x00;
	BCF        _flagButton+0, 0
;termostatoprogramavel.c,152 :: 		}
L_readButtons24:
;termostatoprogramavel.c,154 :: 		if(button02) flagButton02 = 0x01;
	BTFSS      PORTB+0, 4
	GOTO       L_readButtons25
	BSF        _flagButton+0, 1
L_readButtons25:
;termostatoprogramavel.c,155 :: 		if(!button02 && flagButton02) {
	BTFSC      PORTB+0, 4
	GOTO       L_readButtons28
	BTFSS      _flagButton+0, 1
	GOTO       L_readButtons28
L__readButtons30:
;termostatoprogramavel.c,156 :: 		myButton02 = 0x01;
	BSF        _flagButton+0, 3
;termostatoprogramavel.c,157 :: 		flagButton02 = 0x00;
	BCF        _flagButton+0, 1
;termostatoprogramavel.c,158 :: 		}
L_readButtons28:
;termostatoprogramavel.c,159 :: 		}
L_end_readButtons:
	RETURN
; end of _readButtons
