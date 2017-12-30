;==============================================================================
; EXEMPLO 01 - BOTÃO DE LED
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
    CBLOCK 0X20 
    ENDC

;==============================================================================
; ENTRADAS E SAÍDAS 
;==============================================================================    
    
#DEFINE BOTAO PORTA, 2 ;DEFINE BOTÃO RA2 
#DEFINE LED PORTB,0 ;DEFINE LED OUTPUT RB0
    
;==============================================================================
; VETOR DE RESET
;==============================================================================    
    ORG 0X00
    GOTO SETUP

;==============================================================================
; INICIO DO PROGRAMA - SETUP 
; LIMPA PORTA A E PORTB, MOVE PARA BANK 1 CARREGANDO TRISA E TRIS, CONFIGURA 
; PRESCALER 1:2 NO TMR0 DESABILITANDO PULL UPS INTERNOS, DESLIGA INTERRUPÇÕES E
; POR FIM VOLTO AO BANK 0 E DESABILITO COMPARADORES
;==============================================================================    
SETUP
    CLRF PORTA 
    CLRF PORTB 
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
    
;==============================================================================
; ROTINA PRINCIPAL 
;==============================================================================
MAIN
    BTFSC BOTAO
    GOTO BOTAO_LIBERADO
    GOTO BOTAO_PRESSIONADO
    
BOTAO_LIBERADO
    BCF LED
    GOTO MAIN

BOTAO_PRESSIONADO
    BSF LED
    GOTO MAIN

;==============================================================================
; TERMINO DE PROGRAMA
;==============================================================================
    END


