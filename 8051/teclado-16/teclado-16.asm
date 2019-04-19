; =============================================================================
; =================      ETEC Aristóteles Ferreira.    ========================
; ================     Yhan Christian Souza Silva       =======================
; ===============      teclado.asm data: 26/05/13.    =========================                         
; =============================================================================


             ORG 0000		;INICIO DE PROGRAMA
             MOV P0, #00H	;PREPARA P2 PARA LEITURA
             MOV P1, #0FFH      ;LIMPA P1

;-------------------------------------------------------------------------------             
            ;EQUIVALENCIA
            
             LIN_0 EQU P1.0	;LINHA 1 EQUIVALE A P1.0
             LIN_1 EQU P1.1	;LINHA 2 EQUIVALE A P1.1
             LIN_2 EQU P1.2	;LINHA 3 EQUIVALE A P1.2
             LIN_3 EQU P1.3 	;LINHA 4 EQUIVALE A P1.3
             
             COL_3 EQU P1.4     ;COLUNA 0 EQUIVALE A P1.4	
             COL_2 EQU P1.5	;COLUNA 1 EQUIVALE A P1.5
             COL_1 EQU P1.6	;COLUNA 2 EQUIVALE A P1.6
             COL_0 EQU P1.7     ;COLUNA 3 EQUIVALE A P1.7
 
;-------------------------------------------------------------------------------  
		;VARREDURAS
		 
             
COLUNA0:     CLR COL_0		;LIMPO COLUNA 0
             JNB LIN_0, S0	;VERIFICO ACIONAMENTO DO BOTÃO S0 DA LINHA 0
LINHA1:      JNB LIN_1, S1      ;VERIFICO ACIONAMENTO DO BOTÃO S1 DA LINHA 1
LINHA2:      JNB LIN_2, S2	;VERIFICO ACIONAMENTO DO BOTÃO S2 DA LINHA 2
LINHA3:      JNB LIN_3, S3	;VERIFICO ACIONAMENTO DO BOTÃO S3 DA LINHA 3
LINHA0:      SETB COL_0		;SETO COLUNA 0	
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
             LJMP COLUNA1       ;SALTO PARA COLUNA 1      

S0:          MOV P3, #01H	;MOVO PARA P3 01H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.0, $	;VERIFICO P1.0, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA1	;SALTO PARA LINHA 1

S1:          MOV P3, #04H	;MOVO PARA P3 04H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.1, $	;VERIFICO P1.1, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA2	;SALTO PARA LINHA 2
             
S2:          MOV P3, #07H	;MOVO PARA P3 07H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.2, $	;VERIFICO P1.2, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA3	;SALTO PARA LINHA 3

S3:          MOV P3, #0AH	;MOV PARA P3 0AH
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.3, $	;VERIFICO P1.3, TRAVO AQUI	
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA0	;SALTO PARA LINHA 0
             
COLUNA1:     CLR COL_1		;LIMPO COLUNA 1 
             JNB LIN_0, S4	;VERIFICO ACIONAMENTO DO BOTÃO S4 DA LINHA 0
LINHA1_1:    JNB LIN_1, S5      ;VERIFICO ACIONAMENTO DO BOTÃO S5 DA LINHA 1 
LINHA2_1:    JNB LIN_2, S6	;VERIFICO ACIONAMENTO DO BOTÃO S6 DA LINHA 2
LINHA3_1:    JNB LIN_3, S7	;VERIFICO ACIONAMENTO DO BOTÃO S7 DA LINHA 3
LINHA0_1:    SETB COL_1		;SETO COLUNA 1
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
             LJMP COLUNA2	;SALTO PARA COLUNA 2
             
S4:          MOV P3, #02H	;MOVO PARA P3 02H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.0, $	;VERIFICO P1.0, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA1_1	;SALTO PARA LINHA 1

S5:          MOV P3, #05H	;MOVO PARA P3 05H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.1, $	;VERIFICO P1.1, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA2_1	;SALTO PARA LINHA 2
             
S6:          MOV P3, #08H	;MOVO PARA P3 08H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.2, $	;VERIFICO P1.2, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA3_1	;SALTO PARA LINHA 3

S7:          MOV P3, #00H	;MOVO PARA P3 00H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.3, $	;VERIFICO P1.3, TRAVO AQUI	
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA0_1	;SALTO PARA LINHA 0
             
COLUNA2:     CLR COL_2		;LIMPO COLUNA 2
             JNB LIN_0, S8	;VERIFICO ACIONAMENTO DO BOTÃO S8 DA LINHA 0
LINHA1_2:    JNB LIN_1, S9      ;VERIFICO ACIONAMENTO DO BOTÃO S9 DA LINHA 1 
LINHA2_2:    JNB LIN_2, S10	;VERIFICO ACIONAMENTO DO BOTÃO S10 DA LINHA 2
LINHA3_2:    JNB LIN_3, S11	;VERIFICO ACIONAMENTO DO BOTÃO S11 DA LINHA 3
LINHA0_2:    SETB COL_2		;SETO COLUNA 2
             LCALL TEMPO	;SUB-ROTINA DE TEMPO	
             LJMP COLUNA3	;SALTO PARA COLUNA 3
             
S8:          MOV P3, #03H	;MOVO PARA P3 03H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.0, $	;VERIFICO P1.0, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA1_2	;SALTO PARA LINHA 1

S9:          MOV P3, #06H	;MOVO PARA P3 06H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.1, $	;VERIFICO P1.1, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA2_2	;SALTO PARA LINHA 2
             	
S10:         MOV P3, #09H	;MOVO PARA P3 09H
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.2, $	;VERIFICO P1.2, TRAVO AQUI	
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA3_2	;SALTO PARA LINHA 3

S11:         MOV P3, #0BH	;MOVO PARA P3 0BH
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.3, $	;VERIFICO P1.3, TRAVO AQUI	
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA0_2	;SALTO PARA LINHA 0
             
COLUNA3:     CLR COL_3		;LIMPO COLUNA 3
             JNB LIN_0, S12	;VERIFICO ACIONAMENTO DO BOTÃO S12 DA LINHA 1
LINHA1_3:    JNB LIN_1, S13    	;VERIFICO ACIONAMENTO DO BOTÃO S13 DA LINHA 2   
LINHA2_3:    JNB LIN_2, S14	;VERIFICO ACIONAMENTO DO BOTÃO S14 DA LINHA 3
LINHA3_3:    JNB LIN_3, S15	;VERIFICO ACIONAMENTO DO BOTÃO S15 DA LINHA 0
LINHA0_3:    SETB COL_3		;SETO COLUNA 3	
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
             LJMP COLUNA0	;SALTO PARA COLUNA 0
             
S12:         MOV P3, #0DH	;MOVO PARA P3 0DH
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.0, $	;VERIFICO P1.0, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA1_3	;SALTO PARA LINHA 1

S13:         MOV P3, #0CH	;MOVO PARA P3 0CH
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER 
             JNB P1.1, $	;VERIFICO P1.1, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA2_3	;SALTO PARA LINHA 2
             
S14:         MOV P3, #0EH	;MOVO PARA P3 0EH
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.2, $	;VERIFICO P1.2, TRAVO AQUI
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA3_3	;SALTO PARA LINHA 3

S15:         MOV P3, #0FH	;MOVO PARA P3 0FH		
             CLR P3.7		;LIMPO P3.7 PARA TOCAR O BUZZER
             JNB P1.3, $	;VERIFICO P1.3, TRAVO AQUI	
             SETB P3.7		;SETO P3.7 BUZZER PARA DE TOCAR
             LJMP LINHA0_3	;SALTO PARA LINHA 0
             
             

;-------------------------------------------------------------------------------            
	;SUBROTINA TEMPO

TEMPO:  MOV R0, #2                    	        ;CARREGA RO COM 1
VOLTA2: MOV R1, #50		                ;CARREGA R1 COM 50
VOLTA1: MOV R2, #50	                        ;CARREGA R2 COM 50
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
	END					;FIM DE PROGRAMA	
             