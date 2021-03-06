;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       ETEC ARISTOTELES FERREIRA.        ;;
;;         3A3 - 1� SEMESTRE 2013          ;;
;;         PROGRAMA: - LCD_06.ASM          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Defini��es:
EN 	EQU 	P3.0 		;EN = pino P3.0
RS 	EQU 	P3.1		;RS = pino P3.1
 
;Rotina principal
ORG 0000H 			; End. de in�cio de escrita na ROM
 
;Rotina inicial:
CLR A 			; Limpo Acc
MOV SP, #30H 		; Aponto a pilha p/ o endere�o 30H
MOV P1, #00H 		; Zero P1

 
;Rotina de inicializa��o do LCD
CLR RS 			;RS em 0 - para envio de instru��o
MOV A, #38H 		;Configuro display 2 linhas Matriz 5x7
LCALL ESCREVE 		;Chama rotina de escrita
MOV A, #06H 		;Escreve deslocando o cursor para direita
LCALL ESCREVE 		;Chama rotina de escrita
MOV A, #0CH 		;Display aceso sem cursor
LCALL ESCREVE 		;Chama rotina de escrita
MOV A, #01H 		;Limpa o display
LCALL ESCREVE 		;Chama rotina de escrita
 
;Endere�a primeira linha da CGRAM
CLR RS 			;RS em 0 - para envio de instru��o
MOV A, #40H 		;Carrega endere�o inicial da CGRAM
LCALL ESCREVE 		;Chama a rotina de escrita
SETB RS 			;RS em 1 - para envio de dados

; 1� Caracter
MOV A, #00001110B 		; Carrega preencda 1� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A ,#00011111B 		; Carrega preenchimento da 2� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 3� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 4� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 5� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011011B 		; Carrega preenchimento da 6� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A ,#00001010B 		; Carrega preenchimento da 7� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 8� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
 
; Basta continuar escrevendo que automaticamente o pr�ximo caracter que ser� acessado
 ; 2� Caracter
MOV A, #00001110B 		; Carrega preenchimento da 1� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 2� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 3� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 4� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 5� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 6� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010001B 		; Carrega preenchimento da 7� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 8� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
 
; 3� Caracter

MOV A, #00011111B 		; Carrega preenchimento da 1� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 2� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 3� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 4� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 5� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010001B 		; Carrega preenchimento da 6� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 7� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 8� linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
 
CLR RS 			; RS em 0 - para envio de instru��o
MOV A, #0C0H 		; Carrega endere�o da DDRAM,onde o caracter ser� escrito
LCALL ESCREVE 		; Chama rotina de escrita
SETB RS 			; RS em 1 - para envio de dados
MOV A, #00H 		; Indica endere�o do 1� caracter na CGRAM, para ;sua escrita no display
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #01H 		; Indica endere�o do 2� caracter na CGRAM, para ;sua escrita no display
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #02H 		; Indica endere�o do 3� caracter na CGRAM, para ;sua escrita no display
LCALL ESCREVE 		; Chama rotina de escrita
SJMP $ 			; Trava o programa nesta linha

; Rotina para a escrita ;

ESCREVE: 	MOV P1, A 		; Coloca o caracter no PORT 1
		SETB EN 			; EN=1
		LCALL ATRASO 		; Chama atraso de 10ms
		CLR EN 			; E=0 (dados/instru��es s�o lidos na transi��o de 1 para 0 
		RET 			; Retorna da subrotina
 
;Rotina para tempo de atraso, aproximadamente 10ms

ATRASO: 	MOV R0, #2                   	; DESLIGA T0
VOLTA2:       	MOV R1, #10                 	; ZERA A FLAG DE ESTOURO
VOLTA1:        	MOV R2, #250
           	DJNZ R2, $
		DJNZ R1, VOLTA1
		DJNZ R0, VOLTA2
		RET                       	; RETORNA DA SUBOTINA
           	END                       	; FIM DE COMPILA��O

