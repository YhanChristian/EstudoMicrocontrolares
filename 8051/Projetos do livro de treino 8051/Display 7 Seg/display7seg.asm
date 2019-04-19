; ==================================================================================
; =================      ETEC Aristóteles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  display7seg.asm  ver. 0.0 data: 03/04/13       ========                          
; ===================================================================================

;Rotina de inicialização
	mov		p3,#00h		;Apaga todos os segmentos
	mov		r0,#0ffh	;Armazena #0ffh em R0

;Rotina de leitura da palavra de entrada
ciclo1:	mov		a,p1		;Leitura do port p1
	anl		a,#00001111b	;"reseta" os 4 bits+significativos do acc
	cjne		a,00h,ciclo2	;se entrada atual for diferente da anterior, vá
					;para ciclo2, observe que 00H é o próprio R0
	sjmp		ciclo1		;caso contrário, volta a leitura do port p1
ciclo2:	mov		r0,a		;armazena entrada atual em r0
	sjmp		caract_0	;vá para caract_0
	

;Rotina de Varredura do caractere a ser mostrado

caract_0:	cjne	a,#0000b,caract_1	;Se a palavra de entrada diferente de 0000b,vá para caract_1
		mov	p3,#00111111b		;mostra caractere 0 no display (veja tabela)
		sjmp	ciclo1			;volta a rotina de leitura 
		
caract_1:	cjne	a,#0001b,caract_2	;Se a palavra de entrada diferente de 0001b,vá para caract_2
		mov	p3,#00000110b		;mostra caractere 1 no display
		sjmp	ciclo1			;volta a rotina de leitura
		
caract_2:	cjne	a,#0010b,caract_3	;Se a palavra de entrada diferente de 0010b, vá para caract_3
		mov	p3,#01011011b		;mostra caractere 2 no display
		sjmp	ciclo1			;volta a rotina de leitura

caract_3:	cjne	a,#0011b,caract_4	;Se a palavra de entrada diferente de 0011b, vá para caract_4
		mov	p3,#01001111b		;mostra caractere 3 no display
		sjmp	ciclo1			;volta a rotina de leitura

caract_4:	cjne	a,#0100b,caract_5	;Se a palavra de entrada diferente de 0100b, vá para caract_5
		mov	p3,#01100110b		;mostra caractere 4 no display
		sjmp	ciclo1			;volta a rotina de leitura

caract_5:	cjne	a,#0101b,caract_6	;Se a palavra de entrada diferente de 0101b, vá para caract_6
		mov	p3,#01101101b		;mostra caractere 5 no display
		sjmp	ciclo1			;volta a rotina de leitura
		
caract_6:	cjne	a,#0110b,caract_7	;Se a palavra de entrada diferente de 0110b, vá para caract_7
		mov	p3,#01111101b		;mostra caractere 6 no display
		sjmp	ciclo1			;volta a rotina de leitura
		
caract_7:	cjne	a,#0111b,caract_8	;Se a palavra de entrada diferente de 0111b, vá para caract_8
		mov	p3,#00000111b		;mostra caractere 7 no display
		sjmp	ciclo1			;volta a rotina de leitura
		
caract_8:	cjne	a,#1000b,caract_9	;Se a palavra de entrada diferente de 1000b, vá para caract_9
		mov	p3,#01111111b		;mostra caractere 8 no display
		sjmp	ciclo1			;volta a rotina de leitura

caract_9:	cjne	a,#1001b,caract_A	;Se a palavra de entrada diferente de 1001b, vá para caract_A
		mov	p3,#01101111b		;mostra caractere 9 no display
		sjmp	ciclo1			;volta a rotina de leitura

caract_A:	cjne	a,#1010b,caract_b	;Se a palavra de entrada diferente de 1010b, vá para caract_b
		mov	p3,#01110111b		;mostra caractere A no display
		sjmp	ciclo1			;volta a rotina de leitura

caract_b:	cjne	a,#1011b,caract_C	;Se a palavra de entrada diferente de 1011b, vá para caract_C
		mov	p3,#01111100b		;mostra caractere B no display
		ljmp	ciclo1			;volta a rotina de leitura

caract_C:	cjne	a,#1100b,caract_d	;Se a palavra de entrada diferente de 1100b, vá para caract_D
		mov	p3,#00111001b		;mostra caractere C no display
		ljmp	ciclo1			;volta a rotina de leitura

caract_d:	cjne	a,#1101b,caract_E	;Se a palavra de entrada diferente de 1101b, vá para caract_E
		mov	p3,#01011110b		;mostra caractere D no display
		ljmp	ciclo1			;volta a rotina de leitura

caract_E:	cjne	a,#1110b,caract_F	;Se a palavra de entrada diferente de 1110b, vá para caract_F
		mov	p3,#01111001b		;mostra caractere E no display
		ljmp	ciclo1			;volta a rotina de leitura

caract_F:	cjne	a,#1111b,pulo		;Se a palavra de entrada diferente de 1111b, vá
						;para pulo (rotina de leitura)
		mov	p3,#01110001b		;mostra caractere F no display
pulo:		ljmp	ciclo1			;volta a rotina de leitura

		end				;fim do programa

