;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ETEC ARISTOTELES FERREIRA.              ;;
;; 3A3 - 1º SEMESTRE 2013                  ;;
;; PROGRAMA: - LCD_05.ASM                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;EXEMPLO DE ESCRITA NO LCD, NELE CRIAMOS UMA MENSAGEM NA SEGUNA LINHA DO DISPLAY
;E ENTAÃO DEIXAMOS ELA PISCAR

;KIT 8051LS 

;DADOS/INSTRUÇÕES -> 8 BIT PORT P1
;R/W -> TERRA
;E -> P3.7
;RS -> P3.6


           ;DEFINIÇÕES:
           E EQU P3.0                ;E = PINO P3.0
           RS EQU P3.1               ;RS = PINO P3.1


           ;ROTINA PRINCIPAL
           ORG 0000H                 ;END. DE INÍCIO DE ESCRITA NA ROM

           ;ROTINA INICIAL:
           CLR A                     ;LIMPO ACC
           MOV SP,#30H               ;APONTO A PILHA P/ O ENDEREÇO 30H
           MOV P1,#00H               ;ZERO P1
           MOV DPTR,#200H            ;CARREGA PONTIRO PARA ESCREVER A MENSAGEM
          

           ;ROTINA DE INICIALIZAÇÃO DO LCD
           CLR RS                    ;RS EM 0 - PARA ENVIO DE INSTRUÇÃO
           MOV A,#38H                ;CONFIGURO DISPLAY 2 LINHAS MATRIZ 5X7
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           MOV A,#06H                ;ESCREVE DESLOCANDO O CURSOR PARA DIREITA
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           MOV A,#08H                ;DISPLAY ACESO SEM CURSOR
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           MOV A,#01H                ;LIMPA O DISPLAY
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA

           ;COLOCANDO A MENSAGEM NA SEGUNDA LINHA
           MOV A,#0C2H               ;1º ENDEREÇO DA SEGUNDA LINHA
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA

           ;ROTINA PARA A ESCRITA DA MENSAGEM
           SETB RS                   ;RS EM 1 - PARA ENVIO DE DADOS
    VOLTA: CLR A
           MOVC A,@A+DPTR            ;CARREGA OS CARACTERES
           CJNE A,#'%',CONTINUA      ;VERIFICA FIN DA MENSAGEM
           
           ;ROTINA PARA PISCAR A MENSAGEM
           CLR RS                    ;ENVIAR INSTRUÇÃO
PISCA:     MOV A,#0CH                ;ACENDE DISPLAY
           LCALL ESCREVE             ;ROTINA DE ESCRITA
           LCALL ATRASO2             ;ROTINA DE TEMPO
           MOV A,#08H                ;APAGA DISPLAY
           LCALL ESCREVE             ;ROTINA DE ESCRITA
           LCALL ATRASO2             ;ROTINA DE TEMPO

           SJMP PISCA                ;VOLTA PARA PISCAR

 CONTINUA: LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           INC DPTR                  ;INCREMENTA O DPTR
           SJMP VOLTA                ;PRÓXIMO CARACTER
           
 ; ROTINA PARA A ESCRITA    	     ;
  ESCREVE: MOV P1,A                  ;COLOCA O CARACTER NO PORT 1
           SETB E                    ;E=1
           LCALL ATRASO              ;CHAMA ATRASO DE 10MS
           CLR E                     ;E=0 (DADOS/INSTRUÇÕES SÃO LIDOS NA TRANSIÇÃO DE 1 PARA 0
           RET                       ;RETORNA DA SUBROTINA

; ROTINA PARA TEMPO DE ATRASO, APROXIMADAMENTE 10MS
   
   ATRASO: 	MOV R0, #8                   	; DESLIGA T0
VOLTA2: 	MOV R1, #10                 	; ZERA A FLAG DE ESTOURO
VOLTA1:        	MOV R2, #250
           	DJNZ R2, $
		DJNZ R1, VOLTA1
		DJNZ R0, VOLTA2
           	CLR RS0
           RET                       ;RETORNA DA SUBOTINA


       ;ROTINA PARA TEMPO DE DESLOCAMENTO DA MENSAGEM, APROXIMADAMENTE 100MS

ATRASO2: 	MOV R3, #4                  	; DESLIGA T0
VOLTA4: 	MOV R4, #100                 	; ZERA A FLAG DE ESTOURO
VOLTA3:        	MOV R5, #250
           	DJNZ R5, $
		DJNZ R4, VOLTA3
		DJNZ R3, VOLTA4
           RET                       ;RETORNA DA SUBOTINA

           ORG 0200H                 ;END. DA FRASE

           DB 'PROF. SILVIO%'          ;FRASE

           END                       ;FIM DE COMPILAÇÃO
