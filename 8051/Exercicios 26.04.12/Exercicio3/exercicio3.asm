; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Yhan Christian Souza Silva         ===================
; =====   Programa_01  exercicio3.asm  ver. 0.0 data: 28/04/13.   ========                          
; ========================================================================



;Criar um programa para acionar um potenciômetro digital
; com incremento na  da tecla  P2.0 e decremento com a tecla P2.7 





		ORG 0000H			;INICIO DO PROGRAMA
		MOV P0,#00H			;LIMPA P0
		MOV P2,#0FFH			;PREPARA P2 PARA A LEITURA
                MOV A,#00H                      ;LIMPA O ACUMULADOR

LOOP:                                           ;ROTINA DE LOOP
		
INCREMENTA:	JB P2.0, DECREMENTA             ;VERIFICA SE P2.0 ESTA ACIONADO / SE NÃO ESTIVER VAI PARA A ROTINA DECREMENTA
		
VOLTA3:		CJNE A,#0FFH,FAZ     		;COMPARO  O DADO FF COM ACUMULADOR SE NÃO FOR VOU PARA SUBROTINA FAZ          
		SJMP DECREMENTA			;PULO PARA ROTINA DECREMENTA


FAZ:		INC A				;INCREMENTO 1 AO ACC
		MOV P0, A			;MOVO O DADO DE ACC PARA P0
		LCALL TEMPO			;SUBROTINA DE TEMPO
		SJMP INCREMENTA			;PULO PARA ROTINA INCREMENTA
		
DECREMENTA:	JB P2.7, INCREMENTA		;VERIFICA SE P2.7 ESTA ACIONADO / SE NÃO ESTIVER VAI PARA A ROTINA INCREMENTE
		


VOLTA4:		CJNE A,#00H,FAZ2		;COMPARO O DADO 00 COM ACUMULADOR SE NÃO FOR VOU PARA SUBROTINA FAZ2
		SJMP INCREMENTA			;PULO PARA ROTINA INCREMENTA


FAZ2:		DEC A				;DECREMENTO 1 AO ACC
		MOV P0, A			;MOVO O DADO DE ACC PARA P0
		LCALL TEMPO			;SUBROTINA DE TEMPO
		SJMP DECREMENTA			;PULO PARA ROTINA DECREMENTA
		
		SJMP LOOP			;VOLTAR PARA LOOP
		
		
		
		
	;SUBROTINA TEMPO
TEMPO:  MOV R0, #1                     	        ;CARREGA RO COM 1
VOLTA2: MOV R1, #250    	                ;CARREGA R1 COM 250
VOLTA1: MOV R2, #250	                        ;CARREGA R2 COM 250
        DJNZ R2, $                              ;DECREMENTA R2 ATÉ ZERAR
        DJNZ R1, VOLTA1                         ;DECREMENTA R1 E SALTA ATÉ ZERAR
        DJNZ R0, VOLTA2                         ;DECREMENTA RO E SALTA ATÉ ZERAR
        RET                                     ;RETORNO DE SUBROTINA
	END					;FIM DE PROGRAMA				
							
		
				
		
		
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
