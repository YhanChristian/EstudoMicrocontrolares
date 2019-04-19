; ==================================================================================
; =================      ETEC Aristóteles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  registradores.asm  ver. 0.0 data: 29/03/13       ========                          
; ===================================================================================

	mov	R0,#00h		;movo para RO do banco B0 o valor de 00h
	mov	psw,#00001000b	;movo ara o psw "0 e 1" para os bits
				;"RS1 e RS0", selecionando o banco B1
	mov	psw,#08h	;mesma instrução acima só que com código 
				;em hexa para fazer RS1=0 e RS0=1 no psw
	mov	R0,#01		;movo para o R0 do banco B1 o valor 01h.
	setb	rs1		;faço diretamente o bit RS1=1. Como o bit
				;RS0 já era 1, teremos agora os dois em 1,
				;logo seleciono o banco B3.
	mov	R0,#03h		;movo então o valor 03h para o reg. R0 do B3.

	end			;fim do programa

;Verifique se realmente o primeiro dado foi para R0 do banco 0, depois se o segundo dado foi para RO do banco 1,etc.