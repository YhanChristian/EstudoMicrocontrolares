; ==================================================================================
; =================      ETEC Arist�teles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  label.asm  ver. 0.0 data: 29/03/13       ========                          
; ===================================================================================

	org	0		;come�a em 0
	mov	A,#00h		;escrevi o valor 00h no acumulador (=A)
volta:	inc 	A		;incremento A, por 1
	mov	P1,A		;movo o valor de A para P1
	sjmp	volta		;desvio para o endera�o dado pelo nome "volta"
	
	end			;fim do programa
