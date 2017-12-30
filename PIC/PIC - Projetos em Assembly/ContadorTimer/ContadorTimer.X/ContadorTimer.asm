;==============================================================================
; EXEMPLO 05 - CONTADOR COM TIMER TMR0 DE 0 A F
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
	W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA INTERRUPÇÕES
	STATUS_TEMP
	TEMPO		;ARMAZENA O VALOR DE TEMPO
	FLAGS
	TEMPO1
	TEMPO2	
	FILTRO1		;FILTRO DOS BOTÕES
	FILTRO2
    ENDC

;==============================================================================
; DEFINIÇÃO DE FLAGS UTILIZADOS 
;============================================================================== 
#DEFINE FIM FLAGS, 0 ;FIM DE TEMPO
#DEFINE STATUS_BOTAO1 FLAGS, 1 ; STATUS DO BOTÃO 1
#DEFINE STATUS_BOTAO2 FLAGS, 2 ; STATUS DO BOTÃO 2
    
;==============================================================================
; CONSTANTES
;==============================================================================
VALOR_INICIO EQU .15	    ;VALOR INICIO
T_FILTRO EQU .255	    ; FILTRO BOTÃO
    
;==============================================================================
; ENTRADAS E SAÍDAS 
;==============================================================================
#DEFINE BOTAO1 PORTA, 1 ;RA1 BOTAO1 0 -> PRESSIONADO 1 -> LIBERADO
#DEFINE BOTAO2 PORTA, 2 ;RA2 BOTAO2 0 -> PRESSIONADO 1 -> LIBERADO
#DEFINE LED PORTA, 3 ;RA3 LED 0 -> DESLIGADO 1 - > LIGADO
    
;==============================================================================
; VETOR DE RESET
;============================================================================== 
    ORG 0x00
    GOTO SETUP
    
;==============================================================================
; ROTINA DE INTERRUPÇÃO
;==============================================================================
    ORG 0x04
    MOVWF W_TEMP
    SWAPF STATUS, W
    MOVWF STATUS_TEMP
    BTFSS INTCON, T0IF ; VERIFICA INTERRUPÇÃO TMR0
    GOTO SAIR_INTERRUPCAO
    
; INTERRUPÇÃO 1s = 64us(PRESCALER) x 125 (TMR0) x 125 (TEMPO1)
   BCF INTCON, T0IF
   MOVLW .256 - .125
   MOVWF TMR0
   DECFSZ TEMPO1, F
   GOTO SAIR_INTERRUPCAO 
   MOVLW .125
   MOVWF TEMPO1
   BTFSC FIM
   GOTO SAIR_INTERRUPCAO
   DECFSZ TEMPO, F
   GOTO SAIR_INTERRUPCAO
   BSF FIM
   GOTO SAIR_INTERRUPCAO
   
; TERMINO DA INTERRUPCAO  - RECUPERA-SE VALOR DE W E STATUS E SAI DA ROTINA

SAIR_INTERRUPCAO
   SWAPF STATUS_TEMP, W
   MOVWF STATUS
   SWAPF W_TEMP, F
   SWAPF W_TEMP, W
   RETFIE
   

;==============================================================================
; ROTINA DE CONVERSÃO BINÁRIO DISPLAY 7SEG
; ROTINA IRÁ RETORNA EM W O SIMBOLO CORRETO QUE DEVERÁ SER EXIBIDO NO DISPLAY
; UTILIZAR ESTE PADRÃO DISPLAY CATODO COMUM
;==============================================================================
CONVERTER
    MOVF TEMPO, W
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
; ROTINA DE ATUALIZAÇÃO DO DISPLAY 7SEG
;==============================================================================
ATUALIZAR
    CALL CONVERTER
    MOVWF PORTB
    RETURN
    
;==============================================================================
; ROTINA PARA DESLIGAR TIMER
;==============================================================================
DESLIGAR_TIMER
    BCF INTCON, GIE
    BCF LED
    RETURN
    
;==============================================================================
; ROTINA PARA LIGAR TIMER
;==============================================================================    
LIGAR_TIMER
    BTFSC INTCON, GIE
    RETURN
    BCF INTCON, T0IF
    MOVLW .256 - .125
    MOVWF TMR0
    MOVLW .125
    MOVWF TEMPO1
    BSF INTCON, GIE
    BCF FIM
    BSF LED
    RETURN
    
;==============================================================================
; INICIO DO PROGRAMA - SETUP 
; LIMPA PORTA A E PORTB, MOVE PARA BANK 1 CARREGANDO TRISA (RA1 E RA2 ENTRADA,
; RA3 COMO SAÍDA E TRISB, CONFIGURA PRESCALER 1:64 NO TMR0 DESABILITA PULL-UPS
; INTERNOS, CHAVE GERAL INTERRUPÇÕES DESLIGADA, POR FIM VOLTO AO BANK 0 E 
; DESABILITO COMPARADORES E INICIALIZO AS VARIAVEIS.
;==============================================================================    
SETUP
    BANK1
    MOVLW B'00000110'
    MOVWF TRISA
    MOVLW B'00000000'
    MOVWF TRISB
    MOVLW B'10000101'
    MOVWF OPTION_REG
    MOVLW B'00100000'
    MOVWF INTCON
    BANK0
    MOVLW B'00000111'
    MOVWF CMCON
    CLRF PORTA
    CLRF PORTB
    CLRF FLAGS
    MOVLW VALOR_INICIO
    MOVWF TEMPO
    CALL ATUALIZAR
    
    
;==============================================================================
; ROTINA PRINCIPAL 
; CHECA BOTÕES PARA HABILITAR (BOTAO 01) OU DESABILITAR (BOTAO 02) O TIMER
; AO HABILITAR TIMER, CHAMA ROTINA DE INTERRUPÇÃO E LED FICA LIGADO SINALIZANDO
; AO DESABILITAR TIMER, DESLIGA CHAVE GERAL INTERRUPÇÃO E LIGA FICA DESLIGADO.
;==============================================================================
MAIN
    BTFSC FIM
    CALL DESLIGAR_TIMER
    CALL ATUALIZAR
    MOVLW T_FILTRO
    MOVWF FILTRO1
    MOVWF FILTRO2
    
CHECA_BOTAO1
    BTFSC BOTAO1
    GOTO BOTAO1_LIBERADO
    DECFSZ FILTRO1, F
    GOTO CHECA_BOTAO1
    BTFSS STATUS_BOTAO1
    GOTO ACAO_BOTAO1
    GOTO CHECA_BOTAO2

BOTAO1_LIBERADO
    BCF STATUS_BOTAO1

CHECA_BOTAO2
    BTFSC BOTAO2
    GOTO BOTAO2_LIBERADO
    DECFSZ FILTRO2, F
    GOTO CHECA_BOTAO2
    BTFSS STATUS_BOTAO2
    GOTO ACAO_BOTAO2
    GOTO MAIN

BOTAO2_LIBERADO
    BCF STATUS_BOTAO2
    GOTO MAIN
    
ACAO_BOTAO1
    BSF STATUS_BOTAO1
    CALL LIGAR_TIMER
    GOTO MAIN
    
ACAO_BOTAO2
    BSF STATUS_BOTAO2
    CALL DESLIGAR_TIMER
    GOTO MAIN
    
;==============================================================================
; TERMINO DE PROGRAMA
;==============================================================================
    END








