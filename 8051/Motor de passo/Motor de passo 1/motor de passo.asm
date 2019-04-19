; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  motordepasso.asm  ver. 0.0 data: 04/06/13.   ======                          
; ========================================================================


;FAZER UM PROGRAMA P/ ACIONAR UM MOTOR DE PASSO
;P2.0 - GIRA NO SENTIDO HORÁRIO
;P2.7 - GIRA NO SENTIDO ANTI-HORÁRIO		
		
		ORG 0000H			;Inicio de Programa 
LOOP:		MOV P1,#00H			;Limpo P0
		MOV P2,#0FFH			;Preparo P2 para leitura
		
		
HORARIO:       JB P2.0, ANTI_HORARIO		;VERIFICO ACIONAMENTO DO BOTÃO, PULO PARA ANTI-HORARIO
               MOV P1, #08H			;MOVO PARA P1 08H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P1, #04H			;MOVO PARA P1 04H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P1, #02H			;MOVO PARA P1 02H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P1, #01H			;MOVO PARA P1 01H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               SJMP HORARIO			;SALTO PARA HORARIO
               
ANTI_HORARIO:  JB P2.7, HORARIO			;VERIFICO ACIONAMENTO DO BOTÃO, PULO PARA HORARIO
               MOV P1, #01H			;MOVO PARA P1 01H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P1, #02H			;MOVO PARA P1 02H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P1, #04H			;MOVO PARA P1 04H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               MOV P1, #08H 			;MOVO PARA P1 08H
               LCALL TEMPO			;SUB-ROTINA DE TEMPO
               SJMP ANTI_HORARIO          	;SALTO PARA ANTI-HORARIO




	;SUB-ROTINA TEMPO=(250X250X2X2)uS= 250000uS=250ms
TEMPO:  MOV R0, #2                              ;CARREGA RO COM 2
VOLTA2: MOV R1, #60      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #200	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
        END                                     ;FIM DO PROGRAMA		