
_main:

;injetorautomotivosimples.c,35 :: 		void main() {
;injetorautomotivosimples.c,36 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;injetorautomotivosimples.c,37 :: 		while(1) {
L_main0:
;injetorautomotivosimples.c,38 :: 		checkT0();
	CALL        _checkT0+0, 0
;injetorautomotivosimples.c,39 :: 		checkT1();
	CALL        _checkT1+0, 0
;injetorautomotivosimples.c,40 :: 		checkT2();
	CALL        _checkT2+0, 0
;injetorautomotivosimples.c,41 :: 		readButton();
	CALL        _readButton+0, 0
;injetorautomotivosimples.c,42 :: 		}
	GOTO        L_main0
;injetorautomotivosimples.c,43 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;injetorautomotivosimples.c,47 :: 		void configureMcu() {
;injetorautomotivosimples.c,48 :: 		ADCON1 = 0x01; // Todas IOs digitais
	MOVLW       1
	MOVWF       ADCON1+0 
;injetorautomotivosimples.c,49 :: 		TRISB = 0x24;  //Configura PortB definindo entradas e saídas
	MOVLW       36
	MOVWF       TRISB+0 
;injetorautomotivosimples.c,50 :: 		LATB = 0xE4;  //Inicializa o LATB
	MOVLW       228
	MOVWF       LATB+0 
;injetorautomotivosimples.c,51 :: 		TMR0H = 0x3C;   // Carrega registradores com valor 15536
	MOVLW       60
	MOVWF       TMR0H+0 
;injetorautomotivosimples.c,52 :: 		TMR0L = 0xB0;
	MOVLW       176
	MOVWF       TMR0L+0 
;injetorautomotivosimples.c,53 :: 		T0CON = 0x82; // Timer 0,  16 bits, prescaler 1:8
	MOVLW       130
	MOVWF       T0CON+0 
;injetorautomotivosimples.c,54 :: 		TMR1H = 0x3C;  // Carrega registradores com valor 15536
	MOVLW       60
	MOVWF       TMR1H+0 
;injetorautomotivosimples.c,55 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;injetorautomotivosimples.c,56 :: 		T1CON = 0xF1; // Timer 1,  16 bits, prescaler 1:8
	MOVLW       241
	MOVWF       T1CON+0 
;injetorautomotivosimples.c,57 :: 		T2CON = 0x7C; // Timer 2, 8 bits, postscaler 1:16
	MOVLW       124
	MOVWF       T2CON+0 
;injetorautomotivosimples.c,58 :: 		PR2 = pr2Load; // Carrega em PR2 valor de pr2Load
	MOVF        _pr2Load+0, 0 
	MOVWF       PR2+0 
;injetorautomotivosimples.c,59 :: 		flagButton = 0x00;
	BCF         _flagButton+0, BitPos(_flagButton+0) 
;injetorautomotivosimples.c,60 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_checkT0:

;injetorautomotivosimples.c,62 :: 		void checkT0() {
;injetorautomotivosimples.c,63 :: 		if(TMR0IF_bit) {
	BTFSS       TMR0IF_bit+0, 2 
	GOTO        L_checkT02
;injetorautomotivosimples.c,64 :: 		TMR0IF_bit = 0x00;
	BCF         TMR0IF_bit+0, 2 
;injetorautomotivosimples.c,65 :: 		TMR0H = 0x3C;
	MOVLW       60
	MOVWF       TMR0H+0 
;injetorautomotivosimples.c,66 :: 		TMR0L = 0xB0;
	MOVLW       176
	MOVWF       TMR0L+0 
;injetorautomotivosimples.c,67 :: 		baseT1++;
	INFSNZ      _baseT1+0, 1 
	INCF        _baseT1+1, 1 
;injetorautomotivosimples.c,68 :: 		baseT2++;
	INFSNZ      _baseT2+0, 1 
	INCF        _baseT2+1, 1 
;injetorautomotivosimples.c,70 :: 		baseTime();
	CALL        _baseTime+0, 0
;injetorautomotivosimples.c,71 :: 		}
L_checkT02:
;injetorautomotivosimples.c,72 :: 		}
L_end_checkT0:
	RETURN      0
; end of _checkT0

_baseTime:

;injetorautomotivosimples.c,74 :: 		void baseTime() {
;injetorautomotivosimples.c,76 :: 		if(baseT1 == 2) {
	MOVLW       0
	XORWF       _baseT1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__baseTime27
	MOVLW       2
	XORWF       _baseT1+0, 0 
L__baseTime27:
	BTFSS       STATUS+0, 2 
	GOTO        L_baseTime3
;injetorautomotivosimples.c,77 :: 		baseT1 = 0;
	CLRF        _baseT1+0 
	CLRF        _baseT1+1 
;injetorautomotivosimples.c,78 :: 		output01 = ~output01;
	BTG         LATB0_bit+0, 0 
;injetorautomotivosimples.c,79 :: 		}
L_baseTime3:
;injetorautomotivosimples.c,81 :: 		if(baseT2 == 10) {
	MOVLW       0
	XORWF       _baseT2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__baseTime28
	MOVLW       10
	XORWF       _baseT2+0, 0 
L__baseTime28:
	BTFSS       STATUS+0, 2 
	GOTO        L_baseTime4
;injetorautomotivosimples.c,82 :: 		baseT2 = 0;
	CLRF        _baseT2+0 
	CLRF        _baseT2+1 
;injetorautomotivosimples.c,83 :: 		output02 = ~output02;
	BTG         LATB1_bit+0, 1 
;injetorautomotivosimples.c,84 :: 		}
L_baseTime4:
;injetorautomotivosimples.c,85 :: 		}
L_end_baseTime:
	RETURN      0
; end of _baseTime

_checkT1:

;injetorautomotivosimples.c,87 :: 		void checkT1() {
;injetorautomotivosimples.c,88 :: 		if(TMR1IF_bit) {
	BTFSS       TMR1IF_bit+0, 0 
	GOTO        L_checkT15
;injetorautomotivosimples.c,89 :: 		TMR1IF_bit = 0x00;
	BCF         TMR1IF_bit+0, 0 
;injetorautomotivosimples.c,90 :: 		TMR1H = 0x3C;
	MOVLW       60
	MOVWF       TMR1H+0 
;injetorautomotivosimples.c,91 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;injetorautomotivosimples.c,92 :: 		baseTMR01++;
	INFSNZ      _baseTMR01+0, 1 
	INCF        _baseTMR01+1, 1 
;injetorautomotivosimples.c,93 :: 		if(baseTMR01 == 10) {
	MOVLW       0
	XORWF       _baseTMR01+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__checkT130
	MOVLW       10
	XORWF       _baseTMR01+0, 0 
L__checkT130:
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT16
;injetorautomotivosimples.c,94 :: 		baseTMR01 = 0;
	CLRF        _baseTMR01+0 
	CLRF        _baseTMR01+1 
;injetorautomotivosimples.c,95 :: 		motorControl++;
	INFSNZ      _motorControl+0, 1 
	INCF        _motorControl+1, 1 
;injetorautomotivosimples.c,96 :: 		if(motorControl == 5) {
	MOVLW       0
	XORWF       _motorControl+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__checkT131
	MOVLW       5
	XORWF       _motorControl+0, 0 
L__checkT131:
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT17
;injetorautomotivosimples.c,97 :: 		motorControl = 6;
	MOVLW       6
	MOVWF       _motorControl+0 
	MOVLW       0
	MOVWF       _motorControl+1 
;injetorautomotivosimples.c,98 :: 		motor = 0x00;
	BCF         LATB3_bit+0, 3 
;injetorautomotivosimples.c,99 :: 		}
L_checkT17:
;injetorautomotivosimples.c,100 :: 		}
L_checkT16:
;injetorautomotivosimples.c,101 :: 		}
L_checkT15:
;injetorautomotivosimples.c,102 :: 		}
L_end_checkT1:
	RETURN      0
; end of _checkT1

_checkT2:

;injetorautomotivosimples.c,105 :: 		void checkT2() {
;injetorautomotivosimples.c,106 :: 		if(TMR2IF_bit) {
	BTFSS       TMR2IF_bit+0, 1 
	GOTO        L_checkT28
;injetorautomotivosimples.c,107 :: 		TMR2IF_bit = 0x00;
	BCF         TMR2IF_bit+0, 1 
;injetorautomotivosimples.c,108 :: 		incRpm01++;
	INCF        _incRpm01+0, 1 
;injetorautomotivosimples.c,109 :: 		incRpm02++;
	INCF        _incRpm02+0, 1 
;injetorautomotivosimples.c,110 :: 		incRpm03++;
	INCF        _incRpm03+0, 1 
;injetorautomotivosimples.c,113 :: 		if(incRpm01 < 116) rpm01Output = ~rpm01Output;
	MOVLW       128
	XORWF       _incRpm01+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       116
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_checkT29
	BTG         LATB4_bit+0, 4 
	GOTO        L_checkT210
L_checkT29:
;injetorautomotivosimples.c,114 :: 		else rpm01Output = 0x00;
	BCF         LATB4_bit+0, 4 
L_checkT210:
;injetorautomotivosimples.c,115 :: 		if(incRpm01 == 120) incRpm01 = 0;
	MOVF        _incRpm01+0, 0 
	XORLW       120
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT211
	CLRF        _incRpm01+0 
L_checkT211:
;injetorautomotivosimples.c,118 :: 		if(incRpm02 < 70) rpm02Output = ~rpm02Output;
	MOVLW       128
	XORWF       _incRpm02+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       70
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_checkT212
	BTG         LATB6_bit+0, 6 
	GOTO        L_checkT213
L_checkT212:
;injetorautomotivosimples.c,119 :: 		else rpm02Output = 0x00;
	BCF         LATB6_bit+0, 6 
L_checkT213:
;injetorautomotivosimples.c,120 :: 		if(incRpm02 == 72) incRpm02 = 0;
	MOVF        _incRpm02+0, 0 
	XORLW       72
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT214
	CLRF        _incRpm02+0 
L_checkT214:
;injetorautomotivosimples.c,123 :: 		if(incRpm03 < 14) rpm03Output = ~rpm03Output;
	MOVLW       128
	XORWF       _incRpm03+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       14
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_checkT215
	BTG         LATB7_bit+0, 7 
	GOTO        L_checkT216
L_checkT215:
;injetorautomotivosimples.c,124 :: 		else rpm03Output = 0x00;
	BCF         LATB7_bit+0, 7 
L_checkT216:
;injetorautomotivosimples.c,125 :: 		if(incRpm03 == 16) incRpm03 = 0;
	MOVF        _incRpm03+0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT217
	CLRF        _incRpm03+0 
L_checkT217:
;injetorautomotivosimples.c,127 :: 		}
L_checkT28:
;injetorautomotivosimples.c,128 :: 		}
L_end_checkT2:
	RETURN      0
; end of _checkT2

_readButton:

;injetorautomotivosimples.c,131 :: 		void readButton() {
;injetorautomotivosimples.c,132 :: 		if(!button) flagButton = 0x01;
	BTFSC       RB5_bit+0, 5 
	GOTO        L_readButton18
	BSF         _flagButton+0, BitPos(_flagButton+0) 
L_readButton18:
;injetorautomotivosimples.c,133 :: 		if(button && flagButton) {
	BTFSS       RB5_bit+0, 5 
	GOTO        L_readButton21
	BTFSS       _flagButton+0, BitPos(_flagButton+0) 
	GOTO        L_readButton21
L__readButton22:
;injetorautomotivosimples.c,134 :: 		flagButton = 0x00;
	BCF         _flagButton+0, BitPos(_flagButton+0) 
;injetorautomotivosimples.c,135 :: 		motor = 0x01;
	BSF         LATB3_bit+0, 3 
;injetorautomotivosimples.c,136 :: 		motorControl = 0x00;
	CLRF        _motorControl+0 
	CLRF        _motorControl+1 
;injetorautomotivosimples.c,137 :: 		}
L_readButton21:
;injetorautomotivosimples.c,138 :: 		}
L_end_readButton:
	RETURN      0
; end of _readButton
