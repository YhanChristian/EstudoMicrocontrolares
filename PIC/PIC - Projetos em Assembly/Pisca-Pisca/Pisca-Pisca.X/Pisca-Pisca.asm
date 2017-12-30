;==============================================================================
; EXEMPLO 03 - PISCA PISCA 
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
	CONT
	FILTRO_BOTAO
	TEMPO1
	TEMPO2
	TEMPO3
    ENDC

;==============================================================================
; CONSTANTES
;==============================================================================
MINIMO EQU .10
MAXIMO EQU .240
STEP EQU .5
MULTIPLO EQU .5
DISPLAY EQU B'11111111' ;SERÁ EXIBIDO TODOS OS DIGITOS NO DISPLAY 7 SEG   
    
;==============================================================================
; ENTRADAS E SAÍDAS 
;==============================================================================
    #DEFINE BOTAO_INCREMENTO PORTA, 1 ; 0 -> PRESSIONADO 1 - > LIBERADO
    #DEFINE BOTAO_DECREMENTO PORTA, 2 ; 0 -> PRESSIONADO 1 - > LIBERADO
    
;==============================================================================
; VETOR DE RESET
;==============================================================================    
    ORG 0X00
    GOTO SETUP
    
;==============================================================================
; ROTINA DE DELAY
; O DELAY PRINCIPAL DURA 1ms SENDO MULTIPLICADO N VEZES, VALOR PASSADO POR W 
; PARA A ROTINA DURAR n MILISEGUNDOS. EXEMPLO W = 200, ROTINA AGUARDA 200ms.
;==============================================================================    
DELAY
    MOVWF TEMPO2
 
DELAY1
    MOVLW .200
    MOVWF TEMPO1

DELAY2
    NOP
    NOP
    DECFSZ TEMPO1, F
    GOTO DELAY2
    DECFSZ TEMPO2, F
    GOTO DELAY1
    RETURN
;==============================================================================
; INICIO DO PROGRAMA - SETUP 
; LIMPA PORTA A E PORTB, MOVE PARA BANK 1 CARREGANDO TRISA (RA1 E RA2 ENTRADA)
; E TRISB, CONFIGURAPRESCALER 1:2 NO TMR0 DESABILITANDO PULL UPS INTERNOS, 
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
    MOVLW DISPLAY
    MOVWF PORTB
    MOVLW MINIMO
    MOVWF CONT
    
    
;==============================================================================
; ROTINA PRINCIPAL 
; MOVE VALOR MULTIPLO PARA A CONSTANTE DE TEMPO3, ROTINA (MAIN1) VERIFICA SE 
; 1 DOS BOTÕES FORAM ACIONADOS, FAZ DECREMENTO DE TEMPO 3 ENVIA INFORMAÇÃO PARA
; O PORTB, ROTINA (DECREMENTA) FAZ DECREMENTO DO VALOR E ROTINA (INCREMENTA) FAZ
; INCREMENTO DO VALOR.
;==============================================================================
MAIN
    MOVLW MULTIPLO
    MOVWF TEMPO3

MAIN1
    MOVF CONT, W
    CALL DELAY
    BTFSS BOTAO_INCREMENTO
    GOTO INCREMENTA
    BTFSS BOTAO_DECREMENTO
    GOTO DECREMENTA
    DECFSZ TEMPO3, F
    GOTO MAIN1
    MOVLW DISPLAY
    XORWF PORTB, F
    GOTO MAIN

DECREMENTA
    MOVLW STEP
    SUBWF CONT, F
    MOVLW MINIMO
    SUBWF CONT, W
    BTFSC STATUS, C
    GOTO MAIN
    MOVLW MINIMO
    MOVWF CONT
    BTFSS BOTAO_DECREMENTO
    GOTO $-1
    GOTO MAIN

INCREMENTA
    MOVLW STEP
    SUBWF CONT, F
    MOVLW MAXIMO
    SUBWF CONT, W
    BTFSS STATUS, C
    GOTO MAIN
    MOVLW MAXIMO
    MOVWF CONT
    BTFSS BOTAO_INCREMENTO
    GOTO $-1
    GOTO MAIN

;==============================================================================
; TERMINO DE PROGRAMA
;==============================================================================
    END


