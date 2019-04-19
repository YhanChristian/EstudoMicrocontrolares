; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_07  proglog1.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================


; INSTRUÇÕES LÓGICAS

	  ; Este programa tem como função exemplificar a criação de máscaras com a utilização de 
          ; funções lógicas as quais podem ser utilizadas para alterar Bits específicos de registradores sem 
          ; a alteração de todo seu conteúdo. Neste exemplo criamos uma máscara com a função OR 
          ; para setarmos apenas o Bit 1 do registrador R0.
    		
	ORG 0000H           		; Endereço de início de programa.

     	MOV R0, # 10010001B   		; Coloca em R0 o referido valor binário.
     	MOV A,   # 00000010B    	; Coloca o referido valor binário em ACC.
     	ORL A, R0            		; Realiza o OU lógico (mascaramento) entre A e R0.

	MOV R0, A            		; Setamos apenas o segundo BIT do valor presente 	
					; em R0 o resultado fica em ACC e então colocamos 	
					; o resultado em R0.

     	SJMP $              		; Trava o programa nesta linha.

     	END                 		; Fim de programa.

