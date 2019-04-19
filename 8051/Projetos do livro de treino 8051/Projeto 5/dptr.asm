; ==================================================================================
; =================      ETEC Aristóteles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  dptr.asm  ver. 0.0 data: 03/04/13       ========                          
; ===================================================================================

	org	0		;começo do programa
	mov	DPTR,#0010h	;escrevi o valor 0010h no registrador DPTR
	mov	A,#0h		;carrega ACC com 0h
	jmp	@A+DPTR		;vou desviar o PC (contador do programa) para
				;DPTR+A=DPTR(neste caso), isto é, vou fazer
				;o programa desviar para o endereço dado pelo DPTR
				
	org	0010h		;localizo a posição 0010h
	mov	DPH,#00h	;nesta posição (0010h). escrevi instrução para
	mov 	DPL,#20h	;mover 0020h para DPTR por meio de DPH e
				;DPL, isto é, por partes de 8 bits.
	jmp	@A+dptr		;desvio agora para o endereço 0020h
	org	0020h		;localizo a posição 0020h
	ljmp	0000h		;escrevi nesta posição (0020h) que voltarei
				;para a origem pór meio do "long jump".
				
	end			;fim de programa						