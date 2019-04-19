; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  teclado.asm  ver. 0.0 data: 21/05/13.   ==========                          
; ========================================================================


;Programa para varredura matricial de 12 teclas 3x4


	ORG 0000H
	MOV P2,#0FFH
	MOV P0,#00H


;-------------------------------------------------------------------------------------------------------------
	;EQUIVALENCIAS 
	L0 EQU P2.0
	L1 EQU P2.1
	L2 EQU P2.2
	L3 EQU P2.3
	C0 EQU P2.4

	C1 EQU P2.5
	C2 EQU P2.6
;-------------------------------------------------------------------------------------------------------------
	;HABILITAR COLUNAS

LOOP:	CLR C0
	LCALL TEMPO
	SETB C0
	LCALL TEMPO
	CLR C1
	LCALL TEMPO 
	SETB C1
	LCALL TEMPO 
	CLR C2
	LCALL TEMPO 
	SETB C2
	SJMP VARREDURA

;------------------------------------------------------------------------------------------------------------
		;VARREDURA BOTÕES
VARREDURA:
	
S0:	JB L0, S1
	MOV P0,#0AH
	LCALL TEMPO
	LJMP LOOP	
S1:	
	
	
;-------------------------------------------------------------------------------------------------------------


	;SUBROTINA TEMPO
TEMPO:  MOV R0, #2                     	        ;CARREGA RO COM 1
VOLTA2: MOV R1, #50    		                ;CARREGA R1 COM 50
VOLTA1: MOV R2, #50	                        ;CARREGA R2 COM 50
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
	END					;FIM DE PROGRAMA				
							

