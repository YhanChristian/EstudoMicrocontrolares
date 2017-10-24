
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;termostatoprogramavel.c,51 :: 		void interrupt() {
;termostatoprogramavel.c,52 :: 		if(TMR2IF_bit) {
	BTFSS      TMR2IF_bit+0, 1
	GOTO       L_interrupt0
;termostatoprogramavel.c,53 :: 		TMR2IF_bit = 0x00;
	BCF        TMR2IF_bit+0, 1
;termostatoprogramavel.c,54 :: 		myCounter01++;
	INCF       _myCounter01+0, 1
	BTFSC      STATUS+0, 2
	INCF       _myCounter01+1, 1
;termostatoprogramavel.c,55 :: 		}
L_interrupt0:
;termostatoprogramavel.c,56 :: 		}
L_end_interrupt:
L__interrupt37:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;termostatoprogramavel.c,59 :: 		void main() {
;termostatoprogramavel.c,60 :: 		configureMcu();
	CALL       _configureMcu+0
;termostatoprogramavel.c,61 :: 		while(1) {
L_main1:
;termostatoprogramavel.c,62 :: 		readButtons();
	CALL       _readButtons+0
;termostatoprogramavel.c,63 :: 		readTemperature();
	CALL       _readTemperature+0
;termostatoprogramavel.c,64 :: 		}
	GOTO       L_main1
;termostatoprogramavel.c,65 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;termostatoprogramavel.c,67 :: 		void configureMcu() {
;termostatoprogramavel.c,68 :: 		CMCON = 0x07; // Desabilita-se comparadores
	MOVLW      7
	MOVWF      CMCON+0
;termostatoprogramavel.c,69 :: 		TRISB0_bit = 0x00;  // Configura RB0 como saída
	BCF        TRISB0_bit+0, 0
;termostatoprogramavel.c,70 :: 		TRISB1_bit = 0x00;  // Configura RB1 como saída
	BCF        TRISB1_bit+0, 1
;termostatoprogramavel.c,71 :: 		TRISB3_bit = 0x01;  //Configura RB3 como entrada
	BSF        TRISB3_bit+0, 3
;termostatoprogramavel.c,72 :: 		TRISB4_bit = 0x01;  // Configura RB4 como entrada
	BSF        TRISB4_bit+0, 4
;termostatoprogramavel.c,73 :: 		TRISB5_bit = 0x00; //Configura RB5 como saída
	BCF        TRISB5_bit+0, 5
;termostatoprogramavel.c,74 :: 		Soft_SPI_Init(); // Inicia-se software SPI
	CALL       _Soft_SPI_Init+0
;termostatoprogramavel.c,75 :: 		INTCON.GIE = 0x01; // Habilita-se interrupção global
	BSF        INTCON+0, 7
;termostatoprogramavel.c,76 :: 		INTCON.PEIE = 0x01; // Interrupção dos periféricos
	BSF        INTCON+0, 6
;termostatoprogramavel.c,77 :: 		TMR2IE_bit = 0x01; // Habilita interrupção no Timer 02
	BSF        TMR2IE_bit+0, 1
;termostatoprogramavel.c,78 :: 		T2CON = 0x78; // Timer 2 inicia desligado, postscaler 1:16, prescaler 1:1 (página 55 do datasheet PIC16F628A)
	MOVLW      120
	MOVWF      T2CON+0
;termostatoprogramavel.c,79 :: 		setEnable = 0x00;
	BCF        _flags+0, 4
;termostatoprogramavel.c,80 :: 		output = 0x00;
	BCF        PORTB+0, 5
;termostatoprogramavel.c,81 :: 		initDht11();
	CALL       _initDht11+0
;termostatoprogramavel.c,82 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu

_readTemperature:

;termostatoprogramavel.c,84 :: 		void readTemperature() {
;termostatoprogramavel.c,88 :: 		if(myButton01 || myButton02 || setEnable) {
	BTFSC      _flags+0, 2
	GOTO       L__readTemperature33
	BTFSC      _flags+0, 3
	GOTO       L__readTemperature33
	BTFSC      _flags+0, 4
	GOTO       L__readTemperature33
	GOTO       L_readTemperature5
L__readTemperature33:
;termostatoprogramavel.c,89 :: 		if(!setEnable) {
	BTFSC      _flags+0, 4
	GOTO       L_readTemperature6
;termostatoprogramavel.c,90 :: 		setEnable = 0x01;
	BSF        _flags+0, 4
;termostatoprogramavel.c,91 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,92 :: 		TMR2ON_bit = 0x01;
	BSF        TMR2ON_bit+0, 2
;termostatoprogramavel.c,93 :: 		}
L_readTemperature6:
;termostatoprogramavel.c,94 :: 		if(myCounter01 < 500)setEnable = 0x01;
	MOVLW      128
	XORWF      _myCounter01+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      1
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readTemperature41
	MOVLW      244
	SUBWF      _myCounter01+0, 0
L__readTemperature41:
	BTFSC      STATUS+0, 0
	GOTO       L_readTemperature7
	BSF        _flags+0, 4
	GOTO       L_readTemperature8
L_readTemperature7:
;termostatoprogramavel.c,96 :: 		setEnable = 0x00;
	BCF        _flags+0, 4
;termostatoprogramavel.c,97 :: 		TMR2ON_bit = 0x00;
	BCF        TMR2ON_bit+0, 2
;termostatoprogramavel.c,98 :: 		for(i = 0; i < 3; i++) {
	CLRF       readTemperature_i_L0+0
L_readTemperature9:
	MOVLW      3
	SUBWF      readTemperature_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_readTemperature10
;termostatoprogramavel.c,99 :: 		enable7seg01 = 0x00;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,100 :: 		enable7seg02 = 0x00;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,101 :: 		Soft_SPI_Write(0);
	CLRF       FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,102 :: 		enable7seg01 = 0x01;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,103 :: 		enable7seg02 = 0x01;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,104 :: 		delay_ms(400);
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
;termostatoprogramavel.c,105 :: 		enable7seg01 = 0x00;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,106 :: 		enable7seg02 = 0x00;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,107 :: 		Soft_SPI_Write(255);
	MOVLW      255
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,108 :: 		enable7seg01 = 0x01;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,109 :: 		enable7seg02 = 0x01;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,110 :: 		delay_ms(400);
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
;termostatoprogramavel.c,98 :: 		for(i = 0; i < 3; i++) {
	INCF       readTemperature_i_L0+0, 1
;termostatoprogramavel.c,111 :: 		}
	GOTO       L_readTemperature9
L_readTemperature10:
;termostatoprogramavel.c,112 :: 		}
L_readTemperature8:
;termostatoprogramavel.c,113 :: 		if(myButton01) {
	BTFSS      _flags+0, 2
	GOTO       L_readTemperature14
;termostatoprogramavel.c,114 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,115 :: 		if(setTemperature >= maxTemp) setTemperature = maxTemp;
	MOVLW      40
	SUBWF      _setTemperature+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_readTemperature15
	MOVLW      40
	MOVWF      _setTemperature+0
	GOTO       L_readTemperature16
L_readTemperature15:
;termostatoprogramavel.c,116 :: 		else setTemperature++;
	INCF       _setTemperature+0, 1
L_readTemperature16:
;termostatoprogramavel.c,117 :: 		}
L_readTemperature14:
;termostatoprogramavel.c,119 :: 		if(myButton02) {
	BTFSS      _flags+0, 3
	GOTO       L_readTemperature17
;termostatoprogramavel.c,120 :: 		myCounter01 = 0x00;
	CLRF       _myCounter01+0
	CLRF       _myCounter01+1
;termostatoprogramavel.c,121 :: 		if(setTemperature <= minTemp) setTemperature = minTemp;
	MOVF       _setTemperature+0, 0
	SUBLW      1
	BTFSS      STATUS+0, 0
	GOTO       L_readTemperature18
	MOVLW      1
	MOVWF      _setTemperature+0
	GOTO       L_readTemperature19
L_readTemperature18:
;termostatoprogramavel.c,122 :: 		else setTemperature--;
	DECF       _setTemperature+0, 1
L_readTemperature19:
;termostatoprogramavel.c,123 :: 		}
L_readTemperature17:
;termostatoprogramavel.c,124 :: 		value = setTemperature * 100;
	MOVF       _setTemperature+0, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_value_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_value_L0+1
;termostatoprogramavel.c,125 :: 		}
	GOTO       L_readTemperature20
L_readTemperature5:
;termostatoprogramavel.c,128 :: 		temp = dht11(2);
	MOVLW      2
	MOVWF      FARG_dht11_type+0
	CALL       _dht11+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_temp_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_temp_L0+1
;termostatoprogramavel.c,129 :: 		value = temp;
	MOVF       R0+0, 0
	MOVWF      readTemperature_value_L0+0
	MOVF       R0+1, 0
	MOVWF      readTemperature_value_L0+1
;termostatoprogramavel.c,131 :: 		adjustMode = 0x00;
	BCF        _flags+0, 5
;termostatoprogramavel.c,132 :: 		adjustTemperature(setTemperature * 100, temp, adjustMode);
	MOVF       _setTemperature+0, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_adjustTemperature_set+0
	MOVF       R0+1, 0
	MOVWF      FARG_adjustTemperature_set+1
	MOVF       readTemperature_temp_L0+0, 0
	MOVWF      FARG_adjustTemperature_temperature+0
	MOVF       readTemperature_temp_L0+1, 0
	MOVWF      FARG_adjustTemperature_temperature+1
	MOVLW      0
	BTFSC      _flags+0, 5
	MOVLW      1
	MOVWF      FARG_adjustTemperature_type+0
	CALL       _adjustTemperature+0
;termostatoprogramavel.c,133 :: 		}
L_readTemperature20:
;termostatoprogramavel.c,134 :: 		value = value / 100;
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
;termostatoprogramavel.c,135 :: 		digit02 = value / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,136 :: 		digit01 = value % 10;
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
;termostatoprogramavel.c,137 :: 		digit02 = bcdData(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit02_L0+0
;termostatoprogramavel.c,138 :: 		digit01 = bcdData(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_bcdData_digit+0
	CALL       _bcdData+0
	MOVF       R0+0, 0
	MOVWF      readTemperature_digit01_L0+0
;termostatoprogramavel.c,141 :: 		enable7seg01 = 0;
	BCF        PORTB+0, 0
;termostatoprogramavel.c,142 :: 		Soft_SPI_Write(digit02);
	MOVF       readTemperature_digit02_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,143 :: 		enable7seg01 = 1;
	BSF        PORTB+0, 0
;termostatoprogramavel.c,145 :: 		enable7seg02 = 0;
	BCF        PORTB+0, 1
;termostatoprogramavel.c,146 :: 		Soft_SPI_Write(digit01);
	MOVF       readTemperature_digit01_L0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;termostatoprogramavel.c,147 :: 		enable7seg02 = 1;
	BSF        PORTB+0, 1
;termostatoprogramavel.c,148 :: 		myButton01 = 0x00;
	BCF        _flags+0, 2
;termostatoprogramavel.c,149 :: 		myButton02 = 0x00;
	BCF        _flags+0, 3
;termostatoprogramavel.c,150 :: 		delay_ms(100);
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
;termostatoprogramavel.c,151 :: 		}
L_end_readTemperature:
	RETURN
; end of _readTemperature

_adjustTemperature:

;termostatoprogramavel.c,153 :: 		void adjustTemperature(int set, int temperature, unsigned short type) {
;termostatoprogramavel.c,154 :: 		if(!type) {
	MOVF       FARG_adjustTemperature_type+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_adjustTemperature22
;termostatoprogramavel.c,156 :: 		if(temperature > (set + 500)) output = 0x00;
	MOVLW      244
	ADDWF      FARG_adjustTemperature_set+0, 0
	MOVWF      R1+0
	MOVF       FARG_adjustTemperature_set+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDLW      1
	MOVWF      R1+1
	MOVLW      128
	XORWF      R1+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_adjustTemperature_temperature+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__adjustTemperature43
	MOVF       FARG_adjustTemperature_temperature+0, 0
	SUBWF      R1+0, 0
L__adjustTemperature43:
	BTFSC      STATUS+0, 0
	GOTO       L_adjustTemperature23
	BCF        PORTB+0, 5
	GOTO       L_adjustTemperature24
L_adjustTemperature23:
;termostatoprogramavel.c,157 :: 		else output = 0x01;
	BSF        PORTB+0, 5
L_adjustTemperature24:
;termostatoprogramavel.c,158 :: 		}
L_adjustTemperature22:
;termostatoprogramavel.c,166 :: 		}
L_end_adjustTemperature:
	RETURN
; end of _adjustTemperature

_readButtons:

;termostatoprogramavel.c,168 :: 		void readButtons() {
;termostatoprogramavel.c,169 :: 		if(button01) flagButton01 = 0x01;
	BTFSS      PORTB+0, 3
	GOTO       L_readButtons25
	BSF        _flags+0, 0
L_readButtons25:
;termostatoprogramavel.c,170 :: 		if(!button01 && flagButton01) {
	BTFSC      PORTB+0, 3
	GOTO       L_readButtons28
	BTFSS      _flags+0, 0
	GOTO       L_readButtons28
L__readButtons35:
;termostatoprogramavel.c,171 :: 		myButton01 = 0x01;
	BSF        _flags+0, 2
;termostatoprogramavel.c,172 :: 		flagButton01 = 0x00;
	BCF        _flags+0, 0
;termostatoprogramavel.c,173 :: 		}
L_readButtons28:
;termostatoprogramavel.c,175 :: 		if(button02) flagButton02 = 0x01;
	BTFSS      PORTB+0, 4
	GOTO       L_readButtons29
	BSF        _flags+0, 1
L_readButtons29:
;termostatoprogramavel.c,176 :: 		if(!button02 && flagButton02) {
	BTFSC      PORTB+0, 4
	GOTO       L_readButtons32
	BTFSS      _flags+0, 1
	GOTO       L_readButtons32
L__readButtons34:
;termostatoprogramavel.c,177 :: 		myButton02 = 0x01;
	BSF        _flags+0, 3
;termostatoprogramavel.c,178 :: 		flagButton02 = 0x00;
	BCF        _flags+0, 1
;termostatoprogramavel.c,179 :: 		}
L_readButtons32:
;termostatoprogramavel.c,180 :: 		}
L_end_readButtons:
	RETURN
; end of _readButtons
