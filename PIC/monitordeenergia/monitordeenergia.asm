
_main:

;monitordeenergia.c,30 :: 		void main() {
;monitordeenergia.c,31 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;monitordeenergia.c,32 :: 		initDisplay();
	CALL        _initDisplay+0, 0
;monitordeenergia.c,33 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;monitordeenergia.c,35 :: 		void configureMcu() {
;monitordeenergia.c,36 :: 		CMCON = 0x07;       // Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;monitordeenergia.c,37 :: 		ADCON1 = 0x0E; // Configurando ADC 1
	MOVLW       14
	MOVWF       ADCON1+0 
;monitordeenergia.c,38 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_initDisplay:

;monitordeenergia.c,40 :: 		void initDisplay() {
;monitordeenergia.c,44 :: 		}
L_end_initDisplay:
	RETURN      0
; end of _initDisplay

_showDisplay:

;monitordeenergia.c,46 :: 		void showDisplay(unsigned short current[4], int voltage[4], unsigned int activePower[4]) {
;monitordeenergia.c,48 :: 		}
L_end_showDisplay:
	RETURN      0
; end of _showDisplay

_calcPower:

;monitordeenergia.c,51 :: 		unsigned int calcPower(unsigned short current, int voltage) {
;monitordeenergia.c,53 :: 		activePower = current * voltage;
	MOVF        FARG_calcPower_current+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_calcPower_voltage+0, 0 
	MOVWF       R4 
	MOVF        FARG_calcPower_voltage+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
;monitordeenergia.c,54 :: 		return activePower;
;monitordeenergia.c,55 :: 		}
L_end_calcPower:
	RETURN      0
; end of _calcPower
