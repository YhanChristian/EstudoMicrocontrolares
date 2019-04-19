; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_01  rotacionar.asm  ver. 0.0 data: 09/04/13.   =========                          
; ========================================================================


;Programa para acender os leds pares e impares alternadamente

	ORG 0000H                               ;IN�CIO DO PROGRAMA
LOOP:	MOV R0, #80H                             ;MOVE O DADO 55H(B=10000000)
	MOV P0, R0                               ;MOVE O DADO DO ACUMULADOR PARA O PORT 0
	MOV A, R0
	RR A                                   ;ROTACIONO O BIT PELO A 
        MOV R0, A                        ;MOVE O CONTE�DO DO ACUMULADOR PARA O PORT 0
       	LCALL TEMPO
        CJNE A, #01H, LOOP    
	SJMP LOOP              
    
  	
          
        
;SUBROTINA TEMPO=(250X250X2X8)uS= 1000000uS=1s
TEMPO:  MOV R0, #8                              ;CARREGA RO COM 8
VOLTA2: MOV R1, #250                            ;CAREGA R1 COM 250
VOLTA1: MOV R2, #250                            ;CAREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 AT� ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA AT� ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA AT� ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA
