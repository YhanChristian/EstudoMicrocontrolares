
; =============================================================================
; =================      ETEC Aristóteles Ferreira.    ========================
; ================         Yhan Christian Souza Silva.         ================
; ===============      exercicio2.asm data: 04/05/13.    ======================                         
; =============================================================================


; Criar um programa que a cada tecla pressionada em P2
; acende o respectivo led em P0, ou seja,
; utilizar uma rotina de varredura de teclado.
;Acionando os botões P2.0 E P2.7 deverá acionar o Buzzer  e acender todos os Leds em P0	
	
	
	ORG 0000H	;INICIO DE PROGRAMA
INICIO:	MOV P0,#00H	;LIMPA P0
	MOV P2,#0FFH	;PREPARA P2 PARA LEITURA
	

               

S0:             JB P2.0, LIMPA          ;VERIFICA O ACIONAMENTO DO BOTAO P2.0 / SE NÃO TIVER VAI PRA ROTINA 
	        SETB P0.0               ;SETA A PORTA P0.0
                
LIMPA:	        JNB P2.0, S1            ;VERIFICA O DESACIONAMENTO DO BOTAO P2.0 / SE NÃO TIVER VAI PRA ROTINA 
                CLR P0.0                ;LIMPA A PORTA P0.0
                
S1:             JB P2.1, LIMPA1         ;VERIFICA O ACIONAMENTO DO BOTAO P2.1 / SE NÃO TIVER VAI PRA ROTINA 
                SETB P0.1               ;SETA A PORTA P0.1
                
LIMPA1:         JNB P2.1, S2            ;VERIFICA O DESACIONAMENTO DO BOTAO P2.1 / SE NÃO TIVER VAI PRA ROTINA     
                CLR P0.1                ;LIMPA A PORTA P0.1

S2:             JB P2.2, LIMPA2         ;VERIFICA O ACIONAMENTO DO BOTAO P2.2 / SE NÃO TIVER VAI PRA ROTINA 
                SETB P0.2               ;SETA A PORTA P0.2
                
LIMPA2:         JNB P2.2, S3            ;VERIFICA O DESACIONAMENTO DO BOTAO P2.2 / SE NÃO TIVER VAI PRA ROTINA        
                CLR P0.2                ;LIMPA A PORTA P0.2
    
S3:             JB P2.3, LIMPA3         ;VERIFICA O ACIONAMENTO DO BOTAO P2.3 / SE NÃO TIVER VAI PRA ROTINA 
                SETB P0.3               ;SETA A PORTA P0.3
                
LIMPA3:         JNB P2.3, S4            ;VERIFICA O DESACIONAMENTO DO BOTAO P2.3 / SE NÃO TIVER VAI PRA ROTINA     
                CLR P0.3                ;LIMPA A PORTA P0.3
                
S4:             JB P2.4, LIMPA4         ;VERIFICA O ACIONAMENTO DO BOTAO P2.4 / SE NÃO TIVER VAI PRA ROTINA 
                SETB P0.4               ;SETA A PORTA P0.4
                
LIMPA4:         JNB P2.4, S5            ;VERIFICA O DESACIONAMENTO DO BOTAO P2.4 / SE NÃO TIVER VAI PRA ROTINA       
                CLR P0.4                ;LIMPA A PORTA P0.4
                
S5:             JB P2.5, LIMPA5         ;VERIFICA O ACIONAMENTO DO BOTAO P2.5 / SE NÃO TIVER VAI PRA ROTINA 
                SETB P0.5               ;SETA A PORTA P0.5
                
LIMPA5:         JNB P2.5, S6            ;VERIFICA O DESACIONAMENTO DO BOTAO P2.5 / SE NÃO TIVER VAI PRA ROTINA     
                CLR P0.5                ;LIMPA A PORTA P0.5
                
S6:             JB P2.6, LIMPA6         ;VERIFICA O ACIONAMENTO DO BOTAO P2.6 / SE NÃO TIVER VAI PRA ROTINA 
                SETB P0.6               ;SETA A PORTA P0.6
                
LIMPA6:         JNB P2.6, S7            ;VERIFICA O DESACIONAMENTO DO BOTAO P2.6 / SE NÃO TIVER VAI PRA ROTINA    
                CLR P0.6                ;LIMPA A PORTA P0.6
                
S7:             JB P2.7, LIMPA7         ;VERIFICA O ACIONAMENTO DO BOTAO P2.7 / SE NÃO TIVER VAI PRA ROTINA 
                SETB P0.7               ;SETA A PORTA P0.7
                
LIMPA7:         JNB P2.7, DUASCHAVES    ;VERIFICA O DESACIONAMENTO DO BOTAO P2.7 / SE NÃO TIVER VAI PRA ROTINA            
                CLR P0.7                ;LIMPA A PORTA P0.7
                
DUASCHAVES:     JB P2.0, DESLIGA        ;VERIFICA O ACIONAMENTO DO BOTAO P2.2 / SE NÃO TIVER VAI PRA ROTINA  
		JB P2.7, DESLIGA        ;VERIFICA O ACIONAMENTO DO BOTAO P2.7 / SE NÃO TIVER VAI PRA ROTINA     
                CLR P3.7                ;LIMPA P3.7
                MOV A, #0FFH            ;MOVE PARA O ACUMULADOR O DADO 0FFH
                MOV P0, A               ;MOVE O DADO DO ACUMULADOR PARA P0
                SJMP INICIO
                
DESLIGA:	SETB P3.7    		;SETO O BIT DO BUZZER, FAZENDO ELE PARAR DE TOCAR	      
                                                                                                    
                
                SJMP INICIO		;PULO PARA INICIO DE PROGRAMA


		END            	        ;TERMINA O PROGRAMA                                