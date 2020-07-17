; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  motorindex2.asm  ver. 0.0 data: 16/06/13.   =======                          
; ========================================================================

;MOTOR DE PASSO FULL STEP UTILIZANDO DPTR REGISTRADOR ESPECIAL DE 16 BITS
;FULL STEP 1 MAIS VELOCIDADE, MENOR TORQUE
;FULL STEP 2 MAIOR TORQUE, MENOS VELOCIDADE


;------------------------------------------------------------------------------
		;EQUIVALENCIAS 

	INDEX  	EQU 03H			;INDEX EQUIVALE 03H
	SAIDA  	EQU P1			;SAIDA EQUIVALE A P1
	MOSTRA 	EQU P0			;MOSTRA EQUIVALE A P2
	SH  	EQU P2.0		;SH EQUIVALE A P2.0
	SAH 	EQU P2.7		;SAH EQUIVALE A P2.7
	
	
	
	ORG 0000H			;INICIO DE PROGRAMA
		
	MOV SP, #60H	   		;INDICO O INICIO DE UTILIZA��O DE "LABELS"
	MOV DPTR, #FULL_STEP1		;BUSCO ENDERE�O INICIAL DA TABELA, UTILIZAR FULL_STEP1
	MOV INDEX, #03	   		;INICIO INDEXA��O DE TABELA
;------------------------------------------------------------------------------
		;CONTROLE MOTOR
	
DIREITA:JB SH, ESQUERDA	  	 	;VERIFICO ACIONAMENTO DO BOT�O SH PULO PARA ESQUERDA
	INC INDEX		   	;INCREMENTO INDEX
	ANL INDEX, #03	   		;OPERA��O LOGICA AND ENTRE O DADO DE INDEX E 03
	LCALL STEP_SUB	   		;SUB-ROTINA STEP_SUB, EXECUTAR UM PASSO
	
	
ESQUERDA:JB SAH, DIREITA	  	;VERIFICO ACIONAMENTO DO BOT�O SHA PULO PARA DIREITA
	DEC INDEX		   	;DECREMENTO INDEX
	ANL INDEX, #03	  		;OPERA��O LOGICA AND ENTRE O DADO DE INDEX E 03
	LCALL STEP_SUB	   		;SUB-ROTINA STEP_SUB, EXECUTAR UM PASSO
	SJMP DIREITA	   		;PULO PARA DIREITA
	
;------------------------------------------------------------------------------
		;ACIONA O MOTOR DE PASSO			

STEP_SUB:MOV A, INDEX	  	        ;MOVO PARA ACC O VALOR DE INDEX
	MOVC A, @A+DPTR	  		;BUSCO O DADO APONTADO DE A E SOMO COM DPTR
	MOV SAIDA, A	   		;MOVO O DADO DE A PARA SAIDA	
	MOV MOSTRA, A	   		;MOVO O DADO DE A PARA MOSTRA
	LCALL TEMPO	  		;SUB-ROTINA TEMPO
	RET				;RETORNO DE SUB-ROTINA 
;------------------------------------------------------------------------------
		;SUB-ROTINA DE TEMPO


TEMPO:	MOV R0, #1			;MOVO PARA R0 1
	MOV R1, #6			;MOVO PARA R1 6
VOLTA:	DJNZ R0, $			;DECREMENTO R0, TRAVO AQUI
	DJNZ R1, VOLTA			;DECREMENTO R1 E PULO PARA VOLTA
	RET				;RETORNO DE SUB-ROTINA




;  �REA DE CONSTANTES ARMAZENADAS NA MEM�RIA DE PROGRAMA,CONFIGURA��O DPTR

FULL_STEP1:	
DB 01H, 02H, 04H, 08H

FULL_STEP2:	
DB 0CH, 06H, 03H, 09H


	END				;FIM DE PROGRAMA
	