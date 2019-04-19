; PROGRAMA A ROTAÇÃO DE DISPLAY DE 16 SEGMENTOS	
 		
 		ORG 0000H
 		
		MOV A, #01H
		MOV R3, #1
		
INICIO: 	MOV P3, #11111111B	
      		MOV P1, #11111111B
      		MOV P2, A        	
       		LCALL TEMPO      	
       		MOV P2, #00H 
      		RR A
      		
       		MOV P3, #00000000B	
        	MOV P1, #11111111B				
        	MOV P2, A         	
       		LCALL TEMPO         	
        	MOV P2, #00H 
       		RR A
       		
       		MOV P3, #11111111B	
        	MOV P1, #10111101B
        	MOV P2, A         	
       		LCALL TEMPO        	
        	MOV P2, #00H 
       		RR A
       		
       		MOV P3, #00111111B	
        	MOV P1, #11011011B
        	MOV P2, A         	
       		LCALL TEMPO        	
        	MOV P2, #00H 
       		RR A
       		
       		MOV P3, #00001111B	
        	MOV P1, #11111111B
        	MOV P2, A         	
       		LCALL TEMPO         	
        	MOV P2, #00H 
        	RR A
        	
        	MOV P3, #11111111B	
        	MOV P1, #10111101B
        	MOV P2, A        	
       		LCALL TEMPO         	
        	MOV P2, #00H 
        	RR A
        
          	MOV P3, #01000100B	
        	MOV P1, #01110111B
        	MOV P2, A         	
       		LCALL TEMPO         	
        	MOV P2, #00H 
         	RR A
         	
        	MOV P3, #11111111B	
      		MOV P1, #11111111B
      		MOV P2, A        	
       		LCALL TEMPO      	
       		MOV P2, #00H 
         	RR A
         	DJNZ R3, S1 	
       		
       		SJMP S2
S1:    		LJMP INICIO       	

S2: 		RR A
		LJMP INICIO

     
TEMPO: 	  	MOV R0,#2         	;CARREGA 2 EM R0
VOLTA2: 	MOV R1,#5     		;CARREGA 5 EM R1
VOLTA1: 	MOV R2,#10       	;CARREGA 10 EM R1
          	DJNZ R2,$         	;ESPERA ZERAR R2 PARA CONTINUAR
          	DJNZ R1,VOLTA1    	;ESPERA ZERAR R1 PARA CONTINUAR
          	DJNZ R0,VOLTA2    	;ESPERA ZERAR R0 PARA CONTINUAR
          	RET               	;RETORNA AO PROGRAMA PRINCIPAL
          	END