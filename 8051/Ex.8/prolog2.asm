; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_08  proglog2.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================

; INSTRU��ES L�GICAS

	; Este programa tem como objetivo treinar a cria��o de m�scaras com instru��es de fun��es 
	; l�gicas, o objetivo �  Zerar apenas o NIBBLE mais significativo do registrador R2, sem     
   	 ; alterar seus outros Bits.       

     	ORG 0000H           		; Endere�o de in�cio de programa
 
	MOV R2, # 10011101B        	; Coloca em R2 o referido valor bin�rio

	MOV A,  # 00001111B    		; Criando a m�scara
     	
	ANL A, R2            		; Zera o nibble mais significativo (nibble)= 4bits

       	MOV R2, A            		; Coloca o resultado em R2
     	
	SJMP $              		; Trava o programa nesta linha
     	
	END                 	 	; Fim de programa

