; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_11  progarit3.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================

; INSTRUÇÕES ARITMÉTICAS

; Exemplo de programa para utilização de instruções matemáticas, nele multiplicaremos os valores de 8   
  ; Bits contidos nos registradores R0 e R1e guardaremos o resultado de 16 Bits nos registradores R3 (MSB) 
  ; e R4 (LSB) lembrando que a instrução de multiplicação MUL só é realizada entre os registradores.
; A e B .

;-> B fica o Byte MSB do resultado.
;-> A fica o Byte LSB do resultado.

     		ORG 0000H    		; Endereço de início do programa.

     		MOV R0, # 100  		; Colocar em R0 o valor 100.
     		MOV R1, # 11   		; Colocar em R1 o valor 11.

     		MOV A, R0     		; Colocar em ACC o valor de R1.
     		MOV B, R1     		; Colocar em B o valor de R2.
    		MUL AB       		; Multiplicar os conteúdos de ACC e B.

     		MOV R3, B     		; Copiando o MSB da multiplicação para R3.
     		MOV R4, A     		; Copiando o LSB da multiplicação para R4.
     		
		SJMP $       		; Trava o programa nesta linha (loop infinito).

     		END          			; Fim de programa.


