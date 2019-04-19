; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_10  progarit2.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================


 ; INSTRU��ES ARITM�TICAS

	; Exemplo de programa para utiliza��o de instru��es matem�ticas, nele dividiremos os
        ; valores de 8 Bits e guardaremos o resultado que fica em ACC em R1 e o resto presente em 
         ; B em R2 lembrando que a instru��o de  divis�o DIV s� � realizada entre os registradores.

; Acc e B ->  Acc dividido por B.
; -> B fica o Resto da Divis�o.
; -> Acc fica o Quociente da Divis�o.

        		ORG 0000H   	; End. de in�cio do programa.

        		MOV A, # 100  	; Coloco o valor decimal em Acc.
        		MOV B, # 11   	; Coloco o valor decimal em B.

        		DIV AB   	; Divido conte�do de Acc pelo conte�do de B.

        		MOV R2, B    	; Guardo o resto em R2.
        		MOV R1, A    	; Guardo o resultado em R1.

        		SJMP $      	; Trava o programa nesta linha.
        		END         	; Fim de compila��o.
