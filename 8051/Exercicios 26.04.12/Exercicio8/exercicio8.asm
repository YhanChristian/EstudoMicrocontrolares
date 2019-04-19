; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  exercicio8.asm  ver. 0.0 data: 04/05/13.   ========                          
; ========================================================================



;FAZER UM PROGRAMA QUE CONTENHA TRÊS CHAVES:
;P2.3 = CHAVE GERAL
; P2.0 P2.7
;  0    0 Sequencia 0	
;  0    1 Sequencia 1
;  1    0 Sequencia 2		
;  1    1 Sequencia 3



		ORG 0000H			;Inicio de Programa 
		MOV P0,#00H			;Limpo P0
		MOV P2,#0FFH			;Preparo P2 para leitura


LOOP:						;Loop começo 
		
		
SEQUENCIA_0: 	JNB P2.0, SEQUENCIA_2		;Verifico se P2.0 está em nivel lógico 0, pulo para Sequencia_2
		JNB P2.7, SEQUENCIA_1		;Verifico se P2.7 está em nivel lógico 0, pulo para Sequencia_1
		JNB P2.3, GERAL			;Verifico se P2.3 está em nivel lógico 0, pulo para GERAL
		MOV A, #0FH			;Movo para Acc o dado 0fh
		MOV P0, A			;Movo o dado de Acc para P0
		LCALL SEQUENCIA_3		;Chamo subrotina Sequencia_3
		SJMP LOOP			;Salto para loop
		
		
SEQUENCIA_1:	JB P2.7, SEQUENCIA_2		;Verifico o acionamento do botão P2.7, pulo para Sequencia_2
		JNB P2.3, GERAL			;Verifico se P2.3 está em nivel lógico 0, pulo para GERAL
		MOV A,#0F0H			;Movo para Acc o dado f0h
		MOV P0, A			;Movo o dado de Acc para P0
		LCALL SEQUENCIA_3		;Chamo subrotina Sequencia_3	
		SJMP LOOP			;Salto para loop
		
		
SEQUENCIA_2: 	JB P2.0, SEQUENCIA_3		;Verifico o acionamento do botão P2.0, pulo para Sequencia_3
		JNB P2.3, GERAL			;Verifico se P2.3 está em nivel lógico 0, pulo para GERAL
		MOV A,#55H			;Movo o dado 55h para Acc
		MOV P0, A			;Movo o  dado de Acc  para P0
		LCALL SEQUENCIA_3		;Chamo subrotina Sequencia_3
		SJMP LOOP			;Salto para loop
		
SEQUENCIA_3:	JB P2.0, SEQUENCIA_0		;Verifico o acionamento do botão P2.0, pulo para Sequencia_0
		JB P2.7, SEQUENCIA_0		;Verifico o acionamento do botão P2.7, pulo para Sequencia_3
		JNB P2.3, GERAL			;Verifico se P2.3 está em nivel lógico 0, pulo para GERAL
		MOV A,#0FFH 			;Movo o dado FFh para Acc
		MOV P0, A			;Movo o dado de Acc para P0
		LJMP LOOP			;Salto para loop	
		
GERAL:		JB P2.3, LOOP			;Verifico o Acionamento do botão P2.3, pulo para rotina LOOP	
		CLR A				;Limpo Acc	
		MOV P0,A			;Movo o dado para P0
		MOV P0,#00H			;Limpo P0	
		LJMP LOOP			;Salto para LOOP
	
				
		
		
		
		END				;Fim de programa
			
		

	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

     

					
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
