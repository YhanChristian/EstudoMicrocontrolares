 		ORG 0000H


START: 		MOV P3, #11111111B	
      		MOV P1, #01110111B
      		MOV P2, #01H        	
       		LCALL TEMPO            	
       		MOV P2, #00H 
      
       		MOV P3, #01000100B	
        	MOV P1, #01110111B
        	MOV P2, #02H         	
       		LCALL TEMPO           	
        	MOV P2, #00H 
       
       		MOV P3, #11111111B	
        	MOV P1, #10111101B
        	MOV P2, #04H         	
       		LCALL TEMPO            	
        	MOV P2, #00H 
       	
       		MOV P3, #00001111B	
        	MOV P1, #11111111B
        	MOV P2, #08H         	
       		LCALL TEMPO           	
        	MOV P2, #00H 
       	
       		MOV P3, #00111111B	
        	MOV P1, #11011011B
        	MOV P2, #10H         	
       		LCALL TEMPO            	
        	MOV P2, #00H 
        
        	MOV P3, #11111111B	
        	MOV P1, #10111101B
        	MOV P2, #20H         	
       		LCALL TEMPO            	
        	MOV P2, #00H 
        
        	MOV P3, #00000000B	
        	MOV P1, #11111111B
        	MOV P2, #40H         	
       		LCALL TEMPO           	
        	MOV P2, #00H 
         	
        	MOV P3, #11111111B	
      		MOV P1, #01110111B
      		MOV P2, #80H        	
       		LCALL TEMPO      	
       		MOV P2, #00H 
         	 	
       		SJMP START       	
       
TEMPO: 	  	MOV R0,#1         
VOLTA2: 	MOV R1,#25      
VOLTA1: 	MOV R2,#50       
          	DJNZ R2,$         
          	DJNZ R1,VOLTA1    
          	DJNZ R0,VOLTA2    
          	RET              
          	END