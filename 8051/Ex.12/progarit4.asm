; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===========
; =====   Programa_12  progarit4.asm  ver. 0.0 data: 02/04/13.   =========                          
; ========================================================================

; INSTRUÇÕES ARITMÉTICAS

; Programa para treino de instruções matemáticas, nele é realizado a subtração dos valores 
 ; contidos nos registradores R0 e R1, lembrando que sempre devemos utilizar o Acc para a 
   ; realização desse tipo de instrução e o resultado também ficará no Acc, quando simular esse 
   ; programa altere os valores de R0 e R1 e  observe o BIT "C" (Carry), que é o 7º Bit do PSW.

;Ordem: Acc - (valor).
;Acc -> fica o resultado.

          		ORG 0000H  	; End. de início de programa

          		MOV R0, # 05  	; Coloco valor em R0
          		MOV R1, # 10  	; Coloco valor em R1

          		MOV A, R1    	; Copio R1 para Acc p/ realizar a subtração
          		SUBB A, R0   	; Realiza Acc - R0

          		MOV R7, A    	; Guardo o resultado em R7

          		SJMP $      	; Trava o programa nesta linha

          		END         	; Fim de compilação
