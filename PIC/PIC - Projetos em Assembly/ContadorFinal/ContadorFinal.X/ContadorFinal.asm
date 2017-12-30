;==============================================================================
; EXEMPLO 06 - CONTADOR FINAL - ACESSO A E2PROM
; BASEADO EM ESTUDOS COM O PIC16F628A
; AUTOR: YHAN CHRISTIAN SOUZA SILVA 
;==============================================================================

;==============================================================================
; DEFINIÇÕES INICIAIS DO HARDWARE
;==============================================================================
#INCLUDE <P16F628.INC> ; ARQUIVO PADRÃO MICROCHIP PARA O MODELO DE PIC
    
    __CONFIG _BOREN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC
;==============================================================================
; DEFINES PARA FACILITAR COMANDOS DE MUDANÇA DE BANCOS
;==============================================================================     
#DEFINE BANK0 BCF STATUS, RP0
#DEFINE BANK1 BSF STATUS, RP0

;==============================================================================
; DEFINIÇÃO DE ENDEREÇO DE VARIAVEIS
;==============================================================================         
    CBLOCK 0x20
	CONT
	FLAGS
	FILTRO1
	FILTRO2
    ENDC

;==============================================================================
; DEFINIÇÃO DE FLAGS UTILIZADOS 
;============================================================================== 
#DEFINE STATUS_BOTAO1 FLAGS, 0 ; STATUS DO BOTÃO 1
#DEFINE STATUS_BOTAO2 FLAGS, 1 ; STATUS DO BOTÃO 2
    
;==============================================================================
; CONSTANTES
;==============================================================================
MINIMO EQU .0	    ;VALOR MÍNIMO CONT
MAXIMO EQU .15	    ;VALOR MÁXIMO CONT
T_FILTRO EQU .255   ; FILTRO BOTÃO
POSICAO_MEMORIA EQU .0 ;ENDEREÇO E2PROM QUE ARMAZENA VALOR DE CONT
    
;==============================================================================
; ENTRADAS E SAÍDAS 
;==============================================================================
#DEFINE BOTAO1 PORTA, 1 ;RA1 BOTAO1 0 -> PRESSIONADO 1 -> LIBERADO
#DEFINE BOTAO2 PORTA, 2 ;RA2 BOTAO2 0 -> PRESSIONADO 1 -> LIBERADO
 
;==============================================================================
; INICIALIZAÇÃO E2PROM
;==============================================================================
    ORG H'2100'+POSICAO_MEMORIA
    DE .15 ; VALOR INICIAL DE CONT = F
    
;==============================================================================
; VETOR DE RESET
;============================================================================== 
    ORG 0x00
    GOTO SETUP
    
;==============================================================================
; ROTINA DE INTERRUPÇÃO - NÃO APLICADA NO PROJETO
;==============================================================================
    ORG 0x04	; ENDEREÇO INICIAL INTERRUPÇÃO
    RETFIE	;RETORNA DA INTERRUPÇÃO
    

;==============================================================================
; ROTINA DE CONVERSÃO BINÁRIO DISPLAY 7SEG
; ROTINA IRÁ RETORNA EM W O SIMBOLO CORRETO QUE DEVERÁ SER EXIBIDO NO DISPLAY
; UTILIZAR ESTE PADRÃO DISPLAY CATODO COMUM
;==============================================================================
CONVERTER
    MOVF CONT, W
    ANDLW B'00001111' ; MASCARA PARA CONT / LIMITA VALOR EM 15
    ADDWF PCL, F
    
    RETLW B'00111111' ;0
    RETLW B'00000110' ;1
    RETLW B'01011011' ;2
    RETLW B'01001111' ;3
    RETLW B'01100110' ;4
    RETLW B'01101101' ;5
    RETLW B'01111101' ;6
    RETLW B'00000111' ;7
    RETLW B'01111111' ;8
    RETLW B'01101111' ;9
    RETLW B'01110111' ;A
    RETLW B'01111100' ;B
    RETLW B'00111001' ;C
    RETLW B'01011110' ;D
    RETLW B'01111001' ;E
    RETLW B'01110001' ;F
    
;==============================================================================
; ROTINA LER E2PROM - MUDA PARA BANK1, PREPARA LEITURA, ARMAZENA EM W
;==============================================================================
LER_E2PROM
    BANK1
    BSF EECON1, RD
    MOVF EEDATA, W
    BANK0
    RETURN
    
;==============================================================================
; ROTINA ESCREVER E2PROM - ACERTA VALOR PASSADO EM W, DESABILTIA INTERRUPÇÕES
; HABILITA ESCRITA, INICIALIZA ESCRITA, TESTE O FIM DA ESCRITA, RETORNA AO BANK0
; HABILITA INTERRUPÇÕES
;==============================================================================
ESCREVER_E2PROM
    BANK1
    MOVWF EEDATA
    BCF INTCON, GIE
    BSF EECON1, WREN
    MOVLW 0x55
    MOVWF EECON2
    MOVLW 0xAA
    MOVWF EECON2
    BSF EECON1, WR
    BCF EECON1, WREN
    BTFSC EECON1, WR
    GOTO $-1
    BANK0
    BSF INTCON, GIE
    RETURN
    
;==============================================================================
; ROTINA LER CONT - LÊ VALOR NA MEMÓRIA E2PROM E COLOCA EM CONT
;==============================================================================
LER_CONT
    MOVLW POSICAO_MEMORIA
    BANK1
    MOVWF EEADR
    CALL LER_E2PROM
    MOVWF CONT
    RETURN

;==============================================================================
; ROTINA ESCREVER CONT - ESCREVE VALOR ATUAL DE CONT NA E2PROM
;==============================================================================
ESCREVER_CONT
    MOVLW POSICAO_MEMORIA
    BANK1
    MOVWF EEADR
    BANK0
    MOVF CONT, W
    CALL ESCREVER_E2PROM 
    RETURN   
    
    
    
;==============================================================================
; INICIO DO PROGRAMA - SETUP 
; LIMPA PORTA A E PORTB, MOVE PARA BANK 1 CARREGANDO TRISA (RA1 E RA2 ENTRADA)
; E TRISB, CONFIGURA PRESCALER 1:2 NO TMR0 DESABILITANDO PULL UPS INTERNOS, 
; DESLIGA INTERRUPÇÕES, POR FIM VOLTO AO BANK 0 E DESABILITO COMPARADORES 
; E INICIALIZO AS VARIAVEIS.
;==============================================================================    
SETUP
    BANK1
    MOVLW B'00000110'
    MOVWF TRISA
    MOVLW B'00000000'
    MOVWF TRISB
    MOVLW B'10000000'
    MOVWF OPTION_REG
    MOVLW B'00000000'
    MOVWF INTCON
    BANK0
    MOVLW B'00000111'
    MOVWF CMCON
    CLRF PORTA
    CLRF PORTB
    CLRF FLAGS
    CALL LER_CONT
    GOTO ATUALIZAR_DISPLAY
    
    
;==============================================================================
; ROTINA PRINCIPAL 
;ROTINAS PARA CHECAR BOTÃO 01 (DECREMENTA) E BOTÃO 02 (INCREMENTA) IMPREMENTADOS
;TRATAMENTO E LIMPEZA DE FAGS E POR FIM ROTINA ATUALIZA_DISPLAY CHAMA ROTINA 
; CONVERTER QUE RETORNA NO DISPLAY O VALOR CORRETO. CONTADOR DE 0 A F.
;==============================================================================
MAIN
    MOVLW T_FILTRO
    MOVWF FILTRO1
    MOVWF FILTRO2
    
CHECA_BOTAO1
    BTFSC BOTAO1
    GOTO BOTAO1_LIBERADO
    DECFSZ FILTRO1, F
    GOTO CHECA_BOTAO1
    BTFSS STATUS_BOTAO1
    GOTO DECREMENTAR
    GOTO CHECA_BOTAO2

BOTAO1_LIBERADO
    BCF STATUS_BOTAO1

CHECA_BOTAO2
    BTFSC BOTAO2
    GOTO BOTAO2_LIBERADO
    DECFSZ FILTRO2, F
    GOTO CHECA_BOTAO2
    BTFSS STATUS_BOTAO2
    GOTO INCREMENTAR
    GOTO MAIN

BOTAO2_LIBERADO
    BCF STATUS_BOTAO2
    GOTO MAIN
    

DECREMENTAR
    BSF STATUS_BOTAO1
    MOVF CONT, W
    XORLW MINIMO
    BTFSC STATUS, Z
    GOTO MAIN
    DECF CONT, F
    CALL ESCREVER_CONT
    GOTO ATUALIZAR_DISPLAY
    
INCREMENTAR
    BSF STATUS_BOTAO2
    MOVF CONT, W
    XORLW MAXIMO
    BTFSC STATUS, Z
    GOTO MAIN
    INCF CONT, F
    CALL ESCREVER_CONT
    
ATUALIZAR_DISPLAY
    CALL CONVERTER
    MOVWF PORTB
    GOTO MAIN
    
;==============================================================================
; TERMINO DE PROGRAMA
;==============================================================================
    END








