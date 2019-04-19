; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  yhan.asm  ver. 0.0 data: 18/05/13.   ==============                         
; ========================================================================
 	

;Programa display 16 segmentos, meu nome

		
		ORG 0000H			;Inicio de programa


START: 		MOV P3, #11111111B		;Movo o dado em binário para P3	
      		MOV P1, #01110111B		;Movo o dado em binário para P1
      		MOV P2, #01H        		;Movo o dado 01h para P2
       		LCALL TEMPO            		;Sub-rotina de tempo
       		MOV P2, #00H 			;Limpo P2
       		
       		MOV P3, #11111111B		;Movo o dado em binário para P3	
      		MOV P1, #01110111B		;Movo o dado em binário para P1
      		MOV P2, #02H        		;Movo o dado 02h para P2	
       		LCALL TEMPO            		;Sub-rotina de tempo
       		MOV P2, #00H 			;Limpo P2
      
       		MOV P3, #11111111B		;Movo o dado em binário para P3
        	MOV P1, #11011010B		;Movo o dado em binário para P1 
        	MOV P2, #04H         		;Movo o dado 04h para P2	
       		LCALL TEMPO           		;Sub-rotina de tempo
        	MOV P2, #00H 			;Limpo P2
       
       		MOV P3, #00110011B		;Movo o dado em binário para P3
        	MOV P1, #01110111B		;Movo o dado em binário para P1
        	MOV P2, #08H         		;Movo o dado 08h para P2	
       		LCALL TEMPO            		;Sub-rotina de tempo
        	MOV P2, #00H 			;Limpo P2
       	
       		MOV P3, #00110000B		;Movo o dado em binário para P3
        	MOV P1, #01110111B		;Movo o dado em binário para P1
        	MOV P2, #10H         		;Movo o dado 10h PARA P2
       		LCALL TEMPO           		;Sub-rotina de tempo
        	MOV P2, #00H 			;Limpo P2
       	
       		MOV P3, #00110011B		;Movo o dado em binário para P3
        	MOV P1, #11101110B		;Movo o dado em binário para P1
        	MOV P2, #20H         		;Movo o dado 20h para P2	
       		LCALL TEMPO            		;Sub-rotina de tempo
        	MOV P2, #00H 			;Limpo P2
        
        	MOV P3, #11111111B		;Movo o dado em binário para P3
        	MOV P1, #01110111B		;Movo o dado em binário para P1
        	MOV P2, #40H         		;Movo o dado 40h para P2	
       		LCALL TEMPO      		;Sub-rotina de tempo      	
        	MOV P2, #00H 			;Limpo P2
        
        	MOV P3, #11111111B		;Movo o dado em binário para P3
        	MOV P1, #01110111B		;Movo o dado em binário para P1
        	MOV P2, #80H         		;Movo o dado 80h para P2
       		LCALL TEMPO      		;Sub-rotina de tempo     	
        	MOV P2, #00H 			;Limpo P2
         	
        	
       		SJMP START     			;Volto para START  	
  
;-----------------------------------------------------------------------------------------------------------------------
;Sub-rotina de tempo  
       
TEMPO: 	  	MOV R0,#1  			;Move para R0 01      
VOLTA2: 	MOV R1,#25 			;Move para R1 25
VOLTA1: 	MOV R2,#50       		;Move para R2 50
          	DJNZ R2,$         		;Decremento e trava na linha R2
          	DJNZ R1,VOLTA1    		;Decremento R1 e VOLTA1
          	DJNZ R0,VOLTA2    		;Decremento R0 e VOLTA2
          	RET          			;Retorno de Sub-rotina    
          	END				;Fim de programa