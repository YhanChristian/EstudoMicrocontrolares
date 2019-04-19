; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_01  alternaled.asm  ver. 0.0 data: 09/04/13.   =========                          
; ========================================================================


;Programa para acender um led por bez sequencialmente

	ORG 0000H  				;INICIO DE PROGRAMA
	MOV P0, #00H 				; LIMPO P0                            
	

LOOP: 	SETB P0.0				;SETAR BIT P0.0


	                      
	LCALL TEMPO                             ;CHAMA A SUBROTINA TEMPO
        CPL P0.0                            	;COMPLETO DO CONTEUDO DO BIT P0.0                                        
        SETB P0.1
        LCALL TEMPO                                        
        CPL P0.1
        SETB P0.2
        LCALL TEMPO
        CPL P0.2
        SETB P0.3
        LCALL TEMPO
        CPL P0.3
        SETB P0.4
        LCALL TEMPO
        CPL P0.4
        SETB P0.5
        LCALL TEMPO
        CPL P0.5
        SETB P0.6
        LCALL TEMPO
        CPL P0.6
        SETB P0.7
        LCALL TEMPO
        CPL P0.7
        
        SETB P0.6
        LCALL TEMPO
        CPL P0.6
        SETB P0.5
        LCALL TEMPO
        CPL P0.5
        SETB P0.4
        LCALL TEMPO
        CPL P0.4
        SETB P0.3
        LCALL TEMPO
        CPL P0.3
        SETB P0.2
        LCALL TEMPO
        CPL P0.2
        SETB P0.1
        LCALL TEMPO                                        
        CPL P0.1
        SETB P0.0
        LCALL TEMPO                             ;CHAMA A SUBROTINA TEMPO
        CPL P0.0  
        
        SJMP LOOP

	;SUBROTINA TEMPO=(250X250X2X1)uS= 125000uS=125ms
TEMPO:  MOV R0, #1                                ;CARREGA RO COM 2
VOLTA2: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA