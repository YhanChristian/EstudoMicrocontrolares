;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ETEC ARISTOTELES FERREIRA.              ;;
;; 3A3 - 1º SEMESTRE 2013                  ;;
;; PROGRAMA: - LCD_02.ASM                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; EXEMPLO DE ESCRITA NO LCD, NELE ESCREVEMOS UMA MENSAGEM DE UMA VEZ NO DISPLAY

;DADOS/INSTRUÇÕES -> 8 BIT PORT P1
;R/W -> TERRA
		E BIT P3.0
		RS BIT P3.1

           ;ROTINA PRINCIPAL
           ORG 0000H                 ;END. DE INÍCIO DE ESCRITA NA ROM

           ;ROTINA INICIAL:
           CLR A                     ;LIMPO ACC
           CLR P3.0
           MOV SP, #30H               ;APONTO A PILHA P/ O ENDEREÇO 30H
           MOV P1, #00H               ;ZERO P1
           MOV DPTR, #200H            ;CARREGA PONTIRO PARA ESCREVER A MENSAGEM
           
           ;ROTINA DE INICIALIZAÇÃO DO LCD
           
           CLR RS                    ;RS EM 0 - PARA ENVIO DE INSTRUÇÃO
           MOV A,#38H                ;CONFIGURO DISPLAY 2 LINHAS MATRIZ 5X7
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           MOV A,#06H                ;ESCREVE DESLOCANDO O CURSOR PARA DIREITA
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           MOV A,#0CH                ;DISPLAY ACESO SEM CURSOR
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           MOV A,#01H                ;LIMPA O DISPLAY
           LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
 	
 	
		LCALL ATRASO              ;CHAMA ATRASO DE 10MS
  		LCALL ATRASO              ;CHAMA ATRASO DE 10MS
 		LCALL ATRASO              ;CHAMA ATRASO DE 10MS


           ;ROTINA PARA A ESCRITA DA MENSAGEM
           
           SETB RS                   ;RS EM 1 - PARA ENVIO DE DADOS
    VOLTA: CLR A
           MOVC A,@A+DPTR            ;CARREGA OS CARACTERES
           CJNE A,#'%',CONTINUA      ;VERIFICA FIN DA MENSAGEM
           
           SJMP $                    ;MANTÉM NESTA LINHA

 CONTINUA: LCALL ESCREVE             ;CHAMA ROTINA DE ESCRITA
           INC DPTR                  ;INCREMENTA O DPTR
           SJMP VOLTA                ;PRÓXIMO CARACTER
           
           ;ROTINA PARA A ESCRITA    ;
  ESCREVE: MOV P1,A                  ;COLOCA O CARACTER NO PORT 1
           SETB E                    ;E=1
           LCALL ATRASO              ;CHAMA ATRASO DE 10MS
           CLR E                     ;E=0 (DADOS/INSTRUÇÕES SÃO LIDOS NA
                                     ;TRANSIÇÃO DE 1 PARA 0

           RET                       ;RETORNA DA SUBROTINA

           ;ROTINA PARA TEMPO DE ATRASO, APROXIMADAMENTE 10MS
   ATRASO:  	MOV R0, #2                   	; DESLIGA T0
VOLTA2: 	MOV R1, #10                 	; ZERA A FLAG DE ESTOURO
VOLTA1:        	MOV R2, #250
           	DJNZ R2, $
		DJNZ R1, VOLTA1
		DJNZ R0, VOLTA2
   
   
   
           RET                       ;RETORNA DA SUBOTINA

           ORG 0200H                 ;END. DA FRASE

           DB 'KIT AT89S52%'          ;FRASE

           END                       ;FIM DE COMPILAÇÃO
