; ==================================================================================
; =================      ETEC Aristóteles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  origin.asm  ver. 0.0 data: 29/03/13       ========                          
; ===================================================================================

	org	0000h 		;começa o programa na linha 0000h da EPROM
	mov	A,#0FFh		;escrevo o '11111111'b no acumulador A (ACC)
	org 	000Fh		;começa o programa na linha 000Fh da EPROM
	mov	A,#00h		;escrevo '00000000'b no acumulador	
	
	end			;fim do programa

