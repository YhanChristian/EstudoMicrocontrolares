; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  motorindex.asm  ver. 0.0 data: 16/06/13.   ========                          
; ========================================================================

;Motor de passo full-step and half-step
;Exemplo de indexação 1




	ORG 0000H			;INICIO DE PROGRAMA
	MOV SP, #60H			;HABILITO A UTILIZAÇÃO DE "LABELS" DEPOIS DE 60H
	SETB P2.0			;SETO P2.0
	SETB P3.2			;SETO P3.2

;-----------------------------------------------------------------------------------------
		;CONFIGURAÇÃO DE PASSOS
	
INIT:	MOV 30H, #08H   		;MOVO O DADO 08H PARA A POSIÇÃO DA RAM 30H
	MOV 31H, #0CH   		;MOVO O DADO 0CH PARA A POSIÇÃO DA RAM 31H
	MOV 32H, #04H   		;MOVO O DADO 04H PARA A POSIÇÃO DA RAM 32H
	MOV 33H, #06H   		;MOVO O DADO 06H PARA A POSIÇÃO DA RAM 33H
	MOV 34H, #02H   		;MOVO O DADO 02H PARA A POSIÇÃO DA RAM 34H
	MOV 35H, #03H   		;MOVO O DADO 03H PARA A POSIÇÃO DA RAM 35H
	MOV 36H, #01H   		;MOVO O DADO 01H PARA A POSIÇÃO DA RAM 36H
	MOV 37H, #09H  			;MOVO O DADO 09H PARA A POSIÇÃO DA RAM 37H

		
	MOV R0, #30H     		;MOVO O DADO 30H PARA R0
	LCALL TEMPO			;SUB-ROTINA TEMPO	
		
S1:	MOV P1, @R0    			;MOVO PARA P1 O DADO ENDEREÇADO R0	
	MOV P0, @R0    			;MOVO PARA P0 O DADO ENDEREÇADO R0
	LCALL TEMPO  			;SUB-ROTINA TEMPO
	

	JB P2.0, DOWN        		;VERIFICO TECLA ACIONADA PULO PARA DOWN
UP:	INC R0	             		;INCREMENTO R0
	CJNE R0, #38H, S1  		;COMPARO R0 COM 38H PULO PARA S1
	MOV R0, #30H           		;MOVO PARA R0 30H
	LJMP S1	              		;PULO PARA S1
	
	
DOWN:	DEC R0                     	;DECREMENTO R0
	CJNE R0, #2FH, S1  		;COMPARO R0 COM 2FH PULO PARA S1
	MOV R0,#37H          		;MOVO PARA R0 37H
	LJMP S1	            		;SALTO PARA S1			

;-----------------------------------------------------------------------------------------
		;CONFIGURAÇÃO VELOCIDADE MOTOR
	
 
TEMPO:	JNB P3.2,  RAPIDO 		;VERIFICO O ACIONAMENTO DA TECLA PULO PARA RAPIDO
	LJMP LENTO            		;SALTO PARA LENTO
	RET	           		;RETORNO DE SUB-ROTINA		


RAPIDO:	MOV R1, #1			;MOVO PARA R1 1
VOLTA2:	MOV R2, #10			;MOVO PARA R2 10
VOLTA1:	MOV R3, #50			;MOVO PARA R3 50	
	DJNZ R3, $			;DECREMENTO R3 TRAVO AQUI
	DJNZ R2, VOLTA1			;DECREMENTO R2 E PULO PARA VOLTA 1
	DJNZ R1, VOLTA2			;DECREMENTO R1 E PULO PARA VOLTA 2	
	RET				;RETORNO DE SUB-ROTINA

LENTO:	MOV R4, #1			;MOVO PARA R4 1
S4:	MOV R5, #10			;MOVO PARA R5 10
S3:	MOV R6, #100			;MOVO PARA R6 100
	DJNZ R6, $			;DECREMENTO R6 TRAVO AQUI
	DJNZ R5, S3			;DECREMENTO R5 E PULO PARA S3
	DJNZ R4, S4			;DECREMENTO R4 E PULO PARA S4
	RET				;RETORNO DE SUB-ROTINA
	
	END				;FIM DE PROGRAMA
