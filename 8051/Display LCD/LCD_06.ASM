;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       ETEC ARISTOTELES FERREIRA.        ;;
;;         3A3 - 1º SEMESTRE 2013          ;;
;;         PROGRAMA: - LCD_06.ASM          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Definições:
EN 	EQU 	P3.0 		;EN = pino P3.0
RS 	EQU 	P3.1		;RS = pino P3.1
 
;Rotina principal
ORG 0000H 			; End. de início de escrita na ROM
 
;Rotina inicial:
CLR A 			; Limpo Acc
MOV SP, #30H 		; Aponto a pilha p/ o endereço 30H
MOV P1, #00H 		; Zero P1

 
;Rotina de inicialização do LCD
CLR RS 			;RS em 0 - para envio de instrução
MOV A, #38H 		;Configuro display 2 linhas Matriz 5x7
LCALL ESCREVE 		;Chama rotina de escrita
MOV A, #06H 		;Escreve deslocando o cursor para direita
LCALL ESCREVE 		;Chama rotina de escrita
MOV A, #0CH 		;Display aceso sem cursor
LCALL ESCREVE 		;Chama rotina de escrita
MOV A, #01H 		;Limpa o display
LCALL ESCREVE 		;Chama rotina de escrita
 
;Endereça primeira linha da CGRAM
CLR RS 			;RS em 0 - para envio de instrução
MOV A, #40H 		;Carrega endereço inicial da CGRAM
LCALL ESCREVE 		;Chama a rotina de escrita
SETB RS 			;RS em 1 - para envio de dados

; 1º Caracter
MOV A, #00001110B 		; Carrega preencda 1ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A ,#00011111B 		; Carrega preenchimento da 2ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 3ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 4ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 5ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011011B 		; Carrega preenchimento da 6ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A ,#00001010B 		; Carrega preenchimento da 7ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 8ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
 
; Basta continuar escrevendo que automaticamente o próximo caracter que será acessado
 ; 2º Caracter
MOV A, #00001110B 		; Carrega preenchimento da 1ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 2ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 3ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 4ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 5ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 6ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010001B 		; Carrega preenchimento da 7ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 8ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
 
; 3º Caracter

MOV A, #00011111B 		; Carrega preenchimento da 1ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 2ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010101B 		; Carrega preenchimento da 3ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 4ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00011111B 		; Carrega preenchimento da 5ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00010001B 		; Carrega preenchimento da 6ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 7ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #00001110B 		; Carrega preenchimento da 8ª linha do caracter
LCALL ESCREVE 		; Chama rotina de escrita
 
CLR RS 			; RS em 0 - para envio de instrução
MOV A, #0C0H 		; Carrega endereço da DDRAM,onde o caracter será escrito
LCALL ESCREVE 		; Chama rotina de escrita
SETB RS 			; RS em 1 - para envio de dados
MOV A, #00H 		; Indica endereço do 1º caracter na CGRAM, para ;sua escrita no display
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #01H 		; Indica endereço do 2º caracter na CGRAM, para ;sua escrita no display
LCALL ESCREVE 		; Chama rotina de escrita
MOV A, #02H 		; Indica endereço do 3º caracter na CGRAM, para ;sua escrita no display
LCALL ESCREVE 		; Chama rotina de escrita
SJMP $ 			; Trava o programa nesta linha

; Rotina para a escrita ;

ESCREVE: 	MOV P1, A 		; Coloca o caracter no PORT 1
		SETB EN 			; EN=1
		LCALL ATRASO 		; Chama atraso de 10ms
		CLR EN 			; E=0 (dados/instruções são lidos na transição de 1 para 0 
		RET 			; Retorna da subrotina
 
;Rotina para tempo de atraso, aproximadamente 10ms

ATRASO: 	MOV R0, #2                   	; DESLIGA T0
VOLTA2:       	MOV R1, #10                 	; ZERA A FLAG DE ESTOURO
VOLTA1:        	MOV R2, #250
           	DJNZ R2, $
		DJNZ R1, VOLTA1
		DJNZ R0, VOLTA2
		RET                       	; RETORNA DA SUBOTINA
           	END                       	; FIM DE COMPILAÇÃO

