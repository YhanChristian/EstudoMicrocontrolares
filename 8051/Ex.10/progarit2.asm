; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_10  progarit2.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================


 ; INSTRUÇÕES ARITMÉTICAS

	; Exemplo de programa para utilização de instruções matemáticas, nele dividiremos os
        ; valores de 8 Bits e guardaremos o resultado que fica em ACC em R1 e o resto presente em 
         ; B em R2 lembrando que a instrução de  divisão DIV só é realizada entre os registradores.

; Acc e B ->  Acc dividido por B.
; -> B fica o Resto da Divisão.
; -> Acc fica o Quociente da Divisão.

        		ORG 0000H   	; End. de início do programa.

        		MOV A, # 100  	; Coloco o valor decimal em Acc.
        		MOV B, # 11   	; Coloco o valor decimal em B.

        		DIV AB   	; Divido conteúdo de Acc pelo conteúdo de B.

        		MOV R2, B    	; Guardo o resto em R2.
        		MOV R1, A    	; Guardo o resultado em R1.

        		SJMP $      	; Trava o programa nesta linha.
        		END         	; Fim de compilação.
