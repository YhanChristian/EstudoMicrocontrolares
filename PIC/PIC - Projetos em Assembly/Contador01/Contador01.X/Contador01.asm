;==============================================================================
; EXEMPLO 02 - CONTADOR SIMPLIFICADO 
; BASEADO EM ESTUDOS COM O PIC16F628A
; AUTOR: YHAN CHRISTIAN SOUZA SILVA 
;==============================================================================

;==============================================================================
; DEFINI��ES INICIAIS DO HARDWARE
;==============================================================================
#INCLUDE <P16F628.INC> ; ARQUIVO PADR�O MICROCHIP PARA O MODELO DE PIC
    
    __CONFIG _BOREN_ON & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON & _XT_OSC
;==============================================================================
; DEFINES PARA FACILITAR COMANDOS DE MUDAN�A DE BANCOS
;==============================================================================     
#DEFINE BANK0 BCF STATUS, RP0
#DEFINE BANK1 BSF STATUS, RP0

;==============================================================================
; DEFINI��O DE ENDERE�O DE VARIAVEIS
;==============================================================================         
    CBLOCK 0X20
	CONT
	FLAGS
	FILTRO_BOTAO
    ENDC

;==============================================================================
; DEFINI��O DE FLAGS INTERNOS
;==============================================================================

#DEFINE SENTIDO FLAGS, 0 ; 0 -> SOMA 1 -> SUBTRAI

;==============================================================================
; CONSTANTES
;==============================================================================

MINIMO EQU .10
MAXIMO EQU .30
TEMPO_FILTRO EQU .230
    
;==============================================================================
; ENTRADAS E SA�DAS 
;==============================================================================
    
#DEFINE BOTAO PORTA, 2 ;DEFINE BOT�O RA2 0 -> PRESSIONADO 1 -> LIBERADO
    
;==============================================================================
; VETOR DE RESET
;==============================================================================    
    ORG 0X00
    GOTO SETUP

;==============================================================================
; INICIO DO PROGRAMA - SETUP 
; LIMPA PORTA A E PORTB, MOVE PARA BANK 1 CARREGANDO TRISA E TRISB, CONFIGURA 
; PRESCALER 1:2 NO TMR0 DESABILITANDO PULL UPS INTERNOS, DESLIGA INTERRUP��ES E
; POR FIM VOLTO AO BANK 0 E DESABILITO COMPARADORES E INICIALIZO AS VARIAVEIS
;==============================================================================    
SETUP
    BANK1
    MOVLW B'00000100'
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
    MOVLW MINIMO
    MOVWF CONT
    
;==============================================================================
; ROTINA PRINCIPAL 
; VERIFICA-SE O ESTADO DO BOT�O (CHECA_BOTAO), (TRATA_BOTAO) CHECA SENTIDO SE � 
; SOMA -> 0 OU SUBTRA��O-> 1 / SUBTRA��O DECREMENTA CONT,VERIFICA O VALOR
; MINIMO / SOMA INCREMENTA CONT, VERIFICA O VALOR MAXIMO. (ATUALIZA) ENVIA PARA 
; O PORTB A INFORMA��O E VERIFICA SE BOT�O EST� PRESSIONADO, SE N�O ESTIVER 
; RETORNA AO LOOP PRINCIPAL
;==============================================================================
MAIN
    MOVLW TEMPO_FILTRO
    MOVWF FILTRO_BOTAO

CHECA_BOTAO
    BTFSC BOTAO
    GOTO MAIN
    DECFSZ FILTRO_BOTAO, F
    GOTO CHECA_BOTAO
    
TRATA_BOTAO
    BTFSS SENTIDO
    GOTO SOMA

SUBTRACAO
    DECF CONT, F
    MOVLW MINIMO
    SUBWF CONT, W
    BTFSC STATUS, C
    GOTO ATUALIZA
    INCF CONT, F
    BCF SENTIDO
    GOTO MAIN

SOMA
    INCF CONT, F
    MOVLW MAXIMO
    SUBWF CONT, W
    BTFSS STATUS, C
    GOTO ATUALIZA
    BSF SENTIDO
    GOTO MAIN

ATUALIZA
    MOVF CONT, W
    MOVWF PORTB
    BTFSS BOTAO
    GOTO $-1
    GOTO MAIN

;==============================================================================
; TERMINO DE PROGRAMA
;==============================================================================
    END





