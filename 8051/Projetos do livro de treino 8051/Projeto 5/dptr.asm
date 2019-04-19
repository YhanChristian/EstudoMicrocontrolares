; ==================================================================================
; =================      ETEC Arist�teles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  dptr.asm  ver. 0.0 data: 03/04/13       ========                          
; ===================================================================================

	org	0		;come�o do programa
	mov	DPTR,#0010h	;escrevi o valor 0010h no registrador DPTR
	mov	A,#0h		;carrega ACC com 0h
	jmp	@A+DPTR		;vou desviar o PC (contador do programa) para
				;DPTR+A=DPTR(neste caso), isto �, vou fazer
				;o programa desviar para o endere�o dado pelo DPTR
				
	org	0010h		;localizo a posi��o 0010h
	mov	DPH,#00h	;nesta posi��o (0010h). escrevi instru��o para
	mov 	DPL,#20h	;mover 0020h para DPTR por meio de DPH e
				;DPL, isto �, por partes de 8 bits.
	jmp	@A+dptr		;desvio agora para o endere�o 0020h
	org	0020h		;localizo a posi��o 0020h
	ljmp	0000h		;escrevi nesta posi��o (0020h) que voltarei
				;para a origem p�r meio do "long jump".
				
	end			;fim de programa						