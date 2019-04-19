; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_07  proglog1.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================


; INSTRU��ES L�GICAS

	  ; Este programa tem como fun��o exemplificar a cria��o de m�scaras com a utiliza��o de 
          ; fun��es l�gicas as quais podem ser utilizadas para alterar Bits espec�ficos de registradores sem 
          ; a altera��o de todo seu conte�do. Neste exemplo criamos uma m�scara com a fun��o OR 
          ; para setarmos apenas o Bit 1 do registrador R0.
    		
	ORG 0000H           		; Endere�o de in�cio de programa.

     	MOV R0, # 10010001B   		; Coloca em R0 o referido valor bin�rio.
     	MOV A,   # 00000010B    	; Coloca o referido valor bin�rio em ACC.
     	ORL A, R0            		; Realiza o OU l�gico (mascaramento) entre A e R0.

	MOV R0, A            		; Setamos apenas o segundo BIT do valor presente 	
					; em R0 o resultado fica em ACC e ent�o colocamos 	
					; o resultado em R0.

     	SJMP $              		; Trava o programa nesta linha.

     	END                 		; Fim de programa.

