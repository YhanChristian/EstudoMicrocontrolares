; =============================================================================
; =================      ETEC Aristóteles Ferreira.    ========================
; ================         Yhan Christian Souza Silva.           ==============
; ===============      teclado16.asm data: 22/05/13.    =======================                         
; =============================================================================


INICIO:      MOV P0, #0FFH	;PREPARA P2 PARA LEITURA
             MOV P1, #0FFH      ;MOVO FF PARA P1 

;----------------------------------------------------------------------------------------------
		;EQUIVALENCIAS        
            
             COL_0 EQU P2.0     ;COLUNA 0 EQUIVALE A P2.0	
             COL_1 EQU P2.1	;COLUNA 1 EQUIVALE A P2.1
             COL_2 EQU P2.2	;COLUNA 2 EQUIVALE A P2.2
             COL_3 EQU P2.3	;COLUNA 3 EQUIVALE A P2.3
             
             LIN_1 EQU P2.4	;LINHA 1 EQUIVALE A P2.4
             LIN_2 EQU P2.5	;LINHA 2 EQUIVALE A P2.5
             LIN_3 EQU P2.6	;LINHA 3 EQUIVALE A P2.6
             LIN_4 EQU P2.7 	;LINHA 4 EQUIVALE A P2.7
             
;-------------------------------------------------------------------------------------------------             
		;VARREDURA


COLUNA_0:    LCALL TEMPO	;LEITURA COLUNA ZERO/SUB-ROTINA DE TEMPO		
	     CLR COL_0		;LIMPO COLUNA 0
S0:          JB LIN_1, S1	;VERIFICO BOTÃO S0 DA LINHA 1/PULO PRA S1	
             MOV P0, #0FH	;MOVO PARA P0 O DADO 0FH
S1:          JB LIN_2, S2	;VERIFICO BOTÃO S1 DA LINHA 2/PULO PRA S2
             MOV P0, #0EH	;MOVO PARA P0 O DADO 0EH
S2:          JB LIN_3, S3	;VERIFICO BOTÃO S2 DA LINHA 3/PULO PRA S3
             MOV P0, #0DH	;MOVO PARA P0 O DADO 0DH
S3:          JB LIN_4, SETAR	;VERIFICO BOTÃO S3 DA LINHA 4/PULO PARA SETAR
             MOV P0, #0CH 	;MOVO PARA P0 O DADO 0CH
SETAR:       SETB COL_0		;SETO A COLUNA 0
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
              
             
COLUNA_1:    CLR COL_1		;LIMPO COLUNA 1
S4:          JB LIN_1, S5	;VERIFICO BOTÃO S4 DA LINHA 1/PULO PARA S5
             MOV P0, #0BH 	;MOVO PARA P0 O DADO 0BH
S5:          JB LIN_2, S6	;VERIFICO O BOTÃO S5 DA LINHA 2/PULO PARA S6
             MOV P0, #03H	;MOVO PARA P0 O DADO 3H
S6:          JB LIN_3, S7	;VERIFICO O BOTÃO S6 DA LINHA 3/PULO PARA S7
             MOV P0, #06H	;MOVO PARA P0 O DADO 6H
S7:          JB LIN_4, SETAR2	;VERIFICO O BOTÃO S7 DA LINHA 4/PULO PARA SETAR2
             MOV P0, #09H	;MOVO PARA P0 O DADO 9H
SETAR2:      SETB COL_1		;SETO A COLUNA 1
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
             
COLUNA_2:    CLR COL_2		;LIMPO COLUNA 2
S8:          JB LIN_1, S9	;VERIFICO O BOTÃO S8 DA LINHA 1/PULO PARA S9
             MOV P0, #00H	;MOVO PARA P0 00H
S9:          JB LIN_2, S10	;VERIFICO O BOTÃO S9 DA LINHA 2/PULO PARA S10
             MOV P0, #02H	;MOVO PARA P0 2H
S10:         JB LIN_3, S11	;VERIFICO O BOTÃO S10 DA LINHA 3/PULO PARA S11
             MOV P0, #05H	;MOVO PARA P0 5H
S11:         JB LIN_4, SETAR3	;VERIFICO O BOTÃO S11 DA LINHA 4/PULO PARA SETAR3
             MOV P0, #08H	;MOVO PARA P0 8H
SETAR3:      SETB COL_2		;SETO A COLUNA 2
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
              
           
COLUNA_3:    CLR COL_3		;LIMPO COLUNA 3
S12:         JB LIN_1, S13	;VERIFICO O BOTÃO S12 DA LINHA 1/PULO PARA S13
             MOV P0,#0AH	;MOVO PARA P0 0AH
S13:	     JB LIN_2, S14	;VERIFICO O BOTÃO S13 DA LINHA 2/PULO PARA S14
	     MOV P0,#01H	;MOVO PARA P0 1H
S14:         JB LIN_3, S15	;VERIFICO O BOTÃO S14 DA LINHA 3/PULO PARA S15
             MOV P0,#04H	;MOVO PARA P0 4H
S15:	     JB LIN_4, SETAR4	;VERIFICO O BOTÃO S15 DA LINHA 4/PULO PARA SETAR4
	     MOV P0,#07H	;MOVO PARA P0 7H
SETAR4:	     SETB COL_3		;SETO A COLUNA 3
	     LCALL TEMPO	;SUB-ROTINA DE TEMPO
	
	     LJMP COLUNA_0	;VOLTO PARA COLUNA 0
	
	    		
;--------------------------------------------------------------------------------------------             
             
	;SUBROTINA TEMPO
	
	
TEMPO:  MOV R0, #2                    	        ;CARREGA RO COM 2
VOLTA2: MOV R1, #25		                ;CARREGA R1 COM 25
VOLTA1: MOV R2, #50	                        ;CARREGA R2 COM 50
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
	END					;FIM DE PROGRAMA	
             