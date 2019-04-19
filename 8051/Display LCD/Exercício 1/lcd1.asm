; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  lcd1.asm  ver. 0.0 data: 07/07/13.   ==============                          
; ========================================================================


; EXEMPLO DE ESCRITA NO LCD, NELE ESCREVEMOS UM NOME CARACTER POR CARACTER 

; DADOS/INSTRUÇÕES -> 8 BIT PORT P1
; R/W -> TERRA   
; E -> P3.0    
; RS -> P3.1

;--------------------------------------------------------------------------------
		; DEFINIÇÕES

           
           E 	EQU 	P3.0                	; E = PINO P3.7
           RS 	EQU 	P3.1               	; RS = PINO P3.6
		

           ORG 0000H                 		; END. DE INÍCIO DE ESCRITA NA ROM

;--------------------------------------------------------------------------------
		; ROTINA INICIAL

           CLR A                     		; LIMPO ACC
           MOV SP, #30H               		; APONTO A PILHA P/ O ENDEREÇO 30H
           MOV P1, #00H               		; ZERO P1
           

;--------------------------------------------------------------------------------
		; ROTINA DE INICIALIZAÇÃO DO LCD

           	CLR RS                    	; RS EM 0 - PARA ENVIO DE INSTRUÇÃO
           	MOV A, #38H                	; CONFIGURO DISPLAY 2 LINHAS MATRIZ 5X7
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           	MOV A, #06H                	; ESCREVE DESLOCANDO O CURSOR P/ DIREITA.
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           	MOV A, #0CH                	; DISPLAY ACESO SEM CURSOR
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           	MOV A, #01H                	; LIMPA O DISPLAY
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA

;--------------------------------------------------------------------------------
		; ROTINA PARA A ESCRITA DE CADA CARACTER DE UM NOME
         
    		SETB RS                   	; RS EM 1 - PARA ENVIO DE DADOS
           	MOV A, #'Y'                	; MOVO O DADO Y EM ASCII PARA ACC
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           	MOV A, #'H'                	; MOVO O DADO H EM ASCII PARA ACC
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           	MOV A, #'A'                	; MOVO O DADO A EM ASCII PARA ACC
           	LCALL ESCREVE     		; CHAMA ROTINA DE ESCRITA
           	MOV A, #'N'        		; MOVO O DADO N EM ASCII PARA ACC
		LCALL ESCREVE			; CHAMA ROTINA DE ESCRITA
		
;--------------------------------------------------------------------------------
		; ESPAÇO                   		 	
           
		CLR RS                    	; ENVIO DE INSTRUÇÃO
           	MOV A, #14H                	; DESLOCA SOMENTE O CURSOR PARA A DIREITA
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA

;--------------------------------------------------------------------------------
; CONTINUA ESCREVENDO OS CARACTERES

           SETB RS                   	; RS EM 1 - PARA ENVIO DE DADOS
           MOV A, #'C'                	; MOVO O DADO C EM ASCII PARA ACC
           LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA	
           MOV A, #'H'                	; MOVO O DADO H EM ASCII PARA ACC
           LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           MOV A, #'R'                	; MOVO O DADO R EM ASCII PARA ACC
           LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           MOV A, #'I'                	; MOVO O DADO I EM ASCII PARA ACC
           LCALL ESCREVE		; CHAMA ROTINA DE ESCRITA
           MOV A, #'S'			; MOVO O DADO S EM ASCII PARA ACC
           LCALL ESCREVE		; CHAMA ROTINA DE ESCRITA
           MOV A, #'T'			; MOVO O DADO T EM ASCII PARA ACC
           LCALL ESCREVE		; CHAMA ROTINA DE ESCRITA
           MOV A, #'I'			; MOVO O DADO I EM ASCII PARA ACC
           LCALL ESCREVE		; CHAMA ROTINA DE ESCRITA
           MOV A, #'A'			; MOVO O DADO A EM ASCII PARA ACC
           LCALL ESCREVE		; CHAMA ROTINA DE ESCRITA	
           MOV A, #'N'			; MOVO O DADO N EM ASCII PARA ACC
           LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA
           SJMP $                    	; TRAVO AQUI

;--------------------------------------------------------------------------------
		; ROTINA PARA A ESCRITA    		 	

ESCREVE: 	MOV P1, A                  	; COLOCA O CARACTER NO PORT 1
           	SETB E                    	; E=1
           	LCALL ATRASO              	; CHAMA ATRASO DE 10MS
           	CLR E                     	; E=0 (DADOS/INSTRUÇÕES SÃO LIDOS NA TRANSIÇÃO DE 0 P/ 1.                 
           	RET                       	; RETORNA DA SUBROTINA
		
	
;--------------------------------------------------------------------------------	
		; ROTINA PARA TEMPO DE ATRASO, APROXIMADAMENTE 10MS
   
ATRASO:		MOV R0, #2                   	;MOVO PARA R0 2
VOLTA2: 	MOV R1, #10                 	;MOVO PARA R1 1O
VOLTA1:        	MOV R2, #250			;MOVO PARA R2 250
           	DJNZ R2, $			;DECREMENTO R2 E TRAVO AQUI
		DJNZ R1, VOLTA1			;DECREMENTO R1 ATÉ ZERO E PULO PARA VOLTA1
		DJNZ R0, VOLTA2			;DECREMENTO R0 ATÉ ZERO E PULO PARA VOLTA2
		RET                       	; RETORNA DA SUBOTINA
           	END                       	; FIM DE COMPILAÇÃO
