; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Christopher Felix da Silva Santos          ===========
; =====   Programa_04  prognum.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================

; Este exerc�cio tem como fun��o estudar diretivas de compila��o, nele criaremos
; uma constante "NUMERO" com o aux�lio do recurso EQU e a partir do endere�o  ; indicado por esta constante colocaremos alguns n�meros seq�encialmente na    ; ROM.


              NUMERO EQU 200H	; Aqui 200H recebe o nome de NUMERO.

              ORG NUMERO            	; End. que indica in�cio do programa na ROM.

              DB 0FFH,10H,0C0H,2DH 	; A partir de 200H da ROM escreveremos 
				; cada um dos valores.

              END                  		; Diretiva de fim de programa p/ o compilador.
