; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Christopher Felix da Silva Santos          ===========
; =====   Programa_01  progdados.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================

;DIRETIVAS:
; Este exercício tem como função treinar a utilização de diretivas de programação e 
; entrada de valores no programa

           CONST EQU 0FFH

           ORG 0000H            	; End. de início do programa na ROM

           MOV R0, #LOW(2FC5H) 	        ; Coloca o LSB do valor em R0
           MOV B,   #(255-200)         	; Coloca o resultado da operação em B
           MOV A,   #25                 ; Coloca o valor 25 decimal no acumulador.
           MOV R1, #CONST         	; Coloca o valor da constante em R1
           MOV A, #01010101B      	; Colocar em ACC o valor 01010101B
           MOV R0, #'A'          	; Colocar em R0 o código ASCII da letra A
           MOV R1, #10H          	; Colocar em R1 o valor 10 em hexadecimal
           MOV R2, #0FFH         	; Colocar em R2 o valor FF em hexadecimal
           MOV R3, #10           	; Colocar em R3 o valor 10 em decimal
           MOV R4, #HIGH(0F5CH)  	; Colocar em R4 o byte + significativo de 0F5CH
           MOV B, #LOW(0F5CH)    	; Colocar em B o byte - significativo de 0F5CH
           MOV A, #(255-245)     	; Colocar em ACC o resultado da conta (255-245)
           
           END                  	; Diretiva de fim de programa p/ o compilador.
