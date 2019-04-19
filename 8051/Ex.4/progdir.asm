; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Christopher Felix da Silva Santos          ===========
; =====   Programa_04  prognum.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================

; Este exercício tem como função estudar diretivas de compilação, nele criaremos
; uma constante "NUMERO" com o auxílio do recurso EQU e a partir do endereço  ; indicado por esta constante colocaremos alguns números seqüencialmente na    ; ROM.


              NUMERO EQU 200H	; Aqui 200H recebe o nome de NUMERO.

              ORG NUMERO            	; End. que indica início do programa na ROM.

              DB 0FFH,10H,0C0H,2DH 	; A partir de 200H da ROM escreveremos 
				; cada um dos valores.

              END                  		; Diretiva de fim de programa p/ o compilador.
