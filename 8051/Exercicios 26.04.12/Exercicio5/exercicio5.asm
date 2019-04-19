; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Walter Eudócio Agostinho Júnior        ===================
; =====   Programa_01  exercicio5.asm  ver. 0.0 data: 05/04/13.   ========                          
; ========================================================================


;Fazer programa para controle de semáforos




		ORG 0000H			;Inicio de Programa 
		MOV P0,#00H			;Limpo P0
		MOV P2,#0FFH			;Preparo P2 para leitura
LOOP:

		JNB P3.2, PEDESTRE
		MOV A,#89H
		MOV P0, A
		LCALL TEMPO
		MOV A,#49H
		MOV P0, A
		LCALL TEMPO_1
		MOV A,#2CH
		MOV P0,A
		LCALL TEMPO
		MOV A,#2AH
		MOV P0, A
		LCALL TEMPO_1
		SJMP LOOP
		
		
PEDESTRE: JB P3.2, LOOP	
	  LCALL TEMPO_1		
	  MOV A, #4AH  
	  MOV P0, A				
	  LCALL TEMPO_2
	  CLR A
	  MOV P0, A
	  MOV A, #21H
	  MOV P0, A
	  SETB P0.4
	  LCALL TEMPO_3	
	  JNB P3.2, $	
          SJMP PEDESTRE






		
		
	;SUBROTINA TEMPO 10s
TEMPO:  MOV R0, #80                              ;CARREGA RO COM 80
VOLTA2: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET
        
	;SUBROTINA TEMPO 5s
TEMPO_1:MOV R0, #40                              ;CARREGA RO COM 40
VOLTA4: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA3: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA3                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA4                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET
        
  	;SUBROTINA TEMPO 3s
TEMPO_2:MOV R0, #24                              ;CARREGA RO COM 24
VOLTA6: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA5: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA5                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA6                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA				

  	;SUBROTINA TEMPO 3s
TEMPO_3:MOV R0, #24                              ;CARREGA RO COM 24
VOLTA8: MOV R1, #250      	                   ;CARREGA R1 COM 250
VOLTA7: MOV R2, #250	                         ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA7                        ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA8                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA			       
		
		
		      
        END                                     ;FIM DO PROGRAMA						
		       
		
		
		        

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
