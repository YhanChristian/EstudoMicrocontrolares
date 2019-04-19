; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_01  piscaled.asm  ver. 0.0 data: 09/04/13.   =========                          
; ========================================================================


;Programa para acender os leGds pares e impares alternadamente

	ORG 0000H                               ;INÍCIO DO PROGRAMA
	MOV P0, #00H                            ;LIMPO P0
LOOP: 	MOV P0, #81H				;MANDO O DADO 81H PARA P0
	LCALL TEMPO	
 	MOV P0,	#42H				;MANDO O DADO 42H PARA P0
 	LCALL TEMPO				
 	MOV P0, #24H				;MANDO O DADO 24H PARA P0
 	LCALL TEMPO
 	MOV P0,#18H				;MANDO O DADO 18H PARA P0
        LCALL TEMPO
        SJMP LOOP
        
        
;SUBROTINA TEMPO=(250X250X2X8)uS= 1000000uS=1s
TEMPO:  MOV R0, #2                              ;CARREGA RO COM 8
VOLTA2: MOV R1, #250                          ;CAREGA R1 COM 125
VOLTA1: MOV R2, #250                           ;CAREGA R2 COM 125
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA
