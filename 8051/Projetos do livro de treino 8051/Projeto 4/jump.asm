; ==================================================================================
; =================      ETEC Aristóteles Ferreira   ==================
; ================     Yhan Christian Souza Silva        ================
; =====            Programa_01  jump.asm  ver. 0.0 data: 03/04/13       ========                          
; ===================================================================================

	ORG	0		;começa em 0000h
	MOV	A,#00H		;escrevi o valor 00h em A
VOLTA:	INC	A		;incremento A, por 1 (observe a utilização do Label volta)
	MOV	P1,A		;movo o valor de A para P1
	SJMP	VOLTA		;retorno o software para a posição com o nome "volta"
	
	END			;fim de programa	