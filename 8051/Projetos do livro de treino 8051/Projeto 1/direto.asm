; ==================================================================================
; =================      ETEC Aristóteles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  direto.asm  ver. 0.0 data: 29/03/13       ========                          
; ===================================================================================

	org 	0000h			;começa o programa na linha 0000h da EPROM
	mov	A,#0h			;escrevo '00000000'b no acumulador A (ACC)
	mov	A,#0FFh			;escrevo '11111111'b no ACC
	mov	B,#0FFh			;escrevo '00001111'b no registrador B
	mov	R0,#0F0h		;escrevo '11110000'b no registrador R0
	mov	A,#15			;escrevo '00001111'b ou 0fh no ACC, por decimal
	mov 	A,#10101010b		;escrevo '10101010'b ou AAh no ACC, por binário
	mov 	A,#HIGH(0Fh)		;escrevo (a parte alta de 0F) em A
	mov	B,#LOW(0Fh)		;escrevo (a parte baixa de 0F) em B
	mov	A,#HIGH(65535)		;escrevo (a parte alta de 65535)=FFh em A
	mov	B,#LOW(65335)		;escrevo (a parte baixa de 65535)=FFh em B
	mov 	A,#(255-250)		;escrevo a diferença da conta 255-250=5=05h em A
	mov	A,#HIGH(255-240)	;escrevo a parte alta da conta (15=0Fh), que é 00h
					;em A(pois a parte alta de OFh é 0!)
	mov	B,#LOW(255-240)		;escrevo a parte baixa da conta (15=0Fh) que é 0Fh em B
	mov	A,#'A'			;escrevo em A o "código ASCII da letra A,
					;que é 65 em decimal, ou 41h(em hexa)
	mov 	A,#'B'			;escrevo em B o "codigo ASCII da letra B,
					;que é 66 em decimal, ou 42h(em hexa)
						
	end				;fim do programa	
	
						
						