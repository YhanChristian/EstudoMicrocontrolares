; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  yhanrot.asm  ver. 0.0 data: 18/05/13.   ===========                          
; ========================================================================


; PROGRAMA A ROTAÇÃO DE DISPLAY DE 16 SEGMENTOS	
 	
 	
 		
 		ORG 0000H				;INICIO DE PROGRAMA		
 		
		MOV A, #01H				;MOVO PARA A O DADO #01H
		MOV R3, #1				;MOVO PARA R3 O DADO 1
		
INICIO: 	MOV P3, #11111111B			;MOVO O DADO EM BINÁRIO PARA P3
      		MOV P1, #11111111B			;MOVO O DADO EM BINÁRIO PARA P1
      		MOV P2, A        			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO      			;SUB-ROTINA DE TEMPO
       		MOV P2, #00H 				;LIMPO P2
      		RR A					;ROTACIONO O VALOR DE A
      		
       		MOV P3, #00110011B			;MOVO O DADO EM BINÁRIO PARA P3	
        	MOV P1, #11101110B			;MOVO O DADO EM BINÁRIO PARA P1	
        	MOV P2, A         			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO         			;SUB-ROTINA DE TEMPO
        	MOV P2, #00H 				;LIMPO P2
       		RR A					;ROTACIONO O VALOR DE A
       		
       		MOV P3, #00110000B			;MOVO O DADO EM BINÁRIO PARA P3	
        	MOV P1, #01110111B			;MOVO O DADO EM BINÁRIO PARA P1
        	MOV P2, A         			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO        			;SUB-ROTINA DE TEMPO
        	MOV P2, #00H 				;LIMPO P2
       		RR A					;ROTACIONO O VALOR DE A
       		
       		MOV P3, #00110011B			;MOVO O DADO EM BINÁRIO PARA P3
        	MOV P1, #01110111B			;MOVO O DADO EM BINÁRIO PARA P1
        	MOV P2, A         			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO        			;SUB-ROTINA DE TEMPO
        	MOV P2, #00H 				;LIMPO P2
       		RR A					;ROTACIONO O VALOR DE A
       		
       		MOV P3, #11111111B			;MOVO O DADO EM BINÁRIO PARA P3
        	MOV P1, #11011010B			;MOVO O DADO EM BINÁRIO PARA P1
        	MOV P2, A         			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO         			;SUB-ROTINA DE TEMPO
        	MOV P2, #00H 				;LIMPO P2
        	RR A					;ROTACIONO O VALOR DE A
        	
        	MOV P3, #11111111B			;MOVO O DADO EM BINÁRIO PARA P3
        	MOV P1, #11111111B			;MOVO O DADO EM BINÁRIO PARA P1
        	MOV P2, A        			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO         			;SUB-ROTINA DE TEMPO
        	MOV P2, #00H 				;LIMPO P2
        	RR A					;ROTACIONO O VALOR DE A
        
          	MOV P3, #11111111B			;MOVO O DADO EM BINÁRIO PARA P3
        	MOV P1, #11111111B			;MOVO O DADO EM BINÁRIO PARA P1
        	MOV P2, A         			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO         			;SUB-ROTINA DE TEMPO
        	MOV P2, #00H 				;LIMPO P2
         	RR A					;ROTACIONO O VALOR DE A
         	
        	MOV P3, #11111111B			;MOVO O DADO EM BINÁRIO PARA P3
      		MOV P1, #11111111B			;MOVO O DADO EM BINÁRIO PARA P1
      		MOV P2, A        			;MOVO O DADO DE A PARA P2
       		LCALL TEMPO      			;SUB-ROTINA DE TEMPO
       		MOV P2, #00H 				;LIMPO P2
         	RR A					;ROTACIONO O VALOR DE A
         	DJNZ R3, S1 				;DECREMENTO RE, PULO PARA S1
       		
       		SJMP S2					;PULO PARA S2
S1:    		LJMP INICIO   				;PULO PARA INICIO    	

S2: 		RR A					;ROTACIONO O VALOR DE A
		LJMP INICIO				;PULO PARA INICIO


;-------------------------------------------------------------------------------------------------------------
;SUB-ROTINA DE TEMPO
     
TEMPO: 	  	MOV R0,#2         	;CARREGA 2 EM R0
VOLTA2: 	MOV R1,#5     		;CARREGA 5 EM R1
VOLTA1: 	MOV R2,#10       	;CARREGA 10 EM R1
          	DJNZ R2,$         	;ESPERA ZERAR R2 PARA CONTINUAR
          	DJNZ R1,VOLTA1    	;ESPERA ZERAR R1 PARA CONTINUAR
          	DJNZ R0,VOLTA2    	;ESPERA ZERAR R0 PARA CONTINUAR
          	RET               	;RETORNA AO PROGRAMA PRINCIPAL
          	END			;FIM DE PROGRAMA