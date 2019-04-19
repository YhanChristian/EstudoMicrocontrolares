; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_13  progarit5.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================


; INSTRUÇÕES ARITMÉTICAS


; Este exercício é um desafio para a criação em algoritmo que realize a soma de um número de 16 Bits (lembrando  que 
; o 8051 trabalha apenas com nº de 8 Bits, para não haver erro em nossa soma devemos considerar o Carry da soma dos       
; Bytes  LSB e somá-lo juntamente com os Bytes MSB.

              		ORG 0000H        	; End. de início de programa.

             	;1º Número de 16 Bits  (2DF5H).
              		MOV R1, # 0F5H     	; Carrego em R1 (LSB 1).
              		MOV R2, # 2DH      	; Carrego em R2 (MSB 1).
              		
		; 2º Número de 16 Bits  (F5C4H).
             		MOV R3, # 0C4H     	; Carrego em R3 (LSB 2).
              		MOV R4, # 0F5H     	; Carrego em R4 (MSB 2).
              

		; Realizo a soma dos LSB's.
              		MOV A, R1         	; Copio em Acc o valor de R1.
              		ADD A, R3         	; Soma dos valores de R2 e Acc.
              		MOV R7, A         	; Guardo o LSB do resultado.
              		
		; Realizo a soma dos MSB's com CARRY.
              		MOV A, R2         	; Copio em Acc o valor de R2.
              		ADDC A, R4        	; Soma de R2, Acc + Carry.
              		MOV R6, A         	; Guardo o MSB do resultado.
              		
		; Guardando o CARRY final.
             		CLR A		; limpo o Acumulador.
              		RLC A		; Rotaciono o Acumulador para a esquerda.
              		MOV R5, A      	; Guardo em R7 (Bit 0) o CARRY final.
             		SJMP $        		; Permanece nesta linha.
              		END           		; Fim de compilação.
