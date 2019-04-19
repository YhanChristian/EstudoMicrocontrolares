; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_06  progboo2.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================



; Programa exemplo p/ treino das instru��es chamadas de Booleanas (relativas a Bits).

; Lembrando que:
; 1 - Existem Bytes e Bits com end. id�nticos a diferencia��o � dada pela instru��o utilizada.
; 2 � P/ as instru��es booleanas o "C" Carry � o Bit de passagem, igual ao Acc para Bytes.
; 3 - A utiliza��o de uma barra antes do Bit, significa utilizar seu complemento.

     		ORG 0000H     	; Endere�o de in�cio de programa.
     		
		SETB 00H      	; SETA (Coloca 1) no BIT de endere�o 00H.
     		CLR C         	; Limpa (coloca 0) no BIT de CARRY.
		
		ORL C, /00H    	; Realiza a opera��o l�gica OU entre C e o 						
		                ; complemento  do BIT de endere�o 00H.
     		
		ORL C, 00H     	; Realiza a opera��o l�gica OU entre C e o BIT de
		                ; endere�o 00H.
     		
		SJMP $        	; Trava nesta linha.
     		
		END           	; Fim de programa.
