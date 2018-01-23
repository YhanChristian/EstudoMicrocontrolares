
_main:

;MyProject.c,44 :: 		void main() {
;MyProject.c,45 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;MyProject.c,47 :: 		while(1) {
L_main0:
;MyProject.c,48 :: 		output = ~output;
	BTG         LATD0_bit+0, 0 
;MyProject.c,49 :: 		delay_ms(1000);
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
;MyProject.c,50 :: 		}
	GOTO        L_main0
;MyProject.c,51 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;MyProject.c,53 :: 		void configureMcu() {
;MyProject.c,54 :: 		CMCON = 0x07; //Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;MyProject.c,55 :: 		ADCON1 = 0x0F; //Desabilita portas analogicas
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,56 :: 		TRISD0_bit = 0x00; // Configura D0 como saida
	BCF         TRISD0_bit+0, 0 
;MyProject.c,57 :: 		LATD0_bit = 0x00;
	BCF         LATD0_bit+0, 0 
;MyProject.c,58 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu
