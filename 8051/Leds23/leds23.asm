; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  alternaled.asm  ver. 0.0 data: 23/04/13.   ========                          
; ========================================================================

;Programa para leitura dos ports

	ORG 0000H	;Inicio de Programa 
	MOV P0,#00H	;Limpo P0
	MOV P2,#0FFH	;Preparo P2 para leitura
	
	MOV A,#55H	;Movo para o Acc 55H
LOOP:   JB P2.0, LOOP	;Verifica o acionamento do botão P2.0
	CPL A		;Complemento Acc
	MOV P0,A 	;Move o dado do Acc para o Port
	JNB P2.0, $	;Verifico se esta 0 o botão P2.0
	CPL A		;Complemento Acc
	MOV P0, A 	;Movo o conteudo de Acc para P0
	SJMP LOOP	;Salta para loop
	
	



	
	
	
	END		;Fim de programa		
	
	



