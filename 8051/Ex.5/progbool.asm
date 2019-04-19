; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Christopher Felix da Silva Santos          ===========
; =====   Programa_05  progbool.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================

; Este exemplo utiliza o conceito de instruções booleanas com a finalidade prática de alteração 
; do banco de registradores utilizados. 

     		ORG 0000H     		; Endereço de início de programa.
     		
		                        ; Estou trabalhando com Banco 0 (default).
     		MOV R0, # 0C0H  	; Coloco o valor em R0.
     		MOV R1, # 45H   	; Coloco o valor em R1.
     		MOV R2, # 0F0H 		; Coloco o valor em R2.
     		
		                        ; Selecionando o Banco 3 de registradores.
    		SETB RS0      		; Coloco 1 em RS0.
     		SETB RS1      		; Coloco 1 em RS1.
    		
 		                        ; Agora estou trabalhando com Banco 3.
     		MOV R0, # 0C0H  	; Coloco o valor em R0.
     		MOV R1, # 45H   	; Coloco o valor em R1.
     		MOV R2, # 0F0H  	; Coloco o valor em R2.
     		SJMP $        		; Trava nesta linha.
     		END           		; Fim de programa.