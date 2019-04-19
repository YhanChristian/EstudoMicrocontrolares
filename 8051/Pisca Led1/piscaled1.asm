; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_01  piscaled.asm  ver. 0.0 data: 09/04/13.   =========                          
; ========================================================================


;Programa para piscar o LED

	ORG 0000H  				;INICIO DE PROGRAMA
	MOV P0, #00H 				; LIMPO P0                            
	
 	SETB P0.0				;SETAR BIT P0.0


	                      
LOOP: 	 LCALL TEMPO                             ;CHAMA A SUBROTINA TEMPO

        CPL P0.0                            	;COMPLETO DO CONTEUDO DO BIT P0.0
        SJMP LOOP                               ;SALTA PARA O LABEL LOOP
        

	;SUBROTINA TEMPO=(250X250X2X2)uS= 250000uS=250ms
TEMPO:  MOV R0, #2                              ;CARREGA RO COM 2
VOLTA2: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA