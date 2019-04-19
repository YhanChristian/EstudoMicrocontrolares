; ========================================================================
; =================      ETEC Arist�teles Ferreira.     ==================
; ========          Christopher Felix da Silva Santos          ===========
; =====   Programa_03  prognome.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================

; Exerc�cio para estudo das diretivas de programa, neste programa os caracteres 
; de seu nome ser�o escritos, em seus respectivos c�digos ASCII, na mem�ria     
; de programa (ROM, EPORM, EEPROM ou FLASH) seq�encialmente, a partir           
; do endere�o 120H
; Lembrando que p/ um caracter ser convertido em seu respectivo c�digo ASCII   
; pelo compilador basta colocarmos este entre aspas simples ( 'X� ).

              ORG 0120H     	; Endere�o que indica in�cio do programa na ROM.

              DB 'CHRISTOPHER'	; A partir de 120H da ROM escreveremos cada uma ; das letras em seu c�digo ASCII correspondente.

              END               ; Diretiva que indica fim de programa p/ o compilador.
