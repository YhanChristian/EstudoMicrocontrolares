; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  exercicio1.asm  ver. 0.0 data: 27/04/13.   ========                          
; ========================================================================


;Um painel com três botões para controlar duas esteiras de alimentação de uma máquina
;, dependendo do tipo de peça a ser produzida ligamos manualmente uma das duas esteiras de matéria prima ou as duas juntas
;, além disso, existe um botão único para o desligamento das duas esteiras,
; no painel também existem dois led’s para sinalização de qual esteira está acionada.


		ORG 0000H		;Inicio de Programa 
		MOV P0,#00H		;Limpo P0
		MOV P2,#0FFH		;Preparo P2 para leitura
	

LOOP:  

		 JB P2.0,LOOP 		;Verifico o acionamento do botão P2.0
LED_01:		 SETB P0.0		;Coloco em nível lógico 1 P0.0
			
		JB P2.1, LED_01		 ;Verifico o acionamento do botão P2.1			
LED_02:		SETB P0.1		;Coloco em nivel lógico 1 PO.	
		JB P2.2, LED_02		;Verifico o acionamento do botão P2.2	
LED_03:		CLR P0.0		;Limpo P0.0
		CLR P0.1		;Limpo P0.1
		MOV P0,#00H		;Limpo o port
		LCALL TEMPO		;Chamo subrotina de tempo para atraso "Debounce"
		SJMP LOOP		;Volto ao Loop 			
	
	
	
	;SUBROTINA TEMPO
TEMPO:  MOV R0, #8                              ;CARREGA RO COM 8
VOLTA2: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA	
	



	
	
		
	
	



