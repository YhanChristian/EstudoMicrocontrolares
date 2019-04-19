;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       ETEC ARISTOTELES FERREIRA.        ;;
;;         3A3 - 1º SEMESTRE 2013          ;;
;;         PROGRAMA: - LCD_01.ASM          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; EXEMPLO DE ESCRITA NO LCD, NELE ESCREVEMOS UM NOME CARACTER POR CARACTER 

; DADOS/INSTRUÇÕES -> 8 BIT PORT P1
; R/W -> TERRA   
; E -> P3.0    
; RS -> P3.1


; DEFINIÇÕES:

           
           E 	EQU 	P3.0                	; E = PINO P3.7
           RS 	EQU 	P3.1               	; RS = PINO P3.6
		

; ROTINA PRINCIPAL

           ORG 0000H                 	; END. DE INÍCIO DE ESCRITA NA ROM


; ROTINA INICIAL:

           CLR A                     	; LIMPO ACC
           MOV SP, #30H               	; APONTO A PILHA P/ O ENDEREÇO 30H
           MOV P1, #00H               	; ZERO P1
           


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


; ROTINA PARA A ESCRITA DE CADA CARACTER DE UM NOME
         
    		SETB RS                   	; RS EM 1 - PARA ENVIO DE DADOS
           	MOV A, #'S'                	;
           	LCALL ESCREVE             	;
           	MOV A, #'E'                	;
           	LCALL ESCREVE             	;
           	MOV A, #'U'                	;
           	LCALL ESCREVE             	;
; ESPAÇO                   		 	;
           
		CLR RS                    	; ENVIO DE INSTRUÇÃO
           	MOV A, #14H                	; DESLOCA SOMENTE O CURSOR PARA A DIREITA
           	LCALL ESCREVE             	; CHAMA ROTINA DE ESCRITA


; CONTINUA ESCREVENDO OS CARACTERES

           SETB RS                   	; RS EM 1 - PARA ENVIO DE DADOS
           MOV A, #'N'                	;
           LCALL ESCREVE             	;
           MOV A, #'O'                	;
           LCALL ESCREVE             	;
           MOV A, #'M'                	;
           LCALL ESCREVE             	;
           MOV A, #'E'                	;
           LCALL ESCREVE             	;
           SJMP $                    	;


; ROTINA PARA A ESCRITA    		 	;

ESCREVE: 	MOV P1, A                  	; COLOCA O CARACTER NO PORT 1
           	SETB E                    	; E=1
           	LCALL ATRASO              	; CHAMA ATRASO DE 10MS
           	CLR E                     	; E=0 (DADOS/INSTRUÇÕES SÃO LIDOS NA TRANSIÇÃO DE 0 P/ 1.                 
           	RET                       	; RETORNA DA SUBROTINA
		
	
; ROTINA PARA TEMPO DE ATRASO, APROXIMADAMENTE 10MS
   
ATRASO:		MOV R0, #2                   	; DESLIGA T0
VOLTA2: 	MOV R1, #10                 	; ZERA A FLAG DE ESTOURO
VOLTA1:        	MOV R2, #250
           	DJNZ R2, $
		DJNZ R1, VOLTA1
		DJNZ R0, VOLTA2
		RET                       	; RETORNA DA SUBOTINA

           	END                       	; FIM DE COMPILAÇÃO
