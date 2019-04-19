; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_09  progarit1.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================

; INSTRU��ES ARITM�TICAS

		 ; Programa para treino de instru��es matem�ticas, nele � realizado a soma dos valores  
       	    	 ; contidos nos registradores R1 e R2, lembrando que sempre devemos utilizar o Acc para a  
             	 ; realiza��o desse tipo de instru��o e o resultado tamb�m ficar� no Acc, quando simular esse 
                ; programa observe o BIT "C" (Carry), que � o 7� Bit do  PSW.

            		
		ORG 0000H        			; End. de in�cio de programa.

            		MOV R1, # 0F5H    		; Carrego o valor em R1.
            		MOV R2, # 2DH      		; Carrego o valor em R2.
            		MOV A, R1         		; Copio em Acc o valor de R1.
            		
		ADD A, R2         			; Soma dos valores de R2 e Acc.
            		
		MOV R7, A         			; Coloco o resultado em R7.
            		
		SJMP $           			; Permanece nesta linha.
            		
		END              			; Fim de compila��o.
