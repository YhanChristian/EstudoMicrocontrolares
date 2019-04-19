; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  halfindex.asm  ver. 0.0 data: 16/06/13.   =========                          
; ========================================================================

;PROGRAMA INDEXADOR COM DPTR HALF-STEP


;--------------------------------------------------------------------------------
		;EQUIVALENCIAS

	INDEX  	EQU 03H			;INDEX EQUIVALE A 03H, INDEXADOR DA TABELA
	SAIDA  	EQU P1			;SAIDA EQUIVALE A P1
	MOSTRA  EQU P0			;MOSTRA EQUIVALE A P2
	SH  	EQU P2.0		;SH EQUIVALE A P2.0		
	SAH 	EQU P2.7		;SAH EQUIVALE A P2.7		
	
	
	
	ORG 0000H			;INICIO DE PROGRAMA.
	MOV SP, #30H			;REALOCA STACK POINTER.
	MOV DPTR, #HALF_STEP		;BUSCA ENDEREÇO INICIAL DA TABELA.
	MOV INDEX, #07			;INICIALIZA INDEXADOR DA TABELA.
;--------------------------------------------------------------------------------
		;CONTROLE MOTOR	
	
DIREITA:JB SH, ESQUERDA			;VERIFICO ACIONAMENTO DE SH, PULO PARA ESQUERDA	
	INC INDEX			;INCREMENTA INDEX
	ANL INDEX, #07			;LOGICA AND ENTRE INDEX E 07 
	LCALL STEP_SUB			;SUB-ROTINA STEP_SUB, EXECUTA UM PASSO
	
	
ESQUERDA:JB SAH, DIREITA		;VERIFICO ACIONAMENTO DE SAH, PULO PARA DIREITA
	DEC INDEX			;DECREMENTA INDEX
	ANL INDEX, #07			;LOGICA AND ENTRE INDEX E 07
	LCALL STEP_SUB			;SUB-ROTINA STEP_SUB, EXECUTA UM PASSO
	SJMP DIREITA			;VOLTO PARA DIREITA
;--------------------------------------------------------------------------------
		;ACIONAMENTO MOTOR	

STEP_SUB:	MOV A, INDEX		;MOVO PARA ACC O VALOR DE INDEX
	MOVC A, @A+DPTR			;BUSCO O DADO APONTADO POR A+DPTR E MOVO PARA A
	MOV SAIDA, A			;MOVO O DADO DE ACC PARA SAIDA
	MOV MOSTRA, A			;MOVO O DADO DE ACC PARA MOSTRA
	LCALL TEMPO			;SUB-ROTINA TEMPO
	RET 				;RETORNO DE SUB-ROTINA
	
;--------------------------------------------------------------------------------
		;SUB-ROTINA TEMPO	

TEMPO:	MOV R0, #1			;MOVO PARA R0 1
	MOV R1, #4			;MOVO PARA R1 4
VOLTA:	DJNZ R0, $			;DECREMENTO R0, TRAVO AQUI
	DJNZ R1, VOLTA			;DECREMENTO R1 PULO PARA VOLTA
	RET				;RETORNO DE SUB-ROTINA


; ÁREA DE CONSTANTES ARMAZENADAS NA MEMÓRIA DE PROGRAMA

HALF_STEP:
DB  08H,0CH,04H,06H,02H,03H,01H,09H

	END				;FIM DE PROGRAMA
	