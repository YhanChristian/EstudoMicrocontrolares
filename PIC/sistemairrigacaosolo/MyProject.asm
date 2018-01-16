
_main:

;MyProject.c,16 :: 		void main() {
;MyProject.c,17 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;MyProject.c,19 :: 		while(1) {
L_main0:
;MyProject.c,20 :: 		output = ~output;
	BTG         LATD0_bit+0, 0 
;MyProject.c,21 :: 		}
	GOTO        L_main0
;MyProject.c,22 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;MyProject.c,24 :: 		void configureMcu() {
;MyProject.c,25 :: 		CMCON = 0x07; //Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;MyProject.c,26 :: 		ADCON1 = 0x0F; //Desabilita portas analogicas
	MOVLW       15
	MOVWF       ADCON1+0 
;MyProject.c,27 :: 		LATD0_bit = 0x00; //Define pino D0 como saida digital
	BCF         LATD0_bit+0, 0 
;MyProject.c,28 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu
