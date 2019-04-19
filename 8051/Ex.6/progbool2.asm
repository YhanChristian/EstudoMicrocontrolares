; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_06  progboo2.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================



; Programa exemplo p/ treino das instruções chamadas de Booleanas (relativas a Bits).

; Lembrando que:
; 1 - Existem Bytes e Bits com end. idênticos a diferenciação é dada pela instrução utilizada.
; 2 – P/ as instruções booleanas o "C" Carry é o Bit de passagem, igual ao Acc para Bytes.
; 3 - A utilização de uma barra antes do Bit, significa utilizar seu complemento.

     		ORG 0000H     	; Endereço de início de programa.
     		
		SETB 00H      	; SETA (Coloca 1) no BIT de endereço 00H.
     		CLR C         	; Limpa (coloca 0) no BIT de CARRY.
		
		ORL C, /00H    	; Realiza a operação lógica OU entre C e o 						
		                ; complemento  do BIT de endereço 00H.
     		
		ORL C, 00H     	; Realiza a operação lógica OU entre C e o BIT de
		                ; endereço 00H.
     		
		SJMP $        	; Trava nesta linha.
     		
		END           	; Fim de programa.
