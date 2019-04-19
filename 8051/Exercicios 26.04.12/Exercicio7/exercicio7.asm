; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  exercicio7.asm  ver. 0.0 data: 04/05/13.   ========                          
; ========================================================================



;FAZER UM PROGRAMA QUE CONTENHA DUAS CHAVES: 

;P2.0 = CHAVE GERAL
;P3.2 = EXECUTA SEQUENCIA_01  E  QUANDO PRESSIONADO  EXECUTA SEQUENCIA_02.


		

		ORG 0000H				;Inicio de Programa 
		MOV P0,#00H				;Limpo P0
		MOV P2,#0FFH				;Preparo P2 para leitura
		
		

	
	      
LOOP:        	 JB P3.2, GERAL				;Verifica o acionamento do botão P3.2, pulo para rotina GERAL
		 JNB P2.0, GERAL			;Verifico o Acionamento do botão P2.0, pulo para rotina GERAL	
		 MOV A,#55H				;Movo para o Acc 55H
	         CPL A					;Complemento Acc
	         MOV P0,A 		                ;Move o dado do Acc para o Port
	         JNB P3.2, $				;Verifico se esta 0 o botão P2.0
	         CPL A					;Complemento Acc
	         MOV P0, A 				;Movo o conteudo de Acc para P0
	         SJMP LOOP			        ;Salta para loop		
		


GERAL:		 JB P2.0, LOOP				;Verifico o Acionamento do botão P2.1, pulo para rotina LOOP	
		CLR A					;Limpo Acc	
		MOV P0,A				;Movo o dado para P0
		MOV P0,#00H				;Limpo P0	
		LCALL TEMPO				;Subrotina de tempo	
		SJMP LOOP				;Salto para LOOP
	
	

	
	;SUBROTINA TEMPO 
	
TEMPO:  MOV R0, #2                               ;CARREGA RO COM 2
VOLTA2: MOV R1, #250      	                 ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END					;FIM DE PROGRAMA
        
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

     

					
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
