; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  exercicio6.asm  ver. 0.0 data: 04/05/13.   ========                          
; ========================================================================


; Fazer um programa que contenha 3 chaves
;P2.7 = CHAVE GERAL
;P2.0 = LIGA E EXECUTA AÇÃO SEQUENCIA_01
;P2.1 = LIGA E EXECUTA AÇÃO SEQUENCIA_02


		

		ORG 0000H			;Inicio de Programa 
LOOP:		MOV P0,#00H			;Limpo P0
		MOV P2,#0FFH			;Preparo P2 para leitura
		
		
		
 		

		 
SEQUENCIA_01:	 JB P2.0, SEQUENCIA_02		;Verifico o Acionamento do botão P2.0, pulo para rotina Sequencia_02
		 JNB P2.7, GERAL		;Verifico se não foi acionado o botão P2.7, pulo para rotina GERAL
		 MOV A,#0FH			;Movo o dado 0Fh para o Acc
		 MOV P0,A			;Movo o dado de Acc para P0
		 LCALL TEMPO			;Sub-rotina de tempo
		 CPL A				;Complemento o valor de Acc
		 MOV P0, A			;Movo o dado de Acc para P0
		 LCALL TEMPO			;Sub-rotina de tempo
		 						 
SEQUENCIA_02:	JB P2.1, GERAL			;Verifico o Acionamento do botão P2.1, pulo para rotina GERAL
		JNB P2.7, GERAL			;Verifico se não foi acionado o botão P2.7, pulo para rotina GERAL
		MOV A,#55H			;Movo o dado 55h para o Acc
		MOV P0,A			;Movo o dado de Acc para P0		
		LCALL TEMPO			;Sub-rotina de tempo
		CPL A				;Complemento o valor de Acc
		MOV P0,A 			;Movo o dado de Acc para P0
		LCALL TEMPO			;Sub-rotina de tempo
											
GERAL:		JB P2.7, SEQUENCIA_01		;Verifico o Acionamento do botão P2.1, pulo para rotina Sequencia_01	
		CLR A				;Limpo Acc	
		MOV P0,A			;Movo o dado para P0
		MOV P0,#00H			;Limpo P0	
		LCALL TEMPO			;Sub-rotina de tempo	
		SJMP LOOP			;Salto para LOOP
	
	
	
	;SUB-ROTINA TEMPO=(250X250X2X2)uS= 250000uS=250ms
TEMPO:  MOV R0, #2                              ;CARREGA RO COM 2
VOLTA2: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA	
			

        
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

     

					
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
