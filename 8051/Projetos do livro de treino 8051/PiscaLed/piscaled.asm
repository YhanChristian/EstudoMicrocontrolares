; ==================================================================================
; =================      ETEC Aristóteles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  piscaled.asm  ver. 0.0 data: 29/03/13       ========                          
; ===================================================================================

TEMPO			EQU	(65535-50000)			;define atraso de 50.000 us
VEZES			EQU	14h				;define o número de vezes que o TEMPO será
								;multiplicado - para cristal de 12 MHz
								;14h corresponde a 20 decimal: produzirá
								;TEMPO=1s, pois 50.000usx20=1s
			ORG	0000h				;define endereço inicial
			MOV	TMOD,#01H			;programa timer 0 no modo 1 (16 bits)
			LJMP	PRINC				;pula para a rotina de início de programa

;Colocamos o endereço inicial do programa na posição 0040h apenas
;para preservar os endereços de INTERRUPÇÃO que são fixos dentro desta faixa de endereços

	;ROTINA DE PISCA-PISCA
	;Os quatro primeiros LEDs acendem, depois só os últimos quatro LEDS acendem
	;Vamos admitir que as teclas s1 e s2 estejam nos pinos PX.0 E PX.1 em que X pode 
	;ser qualquer Port disponível, neste caso, escolhemos o port P1.
			ORG	0040H				;define inicio do programa
PRINC:			MOV	R0,#0FFH			;carrega o R0 com FFh
SEQUENCIA0:		MOV	A,#0F0H				;carrega 11110000 no acumulador
PISCA:			MOV	P3,A				;escreve no port 3
			LCALL	ATRASO				;chama a rotina de atraso
			SWAP	A				;troca os 4bits +sig, pelos 4 -sig
			MOV	R0,P1				;lê teclado
			CJNE	R0,#0FEH,PISCA			;verifica se tecla S1 foi pressionada
								;se não continua sequencia pisca(vide esquema)
			LCALL	SOLTATECLA			;se S1 foi pressionada,vá para soltatecla
			
			;ROTINA DA SEQUÊNCIA DE LEDS
			;Faz com que um LED acenda de cada vez em sequência 

SEQUENCIA1:		MOV	R3,#80H				;VALOR (10000000)b para R3
LOOP2:			MOV	P3,R3				;move R3 para P3, isto fará com
								;que acenda o LED que receberá o bit 1
								;os três comandos abaixo farão com que no
								;registrador R3, que é nosso registrador de
								;saida, vá deslocando para a direita o único bit 1
								;inserido nele
			MOV	A,R3				
			RR	A				;desloca o acumulador à direita
			MOV	R3,A				;carrega R3 com o conteudo de A
			LCALL	ATRASO				;chama a rotina de atraso
			MOV	R0,P1				;lê teclado
			CJNE	R0,#0FDH,LOOP2			;fica em "loop" se não foi pressionada a tecla S2
			LCALL	SOLTATECLA			;se foi vá para "soltatecla"
			SJMP	SEQUENCIA0			;retorne a sequencia "pisca"
			
			;SUB-ROTINAS
ATRASO:			PUSH	ACC				;salva o valor do acumulador na pilha
			PUSH	01h				;salva valor R1 na pilha
			MOV	R1,#0h				;zera o conteúdo de R1
LOOP:			MOV	TH0,#HIGH(TEMPO)		;carrega THight e TLow do Timer 0 com 50.000, já
								;separado em High e Low
			MOV	TL0,#LOW(TEMPO)
			SETB	TR0				;liga timer
			JNB	TF0,$				;Enquanto TF0=0 permanece aqui em "loop".
			MOV	A,R1				;lê R1
			ADD	A,#01H				;soma 1 ao acc
			MOV	R1,A				;escreve em R1
			CLR	TR0				;desliga timer
			CLR	TF0				;reseta FLAG do timer 0
			CJNE	R1,#VEZES,LOOP			;faz com que o timer conte 20 vezes
			POP	01H				;volta o valor armazenado para R1
			POP	ACC				;volta valor armazenado para acc
		
SOLTATECLA:		MOV	R0,P1				;lê teclado
			MOV	TH0,#HIGH(65000)		;perde tempo para ler último estado da tecla
								;antes de soltar, para evitar problemas de
								;"bouncing" da tecla.
			MOV	TL0,#LOW(65000)			
			SETB	TR0				;liga timer
			JNB	TF0,$				;Enquanto TF0=0 permanece aqui.
			CLR	TR0				;desliga timer
			CLR	TF0				;reseta FLAG do timer 0
			MOV	R0,P1				;lê teclado
			CJNE	R0,#0FFH,SOLTATECLA		;enquanto tecla estiver apertada espera soltar.
			RET

			END					;fim de programa