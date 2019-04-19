; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  progsenha.asm  ver. 0.1 data: 27/05/13.   =========                          
; ========================================================================


;Fazer um programa para acionar uma fechadura eletrônica
;Deverá possuir:
;Senha de 9 digitos qualquer
;Display para contar o número de teclas pressionadas
; * Limpa todos os digitos e volta para inicio
; # Para confirmação ENTER
;Digitar os 6 números depois digitar ENTER
;Se correta libera a fechadura
;Se incorreta toca o BUZZER
; para calar o BUZZER pressionar e soltar # 3 vezes


		ORG 0000H
		MOV P2,#00H
		MOV P1,#0FFH
		MOV SP,#60H
		MOV R0,#30H
		LCALL TEMPO
;------------------------------------------------------------------------------
	  		   ;EQUIVALENCIA
            
             LIN_0 EQU P2.7		;LINHA 1 EQUIVALE A P2.7
             LIN_1 EQU P2.6		;LINHA 2 EQUIVALE A P2.6
             LIN_2 EQU P2.5		;LINHA 3 EQUIVALE A P2.5
             LIN_3 EQU P2.4 		;LINHA 4 EQUIVALE A P2.4
             
             COL_3 EQU P2.3     	;COLUNA 0 EQUIVALE A P2.3	
             COL_2 EQU P2.2		;COLUNA 1 EQUIVALE A P2.2
             COL_1 EQU P2.1		;COLUNA 2 EQUIVALE A P2.1
             COL_0 EQU P2.0     	;COLUNA 3 EQUIVALE A P2.0

;------------------------------------------------------------------------------
			;VARREDURA TECLADO
		 
             
COLUNA0:     CLR COL_0		;LIMPO COLUNA 0
             JNB LIN_0, S0	;VERIFICO ACIONAMENTO DO BOTÃO S0 DA LINHA 0
LINHA1:      JNB LIN_1, S1      ;VERIFICO ACIONAMENTO DO BOTÃO S1 DA LINHA 1
LINHA2:      JNB LIN_2, S2	;VERIFICO ACIONAMENTO DO BOTÃO S2 DA LINHA 2
LINHA3:      JNB LIN_3, S3	;VERIFICO ACIONAMENTO DO BOTÃO S3 DA LINHA 3
LINHA0:      SETB COL_0		;SETO COLUNA 0	
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
             LJMP COLUNA1       ;SALTO PARA COLUNA 1      

S0:          MOV A, #01H	
             MOV @R0,A
             INC R0
             MOV P1, A
             CLR P3.7	    	
             JNB P2.0, $	
             SETB P3.7		
             LJMP LINHA1	

S1:	     MOV A, #04H	
	     MOV @R0,A	
             INC R0
             MOV P1, A
             CLR P3.7
             JNB P2.1, $
             SETB P3.7
             LJMP LINHA2
             
S2:	    MOV A, #07H	             
            MOV @R0,A
            INC R0
            MOV P1, A
            CLR P3.7
            JNB P2.2, $
            SETB P3.7
            LJMP LINHA3
            
S3:	   MOV A, #0AH
	   MOV @R0,A
	   INC R0
	   MOV P1, A
	   CLR P3.7
	   JNB P2.3, $
	   SETB P3.7
	   LJMP LINHA0		            
	   
	   
COLUNA1:     CLR COL_1		;LIMPO COLUNA 1 
             JNB LIN_0, S4	;VERIFICO ACIONAMENTO DO BOTÃO S4 DA LINHA 0
LINHA1_1:    JNB LIN_1, S5      ;VERIFICO ACIONAMENTO DO BOTÃO S5 DA LINHA 1 
LINHA2_1:    JNB LIN_2, S6	;VERIFICO ACIONAMENTO DO BOTÃO S6 DA LINHA 2
LINHA3_1:    JNB LIN_3, S7	;VERIFICO ACIONAMENTO DO BOTÃO S7 DA LINHA 3
LINHA0_1:    SETB COL_1		;SETO COLUNA 1
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
             LJMP COLUNA2	;SALTO PARA COLUNA 2
             
             
S4:          MOV A, #02H	
             MOV @R0,A
             INC R0
             MOV P1, A
             CLR P3.7	    	
             JNB P2.0, $	
             SETB P3.7		
             LJMP LINHA1_1	

S5:	     MOV A, #05H	
	     MOV @R0,A	
             INC R0
             MOV P1, A
             CLR P3.7
             JNB P2.1, $
             SETB P3.7
             LJMP LINHA2_1
             
S6:	    MOV A, #08H	             
            MOV @R0,A
            INC R0
            MOV P1, A
            CLR P3.7
            JNB P2.2, $
            SETB P3.7
            LJMP LINHA3_1
            
S7:	   MOV A, #00H
	   MOV @R0,A
	   INC R0
	   MOV P1, A
	   CLR P3.7
	   JNB P2.3, $
	   SETB P3.7
	   LJMP LINHA0_1
	   
COLUNA2:     CLR COL_2		;LIMPO COLUNA 2
             JNB LIN_0, S8	;VERIFICO ACIONAMENTO DO BOTÃO S8 DA LINHA 0
LINHA1_2:    JNB LIN_1, S9      ;VERIFICO ACIONAMENTO DO BOTÃO S9 DA LINHA 1 
LINHA2_2:    JNB LIN_2, S10	;VERIFICO ACIONAMENTO DO BOTÃO S10 DA LINHA 2
LINHA3_2:    JNB LIN_3, S11	;VERIFICO ACIONAMENTO DO BOTÃO S11 DA LINHA 3
LINHA0_2:    SETB COL_2		;SETO COLUNA 2
             LCALL TEMPO	;SUB-ROTINA DE TEMPO	
             LJMP COLUNA3	;SALTO PARA COLUNA 3
             
             	   	             	   
S8:          MOV A, #03H	
             MOV @R0,A
             INC R0
             MOV P1, A
             CLR P3.7	    	
             JNB P2.0, $	
             SETB P3.7		
             LJMP LINHA1_2	

S9:	     MOV A, #06H	
	     MOV @R0,A	
             INC R0
             MOV P1, A
             CLR P3.7
             JNB P2.1, $
             SETB P3.7
             LJMP LINHA2_2
             
S10:	    MOV A, #09H	             
            MOV @R0,A
            INC R0
            MOV P1, A
            CLR P3.7
            JNB P2.2, $
            SETB P3.7
            LJMP LINHA3_2
            
S11:	   MOV A, #0BH
	   MOV @R0,A
	   INC R0
	   MOV P1, A
	   CLR P3.7
	   JNB P2.3, $
	   SETB P3.7
	   LJMP LINHA0_2
	   
COLUNA3:     CLR COL_3		;LIMPO COLUNA 3
             JNB LIN_0, S12	;VERIFICO ACIONAMENTO DO BOTÃO S12 DA LINHA 1
LINHA1_3:    JNB LIN_1, S13    	;VERIFICO ACIONAMENTO DO BOTÃO S13 DA LINHA 2   
LINHA2_3:    JNB LIN_2, S14	;VERIFICO ACIONAMENTO DO BOTÃO S14 DA LINHA 3
LINHA3_3:    JNB LIN_3, S15	;VERIFICO ACIONAMENTO DO BOTÃO S15 DA LINHA 0
LINHA0_3:    SETB COL_3		;SETO COLUNA 3	
             LCALL TEMPO	;SUB-ROTINA DE TEMPO
             LJMP COLUNA0	;SALTO PARA COLUNA 0
             
             
S12:         MOV A, #0DH	
             MOV @R0,A
             INC R0
             MOV P1, A
             CLR P3.7	    	
             JNB P2.0, $	
             SETB P3.7		
             LJMP LINHA1_3	

S13:	     MOV A, #0CH	
	     MOV @R0,A	
             INC R0
             MOV P1, A
             CLR P3.7
             JNB P2.1, $
             SETB P3.7
             LJMP LINHA2_3
             
S14:	    MOV A, #0EH	             
            MOV @R0,A
            INC R0
            MOV P1, A
            CLR P3.7
            JNB P2.2, $
            SETB P3.7
            LJMP LINHA3_3
            
S15:	   MOV A, #0FH
	   MOV @R0,A
	   INC R0
	   MOV P1, A
	   CLR P3.7
	   JNB P2.3, $
	   SETB P3.7
	   LJMP LINHA0_3             
             	   	   
             	   	   
             	   	   
             	   	   
;------------------------------------------------------------------------------
		;SUBROTINA TEMPO
		
TEMPO:  MOV R0, #2                    	        ;CARREGA RO COM 2
VOLTA2: MOV R1, #25		                ;CARREGA R1 COM 25
VOLTA1: MOV R2, #50	                        ;CARREGA R2 COM 50
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERA
        RET                                     ;RETORNO DE SUBROTINA
	END					;FIM DE PROGRAMA	
             
             