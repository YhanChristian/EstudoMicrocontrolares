
_main:

;MyProject.c,16 :: 		void main() {
;MyProject.c,17 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;MyProject.c,19 :: 		while(1) {
L_main0:
;MyProject.c,20 :: 		output = ~output;
	BTG         LATD0_bit+0, 0 
;MyProject.c,21 :: 		delay_ms(1000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	DECFSZ      R11, 1, 1
	BRA         L_main2
	NOP
;MyProject.c,22 :: 		}
	GOTO        L_main0
;MyProject.c,23 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;MyProject.c,25 :: 		void configureMcu() {
;MyProject.c,26 :: 		CMCON = 0x07; //Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;MyProject.c,27 :: 		ADCON1 = 0x0F; //Desabilita portas analogicas
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,28 :: 		TRISD0_bit = 0x00; // Configura D0 como saida
	BCF         TRISD0_bit+0, 0 
;MyProject.c,29 :: 		LATD0_bit = 0x00;
	BCF         LATD0_bit+0, 0 
;MyProject.c,30 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu
