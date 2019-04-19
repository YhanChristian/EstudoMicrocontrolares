; ========================================================================
; ==================     ETEC Aristóteles Ferreira.     ==================
; ========           Yhan Christian Souza Silva          =================
; ======     Exercicio_04  alarme.asm  ver. 0.0 data: 07/05/13.    =======                          
; ========================================================================

          
          
          ORG 0000			;Inicio de Programa
          
          MOV P0, #00H			;Limpo P0
          MOV P2, #0FFH			;Preparo P2.0 para leitu
          SETB P3.7			;Setar P3.7
          
ACIONAR00:JB P3.2, ACIONAR00		;Verificar acionamento de P3.2, pular para Acionar00
          JB P2.0, ACIONAR00		;Verificar acionamento de P2.0, pular para Acionar00
          SETB P0.0			;Setar P0.0
          LCALL TEMPOV			;Subrotina TempoV
          CLR P3.7			;Limpar P3.7

DESLIGAR: JB P3.2, DESLIGAR		;Verificar acionamento de P3.2, pular para Desligar
          SETB P3.7			;Setar P3.7
          SJMP ACIONAR0			;Pulo para Acionar0
DESLIGA1: MOV P0, #00H			;Movo para P0 o dado 00H
          SETB P3.7			;Setar P3.7
          SJMP ACIONAR00		;Pulo para Acionar00
          
FECHARP:  JB P2.0, ACIONAR1		;Verificar acionamento de P2.0, pular para Acionar1
          SJMP FECHARP			;Pulo para Fecharp
          
ACIONAR0: CLR P0.0			;Limpo P0.0
ACIONAR1: JNB P2.0, LED0		;Verifico se está em nível lógico 0 P2.0, pulo Led0
ACIONAR2: JNB P2.1, LED1		;Verifico se está em nível lógico 0 P2.1, pulo Led1
ACIONAR3: JNB P2.2, LED2		;Verifico se está em nível lógico 0 P2.2, pulo Led2	
ACIONAR4: JNB P2.3, LED3		;Verifico se está em nível lógico 0 P2.3, pulo Led3
ACIONAR5: JNB P2.4, LED4		;Verifico se está em nível lógico 0 P2.4, pulo Led4
ACIONAR6: JNB P2.5, LED5		;Verifico se está em nível lógico 0 P2.5, pulo Led5
ACIONAR7: JNB P2.6, LED6		;Verifico se está em nível lógico 0 P2.6, pulo Led6
ACIONAR8: JNB P2.7, LED7		;Verifico se está em nível lógico 0 P2.7, pulo Led7
          SJMP ACIONAR1			;Pulo para Acionar1
          
LED0:     SETB P0.0			;Seto P0.0
          LCALL TEMPOV			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          JB P3.2, ACIONAR2		;Verificar acionamento de P3.2, pular para Acionar2
DESLIGA2: SJMP DESLIGA1			;Pulo para Desliga1
LED1:     SETB P0.1			;Seto P0.1
          LCALL TEMPON			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          SJMP ACIONAR3			;Pulo para Acionar3
LED2:     SETB P0.2			;Seto P0.2
          LCALL TEMPON			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          SJMP ACIONAR4			;Pulo para Acionar4
LED3:     SETB P0.3			;Seto P0.3
          LCALL TEMPON			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          SJMP ACIONAR5			;Pulo para Acionar5
LED4:     SETB P0.4			;Seto P0.4
          LCALL TEMPON			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          SJMP ACIONAR6			;Pulo para Acionar6
LED5:     SETB P0.5			;Seto P0.5
          LCALL TEMPON			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          SJMP ACIONAR7			;Pulo para Acionar7
LED6:     SETB P0.6			;Seto P0.6
          LCALL TEMPON			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          SJMP ACIONAR1			;Pulo para Acionar1
LED7:     SETB P0.7			;Seto P0.7
          LCALL TEMPON			;Subrotina de tempo
          CLR P3.7			;Limpo P3.7
          SJMP ACIONAR2			;Pulo para Acionar2
          
;SUBROTINA TEMPO=(250X250X240X2)uS= 30000000uS= 30s.
TEMPOV:    JNB P3.2, DESLIGA2	     ;Verifico se está em nível lógico 0 P3.2, pulo Desliga2
           MOV R0, #240              ;Carrega R0 com 240.
VOLTA2:    JNB P3.2, DESLIGA2	     ;Verifico se está em nível lógico 0 P3.2, pulo Desliga2	
           JB P2.0, ACIONAR0         ;Verificar acionamento de P2.0, pular para Acionar0
           MOV R1, #250      	     ;Carrega R1 com 250.
VOLTA1:    JNB P3.2, DESLIGA2	     ;Verifico se está em nível lógico 0 P3.2, pulo Desliga2	
           JB P2.0, ACIONAR0         ;Verificar acionamento de P2.0, pular para Acionar0
           MOV R2, #250	             ;Carrega R2 com 250.
           DJNZ R2, $                ;Decrementa R2 até zerar.
           DJNZ R1, VOLTA1           ;Decrementa R1 e salta até zerar.
           DJNZ R0, VOLTA2           ;Decrementa R0 e salta até zerar.
           RET                       ;Retorno de subrotina.

;SUBROTINA TEMPO=(250X250X240X2)uS= 30000000uS= 30s.
TEMPON:    MOV R3, #240              ;Carrega R3 com 240.
VOLTA4:    MOV R4, #250      	     ;Carrega R4 com 250.
VOLTA3:    MOV R5, #250	             ;Carrega R5 com 250.
           DJNZ R5, $                ;Decrementa R5 até zerar.
           DJNZ R4, VOLTA3           ;Decrementa R4 e salta até zerar.
           DJNZ R3, VOLTA4           ;Decrementa R3 e salta até zerar.
           RET                       ;Retorno de subrotina.
           
           END			     ;Fim de programa


          
