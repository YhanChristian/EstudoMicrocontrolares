; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_08  proglog2.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================

; INSTRUÇÕES LÓGICAS

	; Este programa tem como objetivo treinar a criação de máscaras com instruções de funções 
	; lógicas, o objetivo é  Zerar apenas o NIBBLE mais significativo do registrador R2, sem     
   	 ; alterar seus outros Bits.       

     	ORG 0000H           		; Endereço de início de programa
 
	MOV R2, # 10011101B        	; Coloca em R2 o referido valor binário

	MOV A,  # 00001111B    		; Criando a máscara
     	
	ANL A, R2            		; Zera o nibble mais significativo (nibble)= 4bits

       	MOV R2, A            		; Coloca o resultado em R2
     	
	SJMP $              		; Trava o programa nesta linha
     	
	END                 	 	; Fim de programa

