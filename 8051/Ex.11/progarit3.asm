; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_11  progarit3.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================

; INSTRU��ES ARITM�TICAS

; Exemplo de programa para utiliza��o de instru��es matem�ticas, nele multiplicaremos os valores de 8   
  ; Bits contidos nos registradores R0 e R1e guardaremos o resultado de 16 Bits nos registradores R3 (MSB) 
  ; e R4 (LSB) lembrando que a instru��o de multiplica��o MUL s� � realizada entre os registradores.
; A e B .

;-> B fica o Byte MSB do resultado.
;-> A fica o Byte LSB do resultado.

     		ORG 0000H    		; Endere�o de in�cio do programa.

     		MOV R0, # 100  		; Colocar em R0 o valor 100.
     		MOV R1, # 11   		; Colocar em R1 o valor 11.

     		MOV A, R0     		; Colocar em ACC o valor de R1.
     		MOV B, R1     		; Colocar em B o valor de R2.
    		MUL AB       		; Multiplicar os conte�dos de ACC e B.

     		MOV R3, B     		; Copiando o MSB da multiplica��o para R3.
     		MOV R4, A     		; Copiando o LSB da multiplica��o para R4.
     		
		SJMP $       		; Trava o programa nesta linha (loop infinito).

     		END          			; Fim de programa.


