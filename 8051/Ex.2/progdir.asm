; ========================================================================
; =================      ETEC Aristóteles Ferreira.     ==================
; ========          Christopher Felix da Silva Santos          ===========
; =====   Programa_03  prognome.asm  ver. 0.0 data: 26/03/13.   =========                          
; ========================================================================

; Exercício para estudo das diretivas de programa, neste programa os caracteres 
; de seu nome serão escritos, em seus respectivos códigos ASCII, na memória     
; de programa (ROM, EPORM, EEPROM ou FLASH) seqüencialmente, a partir           
; do endereço 120H
; Lembrando que p/ um caracter ser convertido em seu respectivo código ASCII   
; pelo compilador basta colocarmos este entre aspas simples ( 'X‘ ).

              ORG 0120H     	; Endereço que indica início do programa na ROM.

              DB 'CHRISTOPHER'	; A partir de 120H da ROM escreveremos cada uma ; das letras em seu código ASCII correspondente.

              END               ; Diretiva que indica fim de programa p/ o compilador.
