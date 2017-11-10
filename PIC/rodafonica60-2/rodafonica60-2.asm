
_main:

;rodafonica60-2.c,33 :: 		void main() {
;rodafonica60-2.c,34 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;rodafonica60-2.c,35 :: 		while(1) {
L_main0:
;rodafonica60-2.c,36 :: 		checkT0();
	CALL        _checkT0+0, 0
;rodafonica60-2.c,37 :: 		checkT1();
	CALL        _checkT1+0, 0
;rodafonica60-2.c,38 :: 		checkT2();
	CALL        _checkT2+0, 0
;rodafonica60-2.c,39 :: 		readButton();
	CALL        _readButton+0, 0
;rodafonica60-2.c,40 :: 		}
	GOTO        L_main0
;rodafonica60-2.c,41 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;rodafonica60-2.c,45 :: 		void configureMcu() {
;rodafonica60-2.c,46 :: 		ADCON1 = 0x01; // Todas IOs digitais
	MOVLW       1
	MOVWF       ADCON1+0 
;rodafonica60-2.c,47 :: 		TRISB = 0xE0;  //Configura de RB0 à RB4 saída
	MOVLW       224
	MOVWF       TRISB+0 
;rodafonica60-2.c,48 :: 		LATB = 0xE0;  //Inicializa o LATB
	MOVLW       224
	MOVWF       LATB+0 
;rodafonica60-2.c,49 :: 		TMR0H = 0x3C;   // Carrega registradores com valor 15536
	MOVLW       60
	MOVWF       TMR0H+0 
;rodafonica60-2.c,50 :: 		TMR0L = 0xB0;
	MOVLW       176
	MOVWF       TMR0L+0 
;rodafonica60-2.c,51 :: 		T0CON = 0x82; // Timer 0,  16 bits, prescaler 1:8
	MOVLW       130
	MOVWF       T0CON+0 
;rodafonica60-2.c,52 :: 		TMR1H = 0x3C;  // Carrega registradores com valor 15536
	MOVLW       60
	MOVWF       TMR1H+0 
;rodafonica60-2.c,53 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;rodafonica60-2.c,54 :: 		T1CON = 0xF1; // Timer 1,  16 bits, prescaler 1:8
	MOVLW       241
	MOVWF       T1CON+0 
;rodafonica60-2.c,55 :: 		T2CON = 0x7C; // Timer 2, 8 bits, postscaler 1:16
	MOVLW       124
	MOVWF       T2CON+0 
;rodafonica60-2.c,56 :: 		PR2 = pr2Load; // Carrega em PR2 valor de pr2Load
	MOVF        _pr2Load+0, 0 
	MOVWF       PR2+0 
;rodafonica60-2.c,57 :: 		flagButton = 0x00;
	BCF         _flagButton+0, BitPos(_flagButton+0) 
;rodafonica60-2.c,58 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_checkT0:

;rodafonica60-2.c,60 :: 		void checkT0() {
;rodafonica60-2.c,61 :: 		if(TMR0IF_bit) {
	BTFSS       TMR0IF_bit+0, 2 
	GOTO        L_checkT02
;rodafonica60-2.c,62 :: 		TMR0IF_bit = 0x00;
	BCF         TMR0IF_bit+0, 2 
;rodafonica60-2.c,63 :: 		TMR0H = 0x3C;
	MOVLW       60
	MOVWF       TMR0H+0 
;rodafonica60-2.c,64 :: 		TMR0L = 0xB0;
	MOVLW       176
	MOVWF       TMR0L+0 
;rodafonica60-2.c,65 :: 		baseT1++;
	INFSNZ      _baseT1+0, 1 
	INCF        _baseT1+1, 1 
;rodafonica60-2.c,66 :: 		baseT2++;
	INFSNZ      _baseT2+0, 1 
	INCF        _baseT2+1, 1 
;rodafonica60-2.c,68 :: 		baseTime();
	CALL        _baseTime+0, 0
;rodafonica60-2.c,69 :: 		}
L_checkT02:
;rodafonica60-2.c,70 :: 		}
L_end_checkT0:
	RETURN      0
; end of _checkT0

_baseTime:

;rodafonica60-2.c,72 :: 		void baseTime() {
;rodafonica60-2.c,74 :: 		if(baseT1 == 2) {
	MOVLW       0
	XORWF       _baseT1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__baseTime21
	MOVLW       2
	XORWF       _baseT1+0, 0 
L__baseTime21:
	BTFSS       STATUS+0, 2 
	GOTO        L_baseTime3
;rodafonica60-2.c,75 :: 		baseT1 = 0;
	CLRF        _baseT1+0 
	CLRF        _baseT1+1 
;rodafonica60-2.c,76 :: 		output01 = ~output01;
	BTG         LATB0_bit+0, 0 
;rodafonica60-2.c,77 :: 		}
L_baseTime3:
;rodafonica60-2.c,79 :: 		if(baseT2 == 10) {
	MOVLW       0
	XORWF       _baseT2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__baseTime22
	MOVLW       10
	XORWF       _baseT2+0, 0 
L__baseTime22:
	BTFSS       STATUS+0, 2 
	GOTO        L_baseTime4
;rodafonica60-2.c,80 :: 		baseT2 = 0;
	CLRF        _baseT2+0 
	CLRF        _baseT2+1 
;rodafonica60-2.c,81 :: 		output02 = ~output02;
	BTG         LATB1_bit+0, 1 
;rodafonica60-2.c,82 :: 		}
L_baseTime4:
;rodafonica60-2.c,83 :: 		}
L_end_baseTime:
	RETURN      0
; end of _baseTime

_checkT1:

;rodafonica60-2.c,85 :: 		void checkT1() {
;rodafonica60-2.c,86 :: 		if(TMR1IF_bit) {
	BTFSS       TMR1IF_bit+0, 0 
	GOTO        L_checkT15
;rodafonica60-2.c,87 :: 		TMR1IF_bit = 0x00;
	BCF         TMR1IF_bit+0, 0 
;rodafonica60-2.c,88 :: 		TMR1H = 0x3C;
	MOVLW       60
	MOVWF       TMR1H+0 
;rodafonica60-2.c,89 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;rodafonica60-2.c,90 :: 		baseTMR01++;
	INFSNZ      _baseTMR01+0, 1 
	INCF        _baseTMR01+1, 1 
;rodafonica60-2.c,91 :: 		if(baseTMR01 == 10) {
	MOVLW       0
	XORWF       _baseTMR01+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__checkT124
	MOVLW       10
	XORWF       _baseTMR01+0, 0 
L__checkT124:
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT16
;rodafonica60-2.c,92 :: 		baseTMR01 = 0;
	CLRF        _baseTMR01+0 
	CLRF        _baseTMR01+1 
;rodafonica60-2.c,93 :: 		motorControl++;
	INFSNZ      _motorControl+0, 1 
	INCF        _motorControl+1, 1 
;rodafonica60-2.c,94 :: 		if(motorControl == 5) {
	MOVLW       0
	XORWF       _motorControl+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__checkT125
	MOVLW       5
	XORWF       _motorControl+0, 0 
L__checkT125:
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT17
;rodafonica60-2.c,95 :: 		motorControl = 6;
	MOVLW       6
	MOVWF       _motorControl+0 
	MOVLW       0
	MOVWF       _motorControl+1 
;rodafonica60-2.c,96 :: 		motor = 0x00;
	BCF         LATB3_bit+0, 3 
;rodafonica60-2.c,97 :: 		}
L_checkT17:
;rodafonica60-2.c,98 :: 		}
L_checkT16:
;rodafonica60-2.c,99 :: 		}
L_checkT15:
;rodafonica60-2.c,100 :: 		}
L_end_checkT1:
	RETURN      0
; end of _checkT1

_checkT2:

;rodafonica60-2.c,103 :: 		void checkT2() {
;rodafonica60-2.c,104 :: 		if(TMR2IF_bit) {
	BTFSS       TMR2IF_bit+0, 1 
	GOTO        L_checkT28
;rodafonica60-2.c,105 :: 		TMR2IF_bit = 0x00;
	BCF         TMR2IF_bit+0, 1 
;rodafonica60-2.c,106 :: 		incRpm++;
	INCF        _incRpm+0, 1 
;rodafonica60-2.c,107 :: 		if(incRpm < 116) rpmOutput = ~rpmOutput;
	MOVLW       128
	XORWF       _incRpm+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       116
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_checkT29
	BTG         LATB4_bit+0, 4 
	GOTO        L_checkT210
L_checkT29:
;rodafonica60-2.c,108 :: 		else rpmOutput = 0x00;
	BCF         LATB4_bit+0, 4 
L_checkT210:
;rodafonica60-2.c,109 :: 		if(incRpm == 120) incRpm = 0;
	MOVF        _incRpm+0, 0 
	XORLW       120
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT211
	CLRF        _incRpm+0 
L_checkT211:
;rodafonica60-2.c,110 :: 		}
L_checkT28:
;rodafonica60-2.c,111 :: 		}
L_end_checkT2:
	RETURN      0
; end of _checkT2

_readButton:

;rodafonica60-2.c,114 :: 		void readButton() {
;rodafonica60-2.c,115 :: 		if(!button) flagButton = 0x01;
	BTFSC       RB5_bit+0, 5 
	GOTO        L_readButton12
	BSF         _flagButton+0, BitPos(_flagButton+0) 
L_readButton12:
;rodafonica60-2.c,116 :: 		if(button && flagButton) {
	BTFSS       RB5_bit+0, 5 
	GOTO        L_readButton15
	BTFSS       _flagButton+0, BitPos(_flagButton+0) 
	GOTO        L_readButton15
L__readButton16:
;rodafonica60-2.c,117 :: 		flagButton = 0x00;
	BCF         _flagButton+0, BitPos(_flagButton+0) 
;rodafonica60-2.c,118 :: 		motor = 0x01;
	BSF         LATB3_bit+0, 3 
;rodafonica60-2.c,119 :: 		motorControl = 0x00;
	CLRF        _motorControl+0 
	CLRF        _motorControl+1 
;rodafonica60-2.c,120 :: 		}
L_readButton15:
;rodafonica60-2.c,121 :: 		}
L_end_readButton:
	RETURN      0
; end of _readButton
