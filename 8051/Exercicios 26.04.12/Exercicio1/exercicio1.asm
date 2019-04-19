; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  exercicio1.asm  ver. 0.0 data: 27/04/13.   ========                          
; ========================================================================


;Um painel com tr�s bot�es para controlar duas esteiras de alimenta��o de uma m�quina
;, dependendo do tipo de pe�a a ser produzida ligamos manualmente uma das duas esteiras de mat�ria prima ou as duas juntas
;, al�m disso, existe um bot�o �nico para o desligamento das duas esteiras,
; no painel tamb�m existem dois led�s para sinaliza��o de qual esteira est� acionada.


		ORG 0000H		;Inicio de Programa 
		MOV P0,#00H		;Limpo P0
		MOV P2,#0FFH		;Preparo P2 para leitura
	

LOOP:  

		 JB P2.0,LOOP 		;Verifico o acionamento do bot�o P2.0
LED_01:		 SETB P0.0		;Coloco em n�vel l�gico 1 P0.0
			
		JB P2.1, LED_01		 ;Verifico o acionamento do bot�o P2.1			
LED_02:		SETB P0.1		;Coloco em nivel l�gico 1 PO.	
		JB P2.2, LED_02		;Verifico o acionamento do bot�o P2.2	
LED_03:		CLR P0.0		;Limpo P0.0
		CLR P0.1		;Limpo P0.1
		MOV P0,#00H		;Limpo o port
		LCALL TEMPO		;Chamo subrotina de tempo para atraso "Debounce"
		SJMP LOOP		;Volto ao Loop 			
	
	
	
	;SUBROTINA TEMPO
TEMPO:  MOV R0, #8                              ;CARREGA RO COM 8
VOLTA2: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 AT� ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA AT� ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA AT� ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA	
	



	
	
		
	
	



