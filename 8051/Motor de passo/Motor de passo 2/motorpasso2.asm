; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  motordepasso2.asm  ver. 0.0 data: 16/06/13.  ======                          
; ========================================================================


;Motor de passo botão de liga/desliga c/ inversão 2

	
	
	
	ORG 0000H	        	;INICIO DE PROGRAMA
	MOV P2, # 0FFH  	 	;PREPARO P2 PARA LEITURA
	SETB P3.2           		;SETO P3.2 PREPARANDO PARA LEITURA
	MOV A, #66H      		;MOVO O DADO 66H PARA ACC, CARREGANDO SEQUENCIA DE HALF-STEP		


		
S1:	JNB P2.0, S0       		;VERIFICO ACIONAMENTO DO BOTÃO PULO PARA S0
	MOV P0, #00H     		;MOVO O DADO 00H PARA P0
	MOV P1, #00H     		;LIMPO P1	
	JB P2.0, $	        	;TRAVO NA LINHA AGUARDO LIBERAÇÃO DO BOTÃO	
		
S0:	JB P3.2, S2	      		;VERIFICO ACIONAMENTO DO BOTÃO PULO PARA S2
	CPL C	       			;COMPLEMENTO CARRY
	JNB P3.2, $	      		;TRAVO NA LINHA AGUARDO LIBERAÇÃO DO BOTÃO
	LCALL DELAY    			;SUB-ROTINA DELAY
S2:	JC LOOP	      			;SALTO PARA LOOP SE CARRY FOR "1"
	SJMP LOOP1   			;SALTO PARA LOOP SE CARRY FOR "0"	
		
LOOP:	MOV P0, A	      		;MOVO PARA P0 O DADO DE ACC
	MOV P1, A	      		;ACIONO MOTOR DE PASSO
	LCALL TEMPO  			;SUB-ROTINA TEMPO
	RR A	      			;ROTACIONO O DADO DE ACC PARA DIREITA
	SJMP S1	      			;SALTO PARA S1
	
LOOP1:	MOV P0, A  			;MOVO PARA P0 O DADO DE ACC
	MOV P1, A			;ACIONO MOTOR DE PASSO
	LCALL TEMPO  			;SUB-ROTINA TEMPO	
	RL A				;ROTACIONO O DADO DE ACC PARA ESQUERDA
	SJMP S1				;SALTO PARA S1

;-----------------------------------------------------------------------------------
		;SUB-ROTINA TEMPO/DELAY

				
TEMPO: 	MOV R0,#1			;MOVO PARA R0 1
VOLTA2: MOV R1,#250       		;MOVO PARA R1 250
VOLTA1: MOV R2,#250       	        ;MOVO PARA R2 250  	
	DJNZ R2,$         	        ;DECREMENTO R2, TRAVO AQUI  	
	DJNZ R1,VOLTA1    	        ;DECREMENTO R1 E PULO PARA VOLTA 1  	
	DJNZ R0,VOLTA2    	        ;DECREMENTO R0 E PULO PARA VOLTA 2  	
	RET               		;RETORNO DE SUB-ROTINA

DELAY: 	MOV R0,#2  			;MOVO PARA R0 2       	
J2: 	MOV R1,#10       		;MOVO PARA R1 10
J1: 	MOV R2,#250     		;MOVO PARA R2 250  	          	
	DJNZ R2,$         		;DECREMENTO R2, TRAVO AQUI
	DJNZ R1,J1    	          	;DECREMENTO R1 E PULO PARA J1
	DJNZ R0,J2    	          	;DECREMENTO R0 E PULO PARA J2
	RET               		;RETORNO DE SUB-ROTINA
	
	
	END				;FIM DE PROGRAMA
	
	
		
