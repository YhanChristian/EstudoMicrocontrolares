; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  esteirademetais.asm  ver. 0.0 data: 28/02/14.   ======                          
; ========================================================================


;PROGRAMA DA ESTEIRA EM DESENVOLVIMENTO
	
		
		ORG 0000H			;Inicio de Programa 
		MOV P0,#00 			;Limpo P0
		MOV P2,#0FFH			;Preparo P2 para leitura
		LJMP INICIO
		ORG 0003H
 INT_0:		MOV P0,#0000H
  		MOV P0, #08			;MOVO PARA P1 08H
                LCALL TEMPO			;SUB-ROTINA DE TEMPO
                MOV P0, #04			;MOVO PARA P1 04H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P0, #02			;MOVO PARA P1 02H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P0, #01			;MOVO PARA P1 01H
               LCALL TEMPO
               MOV P0,#00H	
	       RETI
				
		
		
		ORG 0050H
INICIO:		MOV SP,#030H			;Carrega SP com 30, evitar problema com pilha
		MOV IE,#10000001B
		JB P3.2,LOOP
		CLR IT0
		SJMP LOOP


		
		
LOOP:          MOV P0, #0F8H			;MOVO PARA P1 08H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P0, #0F4H			;MOVO PARA P1 04H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P0, #0F2H			;MOVO PARA P1 02H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P0, #0F1H			;MOVO PARA P1 01H
               LCALL TEMPO
               MOV P0,#0F0H			
               SJMP LOOP			;SALTO PARA INICIO
 			
 
               
          



	;SUB-ROTINA TEMPO=(250X250X2X2)uS= 250000uS=250ms
TEMPO:  MOV R0, #4                              ;CARREGA RO COM 2
VOLTA2: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA		