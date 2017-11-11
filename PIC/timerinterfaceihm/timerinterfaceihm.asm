
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;timerinterfaceihm.c,24 :: 		void interrupt() {
;timerinterfaceihm.c,25 :: 		if(TMR2IF_bit) {
	BTFSS      TMR2IF_bit+0, 1
	GOTO       L_interrupt0
;timerinterfaceihm.c,26 :: 		TMR2IF_bit = 0x00;
	BCF        TMR2IF_bit+0, 1
;timerinterfaceihm.c,27 :: 		tmr02Trigger = ~tmr02Trigger;
	MOVLW      1
	XORWF      _flags+0, 1
;timerinterfaceihm.c,28 :: 		if(tmr02Trigger) {
	BTFSS      _flags+0, 0
	GOTO       L_interrupt1
;timerinterfaceihm.c,29 :: 		tmr02Counter++;
	INCF       _tmr02Counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tmr02Counter+1, 1
;timerinterfaceihm.c,30 :: 		if(tmr02Counter == 490) {
	MOVF       _tmr02Counter+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt7
	MOVLW      234
	XORWF      _tmr02Counter+0, 0
L__interrupt7:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;timerinterfaceihm.c,31 :: 		oneSecond = ~oneSecond;
	MOVLW      1
	XORWF      PORTB+0, 1
;timerinterfaceihm.c,32 :: 		tmr02Counter = 0;
	CLRF       _tmr02Counter+0
	CLRF       _tmr02Counter+1
;timerinterfaceihm.c,33 :: 		}
L_interrupt2:
;timerinterfaceihm.c,34 :: 		}
L_interrupt1:
;timerinterfaceihm.c,35 :: 		}
L_interrupt0:
;timerinterfaceihm.c,37 :: 		}
L_end_interrupt:
L__interrupt6:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;timerinterfaceihm.c,39 :: 		void main() {
;timerinterfaceihm.c,40 :: 		configureMcu();
	CALL       _configureMcu+0
;timerinterfaceihm.c,41 :: 		while(1) {
L_main3:
;timerinterfaceihm.c,42 :: 		TMR2ON_bit = 0x01;
	BSF        TMR2ON_bit+0, 2
;timerinterfaceihm.c,43 :: 		}
	GOTO       L_main3
;timerinterfaceihm.c,44 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_configureMcu:

;timerinterfaceihm.c,46 :: 		void configureMcu() {
;timerinterfaceihm.c,47 :: 		CMCON = 0x07;       // Desabilita comparadores
	MOVLW      7
	MOVWF      CMCON+0
;timerinterfaceihm.c,48 :: 		TRISB0_bit = 0x00;    // RB0 como saída
	BCF        TRISB0_bit+0, 0
;timerinterfaceihm.c,49 :: 		INTCON.GIE = 0x01;  // Habilita interrupção global
	BSF        INTCON+0, 7
;timerinterfaceihm.c,50 :: 		INTCON.PEIE = 0x01; // Habilita interrupção de periféricos
	BSF        INTCON+0, 6
;timerinterfaceihm.c,51 :: 		TMR2IE_bit = 0X01;  // Habilita interrupção do TMR2
	BSF        TMR2IE_bit+0, 1
;timerinterfaceihm.c,52 :: 		T2CON = 0x01;       // Config TMR2 Postscaler 1 Prescaler 4, timer desabilitado
	MOVLW      1
	MOVWF      T2CON+0
;timerinterfaceihm.c,53 :: 		PR2 =  pr2Value;    // Atribui a PR2 o valor da variavel pr2Value
	MOVF       _pr2Value+0, 0
	MOVWF      PR2+0
;timerinterfaceihm.c,54 :: 		}
L_end_configureMcu:
	RETURN
; end of _configureMcu
