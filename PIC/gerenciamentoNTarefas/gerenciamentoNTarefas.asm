
_main:

;gerenciamentoNTarefas.c,29 :: 		void main() {
;gerenciamentoNTarefas.c,30 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;gerenciamentoNTarefas.c,31 :: 		while(1) {
L_main0:
;gerenciamentoNTarefas.c,32 :: 		readButton();
	CALL        _readButton+0, 0
;gerenciamentoNTarefas.c,33 :: 		checkT0();
	CALL        _checkT0+0, 0
;gerenciamentoNTarefas.c,34 :: 		checkT1();
	CALL        _checkT1+0, 0
;gerenciamentoNTarefas.c,35 :: 		}
	GOTO        L_main0
;gerenciamentoNTarefas.c,36 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;gerenciamentoNTarefas.c,40 :: 		void configureMcu() {
;gerenciamentoNTarefas.c,41 :: 		ADCON1 = 0x01; // Todas IOs digitais
	MOVLW       1
	MOVWF       ADCON1+0 
;gerenciamentoNTarefas.c,42 :: 		TRISB = 0xF0;  //Configura de RB0 à RB3 como saída
	MOVLW       240
	MOVWF       TRISB+0 
;gerenciamentoNTarefas.c,43 :: 		LATB = 0xF0;  //Inicializa o LATB
	MOVLW       240
	MOVWF       LATB+0 
;gerenciamentoNTarefas.c,44 :: 		TMR0H = 0x3C;   // Carrega registradores com valor 15536
	MOVLW       60
	MOVWF       TMR0H+0 
;gerenciamentoNTarefas.c,45 :: 		TMR0L = 0xB0;
	MOVLW       176
	MOVWF       TMR0L+0 
;gerenciamentoNTarefas.c,46 :: 		T0CON = 0x82; // Timer 0,  16 bits, prescaler 1:8
	MOVLW       130
	MOVWF       T0CON+0 
;gerenciamentoNTarefas.c,47 :: 		TMR1H = 0x3C;  // Carrega registradores com valor 15536
	MOVLW       60
	MOVWF       TMR1H+0 
;gerenciamentoNTarefas.c,48 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;gerenciamentoNTarefas.c,49 :: 		T1CON = 0xF1; // Timer 1,  16 bits, prescaler 1:8
	MOVLW       241
	MOVWF       T1CON+0 
;gerenciamentoNTarefas.c,50 :: 		flagButton = 0x00;
	BCF         _flagButton+0, BitPos(_flagButton+0) 
;gerenciamentoNTarefas.c,51 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_checkT0:

;gerenciamentoNTarefas.c,53 :: 		void checkT0() {
;gerenciamentoNTarefas.c,54 :: 		if(TMR0IF_bit) {
	BTFSS       TMR0IF_bit+0, 2 
	GOTO        L_checkT02
;gerenciamentoNTarefas.c,55 :: 		TMR0IF_bit = 0x00;
	BCF         TMR0IF_bit+0, 2 
;gerenciamentoNTarefas.c,56 :: 		TMR0H = 0x3C;
	MOVLW       60
	MOVWF       TMR0H+0 
;gerenciamentoNTarefas.c,57 :: 		TMR0L = 0xB0;
	MOVLW       176
	MOVWF       TMR0L+0 
;gerenciamentoNTarefas.c,58 :: 		baseT1++;
	INFSNZ      _baseT1+0, 1 
	INCF        _baseT1+1, 1 
;gerenciamentoNTarefas.c,59 :: 		baseT2++;
	INFSNZ      _baseT2+0, 1 
	INCF        _baseT2+1, 1 
;gerenciamentoNTarefas.c,61 :: 		baseTime();
	CALL        _baseTime+0, 0
;gerenciamentoNTarefas.c,62 :: 		}
L_checkT02:
;gerenciamentoNTarefas.c,63 :: 		}
L_end_checkT0:
	RETURN      0
; end of _checkT0

_baseTime:

;gerenciamentoNTarefas.c,65 :: 		void baseTime() {
;gerenciamentoNTarefas.c,67 :: 		if(baseT1 == 2) {
	MOVLW       0
	XORWF       _baseT1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__baseTime17
	MOVLW       2
	XORWF       _baseT1+0, 0 
L__baseTime17:
	BTFSS       STATUS+0, 2 
	GOTO        L_baseTime3
;gerenciamentoNTarefas.c,68 :: 		baseT1 = 0;
	CLRF        _baseT1+0 
	CLRF        _baseT1+1 
;gerenciamentoNTarefas.c,69 :: 		output01 = ~output01;
	BTG         LATB0_bit+0, 0 
;gerenciamentoNTarefas.c,70 :: 		}
L_baseTime3:
;gerenciamentoNTarefas.c,72 :: 		if(baseT2 == 10) {
	MOVLW       0
	XORWF       _baseT2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__baseTime18
	MOVLW       10
	XORWF       _baseT2+0, 0 
L__baseTime18:
	BTFSS       STATUS+0, 2 
	GOTO        L_baseTime4
;gerenciamentoNTarefas.c,73 :: 		baseT2 = 0;
	CLRF        _baseT2+0 
	CLRF        _baseT2+1 
;gerenciamentoNTarefas.c,74 :: 		output02 = ~output02;
	BTG         LATB1_bit+0, 1 
;gerenciamentoNTarefas.c,75 :: 		}
L_baseTime4:
;gerenciamentoNTarefas.c,76 :: 		}
L_end_baseTime:
	RETURN      0
; end of _baseTime

_checkT1:

;gerenciamentoNTarefas.c,78 :: 		void checkT1() {
;gerenciamentoNTarefas.c,79 :: 		if(TMR1IF_bit) {
	BTFSS       TMR1IF_bit+0, 0 
	GOTO        L_checkT15
;gerenciamentoNTarefas.c,80 :: 		TMR1IF_bit = 0x00;
	BCF         TMR1IF_bit+0, 0 
;gerenciamentoNTarefas.c,81 :: 		TMR1H = 0x3C;
	MOVLW       60
	MOVWF       TMR1H+0 
;gerenciamentoNTarefas.c,82 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;gerenciamentoNTarefas.c,83 :: 		baseTMR01++;
	INFSNZ      _baseTMR01+0, 1 
	INCF        _baseTMR01+1, 1 
;gerenciamentoNTarefas.c,84 :: 		if(baseTMR01 == 10) {
	MOVLW       0
	XORWF       _baseTMR01+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__checkT120
	MOVLW       10
	XORWF       _baseTMR01+0, 0 
L__checkT120:
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT16
;gerenciamentoNTarefas.c,85 :: 		baseTMR01 = 0;
	CLRF        _baseTMR01+0 
	CLRF        _baseTMR01+1 
;gerenciamentoNTarefas.c,86 :: 		motorControl++;
	INFSNZ      _motorControl+0, 1 
	INCF        _motorControl+1, 1 
;gerenciamentoNTarefas.c,87 :: 		if(motorControl == 5) {
	MOVLW       0
	XORWF       _motorControl+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__checkT121
	MOVLW       5
	XORWF       _motorControl+0, 0 
L__checkT121:
	BTFSS       STATUS+0, 2 
	GOTO        L_checkT17
;gerenciamentoNTarefas.c,88 :: 		motorControl = 6;
	MOVLW       6
	MOVWF       _motorControl+0 
	MOVLW       0
	MOVWF       _motorControl+1 
;gerenciamentoNTarefas.c,89 :: 		motor = 0x00;
	BCF         LATB3_bit+0, 3 
;gerenciamentoNTarefas.c,90 :: 		}
L_checkT17:
;gerenciamentoNTarefas.c,91 :: 		}
L_checkT16:
;gerenciamentoNTarefas.c,92 :: 		}
L_checkT15:
;gerenciamentoNTarefas.c,93 :: 		}
L_end_checkT1:
	RETURN      0
; end of _checkT1

_readButton:

;gerenciamentoNTarefas.c,95 :: 		void readButton() {
;gerenciamentoNTarefas.c,96 :: 		if(!button) flagButton = 0x01;
	BTFSC       RB5_bit+0, 5 
	GOTO        L_readButton8
	BSF         _flagButton+0, BitPos(_flagButton+0) 
L_readButton8:
;gerenciamentoNTarefas.c,97 :: 		if(button && flagButton) {
	BTFSS       RB5_bit+0, 5 
	GOTO        L_readButton11
	BTFSS       _flagButton+0, BitPos(_flagButton+0) 
	GOTO        L_readButton11
L__readButton12:
;gerenciamentoNTarefas.c,98 :: 		flagButton = 0x00;
	BCF         _flagButton+0, BitPos(_flagButton+0) 
;gerenciamentoNTarefas.c,99 :: 		motor = 0x01;
	BSF         LATB3_bit+0, 3 
;gerenciamentoNTarefas.c,100 :: 		motorControl = 0x00;
	CLRF        _motorControl+0 
	CLRF        _motorControl+1 
;gerenciamentoNTarefas.c,101 :: 		}
L_readButton11:
;gerenciamentoNTarefas.c,102 :: 		}
L_end_readButton:
	RETURN      0
; end of _readButton
