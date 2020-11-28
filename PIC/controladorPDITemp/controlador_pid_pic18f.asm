
_interrupt:

;controlador_pid_pic18f.c,117 :: 		void interrupt()
;controlador_pid_pic18f.c,119 :: 		if(TMR0IF_bit)
	BTFSS       TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
	GOTO        L_interrupt0
;controlador_pid_pic18f.c,121 :: 		TMR0IF_bit = 0x00;
	BCF         TMR0IF_bit+0, BitPos(TMR0IF_bit+0) 
;controlador_pid_pic18f.c,122 :: 		TMR0H      = 0x9E;
	MOVLW       158
	MOVWF       TMR0H+0 
;controlador_pid_pic18f.c,123 :: 		TMR0L      = 0x58;
	MOVLW       88
	MOVWF       TMR0L+0 
;controlador_pid_pic18f.c,126 :: 		debounceBtn = ~debounceBtn;
	BTG         _debounceBtn+0, BitPos(_debounceBtn+0) 
;controlador_pid_pic18f.c,127 :: 		contTempo100ms++;
	INFSNZ      _contTempo100ms+0, 1 
	INCF        _contTempo100ms+1, 1 
;controlador_pid_pic18f.c,128 :: 		contTempo2s++;
	INFSNZ      _contTempo2s+0, 1 
	INCF        _contTempo2s+1, 1 
;controlador_pid_pic18f.c,131 :: 		if(contTempo100ms == 4)
	MOVLW       0
	XORWF       _contTempo100ms+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt87
	MOVLW       4
	XORWF       _contTempo100ms+0, 0 
L__interrupt87:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;controlador_pid_pic18f.c,133 :: 		tempo100ms = ~tempo100ms;
	BTG         _tempo100ms+0, BitPos(_tempo100ms+0) 
;controlador_pid_pic18f.c,134 :: 		contTempo100ms = 0;
	CLRF        _contTempo100ms+0 
	CLRF        _contTempo100ms+1 
;controlador_pid_pic18f.c,135 :: 		}
L_interrupt1:
;controlador_pid_pic18f.c,138 :: 		if(contTempo2s == 80)
	MOVLW       0
	XORWF       _contTempo2s+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt88
	MOVLW       80
	XORWF       _contTempo2s+0, 0 
L__interrupt88:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt2
;controlador_pid_pic18f.c,140 :: 		tempo2s = ~tempo2s;
	BTG         _tempo2s+0, BitPos(_tempo2s+0) 
;controlador_pid_pic18f.c,141 :: 		contTempo2s = 0;
	CLRF        _contTempo2s+0 
	CLRF        _contTempo2s+1 
;controlador_pid_pic18f.c,142 :: 		}
L_interrupt2:
;controlador_pid_pic18f.c,143 :: 		}
L_interrupt0:
;controlador_pid_pic18f.c,145 :: 		if(TMR2IF_bit)
	BTFSS       TMR2IF_bit+0, BitPos(TMR2IF_bit+0) 
	GOTO        L_interrupt3
;controlador_pid_pic18f.c,147 :: 		TMR2IF_bit = 0x00;
	BCF         TMR2IF_bit+0, BitPos(TMR2IF_bit+0) 
;controlador_pid_pic18f.c,149 :: 		if(larguraPulso == 0x00)
	MOVF        _larguraPulso+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt4
;controlador_pid_pic18f.c,151 :: 		SAIDA_PWM = 0x00;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;controlador_pid_pic18f.c,152 :: 		}
	GOTO        L_interrupt5
L_interrupt4:
;controlador_pid_pic18f.c,156 :: 		if(SAIDA_PWM)
	BTFSS       LATB2_bit+0, BitPos(LATB2_bit+0) 
	GOTO        L_interrupt6
;controlador_pid_pic18f.c,158 :: 		TMR2 = larguraPulso;
	MOVF        _larguraPulso+0, 0 
	MOVWF       TMR2+0 
;controlador_pid_pic18f.c,159 :: 		SAIDA_PWM = 0x00;
	BCF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;controlador_pid_pic18f.c,161 :: 		}
	GOTO        L_interrupt7
L_interrupt6:
;controlador_pid_pic18f.c,164 :: 		TMR2 = 255 - larguraPulso;
	MOVF        _larguraPulso+0, 0 
	SUBLW       255
	MOVWF       TMR2+0 
;controlador_pid_pic18f.c,165 :: 		SAIDA_PWM = 0x01;
	BSF         LATB2_bit+0, BitPos(LATB2_bit+0) 
;controlador_pid_pic18f.c,167 :: 		}
L_interrupt7:
;controlador_pid_pic18f.c,168 :: 		}
L_interrupt5:
;controlador_pid_pic18f.c,169 :: 		}
L_interrupt3:
;controlador_pid_pic18f.c,170 :: 		}
L_end_interrupt:
L__interrupt86:
	RETFIE      1
; end of _interrupt

_main:

;controlador_pid_pic18f.c,173 :: 		void main()
;controlador_pid_pic18f.c,175 :: 		ADCON0  = 0x01;                           //Liga conversor AD
	MOVLW       1
	MOVWF       ADCON0+0 
;controlador_pid_pic18f.c,176 :: 		ADCON1  = 0x0E;                           //Configura os pinos do PORTB como digitais, e RA0 (PORTA) como analógico
	MOVLW       14
	MOVWF       ADCON1+0 
;controlador_pid_pic18f.c,177 :: 		ADCON2  = 0b00011000;
	MOVLW       24
	MOVWF       ADCON2+0 
;controlador_pid_pic18f.c,178 :: 		INTCON2.F7  = 0x00;                       //Habilita pull-ups no PORTB
	BCF         INTCON2+0, 7 
;controlador_pid_pic18f.c,179 :: 		TRISB       = 0xF8;                       //Configura o RB0, RB1, RB2 como saída
	MOVLW       248
	MOVWF       TRISB+0 
;controlador_pid_pic18f.c,180 :: 		TRISD       = 0x03;                       //Configura PORTD como saída, exceto RD0 e RD1
	MOVLW       3
	MOVWF       TRISD+0 
;controlador_pid_pic18f.c,181 :: 		LATB        = 0xFC;                       //Inicializa o LATB
	MOVLW       252
	MOVWF       LATB+0 
;controlador_pid_pic18f.c,183 :: 		INTCON      = 0xE0;                       //Habilita Interrupção Global, dos Periféricos e do Timer0
	MOVLW       224
	MOVWF       INTCON+0 
;controlador_pid_pic18f.c,184 :: 		TMR2IE_bit  = 0x01;                       //Habilita interrupção do Timer2
	BSF         TMR2IE_bit+0, BitPos(TMR2IE_bit+0) 
;controlador_pid_pic18f.c,185 :: 		TMR0H       = 0x9E;                       //Inicializa o TMR0H em 9Eh
	MOVLW       158
	MOVWF       TMR0H+0 
;controlador_pid_pic18f.c,186 :: 		TMR0L       = 0x58;                       //Inicializa o TMR0L em 58h
	MOVLW       88
	MOVWF       TMR0L+0 
;controlador_pid_pic18f.c,187 :: 		T0CON       = 0x81;                       //Liga TMR0, modo 16 bits, prescaler 1:4
	MOVLW       129
	MOVWF       T0CON+0 
;controlador_pid_pic18f.c,188 :: 		T2CON       = 0x05;                       //Liga TMR2, prescaler 1:4, postscaler 1:1
	MOVLW       5
	MOVWF       T2CON+0 
;controlador_pid_pic18f.c,189 :: 		PR2         = 0xFF;                       //Compara TMR2 com FFh
	MOVLW       255
	MOVWF       PR2+0 
;controlador_pid_pic18f.c,192 :: 		larguraPulso = PWM_INICIAL;                              //inicia PWM com duty 50%
	MOVLW       128
	MOVWF       _larguraPulso+0 
;controlador_pid_pic18f.c,195 :: 		LCD_Init();                               //Inicializa LCD
	CALL        _Lcd_Init+0, 0
;controlador_pid_pic18f.c,196 :: 		LCD_cmd(_LCD_CURSOR_OFF);                 //apaga cursor
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;controlador_pid_pic18f.c,197 :: 		LCD_cmd(_LCD_CLEAR);                      //limpa display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;controlador_pid_pic18f.c,199 :: 		telaInicialSistema();
	CALL        _telaInicialSistema+0, 0
;controlador_pid_pic18f.c,201 :: 		while(1)
L_main8:
;controlador_pid_pic18f.c,204 :: 		leituraBtn();
	CALL        _leituraBtn+0, 0
;controlador_pid_pic18f.c,208 :: 		if(modoConfig)
	BTFSS       _modoConfig+0, BitPos(_modoConfig+0) 
	GOTO        L_main10
;controlador_pid_pic18f.c,210 :: 		ajusteConfig();
	CALL        _ajusteConfig+0, 0
;controlador_pid_pic18f.c,211 :: 		}
	GOTO        L_main11
L_main10:
;controlador_pid_pic18f.c,215 :: 		exibePWMAtual();                    //imprime valor no LCD
	CALL        _exibePWMAtual+0, 0
;controlador_pid_pic18f.c,216 :: 		celsius();                          //calcula temperatura
	CALL        _celsius+0, 0
;controlador_pid_pic18f.c,217 :: 		}
L_main11:
;controlador_pid_pic18f.c,221 :: 		if(tempo100ms)
	BTFSS       _tempo100ms+0, BitPos(_tempo100ms+0) 
	GOTO        L_main12
;controlador_pid_pic18f.c,223 :: 		controlePID();
	CALL        _controlePID+0, 0
;controlador_pid_pic18f.c,224 :: 		tempo100ms = 0;                 //limpo a flag
	BCF         _tempo100ms+0, BitPos(_tempo100ms+0) 
;controlador_pid_pic18f.c,225 :: 		}
L_main12:
;controlador_pid_pic18f.c,228 :: 		}
	GOTO        L_main8
;controlador_pid_pic18f.c,231 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_telaInicialSistema:

;controlador_pid_pic18f.c,237 :: 		void telaInicialSistema()
;controlador_pid_pic18f.c,239 :: 		LCD_chr(1,1,'P');                         //imprime 'P'
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       80
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,240 :: 		LCD_chr_cp ('W');                         //imprime 'W'
	MOVLW       87
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,241 :: 		LCD_chr_cp ('M');                         //imprime 'M'
	MOVLW       77
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,242 :: 		LCD_chr_cp (':');                         //imprime ':'
	MOVLW       58
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,243 :: 		LCD_chr(2,1,'T');                         //imprime 'T'
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       84
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,244 :: 		LCD_chr_cp ('M');                         //imprime 'M'
	MOVLW       77
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,245 :: 		LCD_chr_cp ('P');                         //imprime 'P'
	MOVLW       80
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,246 :: 		LCD_chr_cp (':');                         //imprime ':'
	MOVLW       58
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,247 :: 		}
L_end_telaInicialSistema:
	RETURN      0
; end of _telaInicialSistema

_controlePID:

;controlador_pid_pic18f.c,248 :: 		void controlePID()
;controlador_pid_pic18f.c,250 :: 		medida = temperatura;
	MOVF        _temperatura+0, 0 
	MOVWF       R0 
	MOVF        _temperatura+1, 0 
	MOVWF       R1 
	MOVF        _temperatura+2, 0 
	MOVWF       R2 
	MOVF        _temperatura+3, 0 
	MOVWF       R3 
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__controlePID+12 
	MOVF        R1, 0 
	MOVWF       FLOC__controlePID+13 
	MOVF        FLOC__controlePID+12, 0 
	MOVWF       _medida+0 
	MOVF        FLOC__controlePID+13, 0 
	MOVWF       _medida+1 
;controlador_pid_pic18f.c,252 :: 		erroMedido = setpoint - medida;
	MOVF        FLOC__controlePID+12, 0 
	MOVWF       R0 
	MOVF        FLOC__controlePID+13, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        _setpoint+0, 0 
	MOVWF       R0 
	MOVF        _setpoint+1, 0 
	MOVWF       R1 
	MOVF        _setpoint+2, 0 
	MOVWF       R2 
	MOVF        _setpoint+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__controlePID+0 
	MOVF        R1, 0 
	MOVWF       FLOC__controlePID+1 
	MOVF        R2, 0 
	MOVWF       FLOC__controlePID+2 
	MOVF        R3, 0 
	MOVWF       FLOC__controlePID+3 
	MOVF        FLOC__controlePID+0, 0 
	MOVWF       _erroMedido+0 
	MOVF        FLOC__controlePID+1, 0 
	MOVWF       _erroMedido+1 
	MOVF        FLOC__controlePID+2, 0 
	MOVWF       _erroMedido+2 
	MOVF        FLOC__controlePID+3, 0 
	MOVWF       _erroMedido+3 
;controlador_pid_pic18f.c,254 :: 		proporcional = erroMedido * kp;
	MOVF        FLOC__controlePID+0, 0 
	MOVWF       R0 
	MOVF        FLOC__controlePID+1, 0 
	MOVWF       R1 
	MOVF        FLOC__controlePID+2, 0 
	MOVWF       R2 
	MOVF        FLOC__controlePID+3, 0 
	MOVWF       R3 
	MOVF        _kp+0, 0 
	MOVWF       R4 
	MOVF        _kp+1, 0 
	MOVWF       R5 
	MOVF        _kp+2, 0 
	MOVWF       R6 
	MOVF        _kp+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__controlePID+8 
	MOVF        R1, 0 
	MOVWF       FLOC__controlePID+9 
	MOVF        R2, 0 
	MOVWF       FLOC__controlePID+10 
	MOVF        R3, 0 
	MOVWF       FLOC__controlePID+11 
	MOVF        FLOC__controlePID+8, 0 
	MOVWF       _proporcional+0 
	MOVF        FLOC__controlePID+9, 0 
	MOVWF       _proporcional+1 
	MOVF        FLOC__controlePID+10, 0 
	MOVWF       _proporcional+2 
	MOVF        FLOC__controlePID+11, 0 
	MOVWF       _proporcional+3 
;controlador_pid_pic18f.c,256 :: 		integral += (erroMedido * ki) * TEMPO_CALCULO_PID;
	MOVF        FLOC__controlePID+0, 0 
	MOVWF       R0 
	MOVF        FLOC__controlePID+1, 0 
	MOVWF       R1 
	MOVF        FLOC__controlePID+2, 0 
	MOVWF       R2 
	MOVF        FLOC__controlePID+3, 0 
	MOVWF       R3 
	MOVF        _ki+0, 0 
	MOVWF       R4 
	MOVF        _ki+1, 0 
	MOVWF       R5 
	MOVF        _ki+2, 0 
	MOVWF       R6 
	MOVF        _ki+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        _integral+0, 0 
	MOVWF       R4 
	MOVF        _integral+1, 0 
	MOVWF       R5 
	MOVF        _integral+2, 0 
	MOVWF       R6 
	MOVF        _integral+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__controlePID+4 
	MOVF        R1, 0 
	MOVWF       FLOC__controlePID+5 
	MOVF        R2, 0 
	MOVWF       FLOC__controlePID+6 
	MOVF        R3, 0 
	MOVWF       FLOC__controlePID+7 
	MOVF        FLOC__controlePID+4, 0 
	MOVWF       _integral+0 
	MOVF        FLOC__controlePID+5, 0 
	MOVWF       _integral+1 
	MOVF        FLOC__controlePID+6, 0 
	MOVWF       _integral+2 
	MOVF        FLOC__controlePID+7, 0 
	MOVWF       _integral+3 
;controlador_pid_pic18f.c,258 :: 		derivativo = ((ultimaMedida - medida) * kd) / TEMPO_CALCULO_PID;
	MOVF        FLOC__controlePID+12, 0 
	SUBWF       _ultimaMedida+0, 0 
	MOVWF       R0 
	MOVF        FLOC__controlePID+13, 0 
	SUBWFB      _ultimaMedida+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        _kd+0, 0 
	MOVWF       R4 
	MOVF        _kd+1, 0 
	MOVWF       R5 
	MOVF        _kd+2, 0 
	MOVWF       R6 
	MOVF        _kd+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__controlePID+0 
	MOVF        R1, 0 
	MOVWF       FLOC__controlePID+1 
	MOVF        R2, 0 
	MOVWF       FLOC__controlePID+2 
	MOVF        R3, 0 
	MOVWF       FLOC__controlePID+3 
	MOVF        FLOC__controlePID+0, 0 
	MOVWF       _derivativo+0 
	MOVF        FLOC__controlePID+1, 0 
	MOVWF       _derivativo+1 
	MOVF        FLOC__controlePID+2, 0 
	MOVWF       _derivativo+2 
	MOVF        FLOC__controlePID+3, 0 
	MOVWF       _derivativo+3 
;controlador_pid_pic18f.c,260 :: 		ultimaMedida = medida;
	MOVF        FLOC__controlePID+12, 0 
	MOVWF       _ultimaMedida+0 
	MOVF        FLOC__controlePID+13, 0 
	MOVWF       _ultimaMedida+1 
;controlador_pid_pic18f.c,262 :: 		PID = proporcional + integral + derivativo;
	MOVF        FLOC__controlePID+8, 0 
	MOVWF       R0 
	MOVF        FLOC__controlePID+9, 0 
	MOVWF       R1 
	MOVF        FLOC__controlePID+10, 0 
	MOVWF       R2 
	MOVF        FLOC__controlePID+11, 0 
	MOVWF       R3 
	MOVF        FLOC__controlePID+4, 0 
	MOVWF       R4 
	MOVF        FLOC__controlePID+5, 0 
	MOVWF       R5 
	MOVF        FLOC__controlePID+6, 0 
	MOVWF       R6 
	MOVF        FLOC__controlePID+7, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        FLOC__controlePID+0, 0 
	MOVWF       R4 
	MOVF        FLOC__controlePID+1, 0 
	MOVWF       R5 
	MOVF        FLOC__controlePID+2, 0 
	MOVWF       R6 
	MOVF        FLOC__controlePID+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _PID+0 
	MOVF        R1, 0 
	MOVWF       _PID+1 
	MOVF        R2, 0 
	MOVWF       _PID+2 
	MOVF        R3, 0 
	MOVWF       _PID+3 
;controlador_pid_pic18f.c,264 :: 		PID = PID / 4;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _PID+0 
	MOVF        R1, 0 
	MOVWF       _PID+1 
	MOVF        R2, 0 
	MOVWF       _PID+2 
	MOVF        R3, 0 
	MOVWF       _PID+3 
;controlador_pid_pic18f.c,265 :: 		larguraPulso = PID + 128;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       134
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	CALL        _double2byte+0, 0
	MOVF        R0, 0 
	MOVWF       _larguraPulso+0 
;controlador_pid_pic18f.c,266 :: 		if(larguraPulso == 256) larguraPulso = 255;
	MOVLW       0
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L__controlePID92
	MOVLW       0
	XORWF       R0, 0 
L__controlePID92:
	BTFSS       STATUS+0, 2 
	GOTO        L_controlePID13
	MOVLW       255
	MOVWF       _larguraPulso+0 
L_controlePID13:
;controlador_pid_pic18f.c,268 :: 		}
L_end_controlePID:
	RETURN      0
; end of _controlePID

_celsius:

;controlador_pid_pic18f.c,270 :: 		void celsius()
;controlador_pid_pic18f.c,273 :: 		mediaADC = tempMedia();
	CALL        _tempMedia+0, 0
	MOVF        R0, 0 
	MOVWF       _mediaADC+0 
	MOVF        R1, 0 
	MOVWF       _mediaADC+1 
;controlador_pid_pic18f.c,275 :: 		temperatura = ((mediaADC * 5.0) / 1024.0);
	CALL        _int2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _temperatura+0 
	MOVF        R1, 0 
	MOVWF       _temperatura+1 
	MOVF        R2, 0 
	MOVWF       _temperatura+2 
	MOVF        R3, 0 
	MOVWF       _temperatura+3 
;controlador_pid_pic18f.c,277 :: 		temperatura = temperatura * 100.0;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__celsius+0 
	MOVF        R1, 0 
	MOVWF       FLOC__celsius+1 
	MOVF        R2, 0 
	MOVWF       FLOC__celsius+2 
	MOVF        R3, 0 
	MOVWF       FLOC__celsius+3 
	MOVF        FLOC__celsius+0, 0 
	MOVWF       _temperatura+0 
	MOVF        FLOC__celsius+1, 0 
	MOVWF       _temperatura+1 
	MOVF        FLOC__celsius+2, 0 
	MOVWF       _temperatura+2 
	MOVF        FLOC__celsius+3, 0 
	MOVWF       _temperatura+3 
;controlador_pid_pic18f.c,280 :: 		if(temperatura < (temperaturaAtual - 0.5) || temperatura > (temperaturaAtual + 0.5))
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	MOVF        _temperaturaAtual+0, 0 
	MOVWF       R0 
	MOVF        _temperaturaAtual+1, 0 
	MOVWF       R1 
	MOVF        _temperaturaAtual+2, 0 
	MOVWF       R2 
	MOVF        _temperaturaAtual+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__celsius+0, 0 
	MOVWF       R0 
	MOVF        FLOC__celsius+1, 0 
	MOVWF       R1 
	MOVF        FLOC__celsius+2, 0 
	MOVWF       R2 
	MOVF        FLOC__celsius+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__celsius80
	MOVF        _temperaturaAtual+0, 0 
	MOVWF       R0 
	MOVF        _temperaturaAtual+1, 0 
	MOVWF       R1 
	MOVF        _temperaturaAtual+2, 0 
	MOVWF       R2 
	MOVF        _temperaturaAtual+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        _temperatura+0, 0 
	MOVWF       R4 
	MOVF        _temperatura+1, 0 
	MOVWF       R5 
	MOVF        _temperatura+2, 0 
	MOVWF       R6 
	MOVF        _temperatura+3, 0 
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__celsius80
	GOTO        L_celsius16
L__celsius80:
;controlador_pid_pic18f.c,283 :: 		temperaturaAtual = temperatura;
	MOVF        _temperatura+0, 0 
	MOVWF       _temperaturaAtual+0 
	MOVF        _temperatura+1, 0 
	MOVWF       _temperaturaAtual+1 
	MOVF        _temperatura+2, 0 
	MOVWF       _temperaturaAtual+2 
	MOVF        _temperatura+3, 0 
	MOVWF       _temperaturaAtual+3 
;controlador_pid_pic18f.c,285 :: 		FloatToStr(temperatura, txt);
	MOVF        _temperatura+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _temperatura+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _temperatura+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _temperatura+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;controlador_pid_pic18f.c,287 :: 		Lcd_Chr(2, 6, txt[0]);                    //Imprime no LCD posição 0 da string txt
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _txt+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,288 :: 		Lcd_Chr_Cp (txt[1]);                     //Imprime no LCD posição 1 da string txt
	MOVF        _txt+1, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,289 :: 		Lcd_Chr_Cp (txt[2]);                     //Imprime no LCD posição 2 da string txt
	MOVF        _txt+2, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,290 :: 		Lcd_Chr_Cp (txt[3]);                     //Imprime no LCD posição 3 da string txt
	MOVF        _txt+3, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,291 :: 		Lcd_Chr_Cp (txt[4]);                     //Imprime no LCD posição 4 da string txt
	MOVF        _txt+4, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,292 :: 		CustomChar(2, 11);                        //Imprime no LCD caractere especial º
	MOVLW       2
	MOVWF       FARG_CustomChar_r+0 
	MOVLW       11
	MOVWF       FARG_CustomChar_c+0 
	CALL        _CustomChar+0, 0
;controlador_pid_pic18f.c,293 :: 		Lcd_Chr(2, 12,  'C');                     //Imprime no LCD
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,295 :: 		}
L_celsius16:
;controlador_pid_pic18f.c,297 :: 		}
L_end_celsius:
	RETURN      0
; end of _celsius

_tempMedia:

;controlador_pid_pic18f.c,299 :: 		int tempMedia()
;controlador_pid_pic18f.c,301 :: 		char i = 0;
	CLRF        tempMedia_i_L0+0 
	CLRF        tempMedia_acumulaTemp_L0+0 
	CLRF        tempMedia_acumulaTemp_L0+1 
;controlador_pid_pic18f.c,304 :: 		for(i = 0; i < AMOSTRAS_TEMP; i++)
	CLRF        tempMedia_i_L0+0 
L_tempMedia17:
	MOVLW       100
	SUBWF       tempMedia_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tempMedia18
;controlador_pid_pic18f.c,306 :: 		acumulaTemp += ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	ADDWF       tempMedia_acumulaTemp_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      tempMedia_acumulaTemp_L0+1, 1 
;controlador_pid_pic18f.c,304 :: 		for(i = 0; i < AMOSTRAS_TEMP; i++)
	INCF        tempMedia_i_L0+0, 1 
;controlador_pid_pic18f.c,308 :: 		}
	GOTO        L_tempMedia17
L_tempMedia18:
;controlador_pid_pic18f.c,310 :: 		return(acumulaTemp / AMOSTRAS_TEMP);
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        tempMedia_acumulaTemp_L0+0, 0 
	MOVWF       R0 
	MOVF        tempMedia_acumulaTemp_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
;controlador_pid_pic18f.c,312 :: 		}
L_end_tempMedia:
	RETURN      0
; end of _tempMedia

_CustomChar:

;controlador_pid_pic18f.c,314 :: 		void CustomChar(char r, char c)
;controlador_pid_pic18f.c,317 :: 		Lcd_Cmd(72);
	MOVLW       72
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;controlador_pid_pic18f.c,318 :: 		for (i = 0; i<=7; i++) Lcd_Chr_CP(grausCelsius[i]);
	CLRF        CustomChar_i_L0+0 
L_CustomChar20:
	MOVF        CustomChar_i_L0+0, 0 
	SUBLW       7
	BTFSS       STATUS+0, 0 
	GOTO        L_CustomChar21
	MOVLW       _grausCelsius+0
	ADDWF       CustomChar_i_L0+0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       hi_addr(_grausCelsius+0)
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      TBLPTR+1, 1 
	MOVLW       higher_addr(_grausCelsius+0)
	MOVWF       TBLPTR+2 
	MOVLW       0
	ADDWFC      TBLPTR+2, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Lcd_Chr_CP_out_char+0
	CALL        _Lcd_Chr_CP+0, 0
	INCF        CustomChar_i_L0+0, 1 
	GOTO        L_CustomChar20
L_CustomChar21:
;controlador_pid_pic18f.c,319 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;controlador_pid_pic18f.c,320 :: 		Lcd_Chr(r, c, 1);
	MOVF        FARG_CustomChar_r+0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        FARG_CustomChar_c+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,322 :: 		}
L_end_CustomChar:
	RETURN      0
; end of _CustomChar

_exibePWMAtual:

;controlador_pid_pic18f.c,324 :: 		void exibePWMAtual()
;controlador_pid_pic18f.c,328 :: 		valor = larguraPulso;
	MOVF        _larguraPulso+0, 0 
	MOVWF       _valor+0 
;controlador_pid_pic18f.c,330 :: 		dig3 = valor / 100;                        //calcula dígito 3
	MOVLW       100
	MOVWF       R4 
	MOVF        _larguraPulso+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__exibePWMAtual+0 
	MOVLW       100
	MOVWF       R4 
	MOVF        _larguraPulso+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
;controlador_pid_pic18f.c,331 :: 		dig2 = (valor % 100) / 10;                 //calcula dígito 2
	MOVLW       10
	MOVWF       R4 
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       exibePWMAtual_dig2_L0+0 
;controlador_pid_pic18f.c,332 :: 		dig1 = valor % 10;                        //calcula dígito 1
	MOVLW       10
	MOVWF       R4 
	MOVF        _larguraPulso+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       exibePWMAtual_dig1_L0+0 
;controlador_pid_pic18f.c,334 :: 		Lcd_chr(1, 6, dig3 + 0x30);               //imprime dígito 5
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       FLOC__exibePWMAtual+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,335 :: 		Lcd_chr_cp (dig2 + 0x30);                 //imprime dígito 4
	MOVLW       48
	ADDWF       exibePWMAtual_dig2_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,336 :: 		Lcd_chr_cp (dig1 + 0x30);                 //imprime dígito 3
	MOVLW       48
	ADDWF       exibePWMAtual_dig1_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,337 :: 		}
L_end_exibePWMAtual:
	RETURN      0
; end of _exibePWMAtual

_leituraBtn:

;controlador_pid_pic18f.c,339 :: 		void leituraBtn()
;controlador_pid_pic18f.c,342 :: 		if(!BTN_AJUSTE)
	BTFSC       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_leituraBtn23
;controlador_pid_pic18f.c,345 :: 		btnAjustePress = 1;
	BSF         _btnAjustePress+0, BitPos(_btnAjustePress+0) 
;controlador_pid_pic18f.c,346 :: 		if (debounceBtn)
	BTFSS       _debounceBtn+0, BitPos(_debounceBtn+0) 
	GOTO        L_leituraBtn24
;controlador_pid_pic18f.c,348 :: 		btnAjustePress = 1;
	BSF         _btnAjustePress+0, BitPos(_btnAjustePress+0) 
;controlador_pid_pic18f.c,349 :: 		debounceBtn  = 0;
	BCF         _debounceBtn+0, BitPos(_debounceBtn+0) 
;controlador_pid_pic18f.c,350 :: 		}
L_leituraBtn24:
;controlador_pid_pic18f.c,351 :: 		}
L_leituraBtn23:
;controlador_pid_pic18f.c,352 :: 		if(BTN_AJUSTE && btnAjustePress)
	BTFSS       RB4_bit+0, BitPos(RB4_bit+0) 
	GOTO        L_leituraBtn27
	BTFSS       _btnAjustePress+0, BitPos(_btnAjustePress+0) 
	GOTO        L_leituraBtn27
L__leituraBtn84:
;controlador_pid_pic18f.c,354 :: 		if(!modoConfig)
	BTFSC       _modoConfig+0, BitPos(_modoConfig+0) 
	GOTO        L_leituraBtn28
;controlador_pid_pic18f.c,356 :: 		modoConfig = 1;
	BSF         _modoConfig+0, BitPos(_modoConfig+0) 
;controlador_pid_pic18f.c,357 :: 		trocaTela = 1;
	BSF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,358 :: 		}
	GOTO        L_leituraBtn29
L_leituraBtn28:
;controlador_pid_pic18f.c,359 :: 		else if(modoConfig)
	BTFSS       _modoConfig+0, BitPos(_modoConfig+0) 
	GOTO        L_leituraBtn30
;controlador_pid_pic18f.c,361 :: 		menuConfig++;
	INFSNZ      _menuConfig+0, 1 
	INCF        _menuConfig+1, 1 
;controlador_pid_pic18f.c,362 :: 		trocaTela = 1;
	BSF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,363 :: 		}
L_leituraBtn30:
L_leituraBtn29:
;controlador_pid_pic18f.c,364 :: 		contTempo2s = 0;
	CLRF        _contTempo2s+0 
	CLRF        _contTempo2s+1 
;controlador_pid_pic18f.c,365 :: 		btnAjustePress = 0;
	BCF         _btnAjustePress+0, BitPos(_btnAjustePress+0) 
;controlador_pid_pic18f.c,366 :: 		}
L_leituraBtn27:
;controlador_pid_pic18f.c,370 :: 		if(modoConfig)
	BTFSS       _modoConfig+0, BitPos(_modoConfig+0) 
	GOTO        L_leituraBtn31
;controlador_pid_pic18f.c,372 :: 		if(!BTN_INC)
	BTFSC       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_leituraBtn32
;controlador_pid_pic18f.c,374 :: 		if(debounceBtn)
	BTFSS       _debounceBtn+0, BitPos(_debounceBtn+0) 
	GOTO        L_leituraBtn33
;controlador_pid_pic18f.c,376 :: 		btnIncPress = 1;
	BSF         _btnIncPress+0, BitPos(_btnIncPress+0) 
;controlador_pid_pic18f.c,377 :: 		debounceBtn = 0;
	BCF         _debounceBtn+0, BitPos(_debounceBtn+0) 
;controlador_pid_pic18f.c,378 :: 		}
L_leituraBtn33:
;controlador_pid_pic18f.c,379 :: 		}
L_leituraBtn32:
;controlador_pid_pic18f.c,381 :: 		if(BTN_INC && btnIncPress)
	BTFSS       RB5_bit+0, BitPos(RB5_bit+0) 
	GOTO        L_leituraBtn36
	BTFSS       _btnIncPress+0, BitPos(_btnIncPress+0) 
	GOTO        L_leituraBtn36
L__leituraBtn83:
;controlador_pid_pic18f.c,384 :: 		if(menuConfig == 1)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn98
	MOVLW       1
	XORWF       _menuConfig+0, 0 
L__leituraBtn98:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn37
;controlador_pid_pic18f.c,386 :: 		setpoint+= 0.5;
	MOVF        _setpoint+0, 0 
	MOVWF       R0 
	MOVF        _setpoint+1, 0 
	MOVWF       R1 
	MOVF        _setpoint+2, 0 
	MOVWF       R2 
	MOVF        _setpoint+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _setpoint+0 
	MOVF        R1, 0 
	MOVWF       _setpoint+1 
	MOVF        R2, 0 
	MOVWF       _setpoint+2 
	MOVF        R3, 0 
	MOVWF       _setpoint+3 
;controlador_pid_pic18f.c,387 :: 		if(setpoint > SETPOINT_MAX)
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       32
	MOVWF       R2 
	MOVLW       133
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn38
;controlador_pid_pic18f.c,389 :: 		setpoint = SETPOINT_MIN;
	MOVLW       0
	MOVWF       _setpoint+0 
	MOVLW       0
	MOVWF       _setpoint+1 
	MOVLW       32
	MOVWF       _setpoint+2 
	MOVLW       131
	MOVWF       _setpoint+3 
;controlador_pid_pic18f.c,390 :: 		}
L_leituraBtn38:
;controlador_pid_pic18f.c,391 :: 		}
	GOTO        L_leituraBtn39
L_leituraBtn37:
;controlador_pid_pic18f.c,392 :: 		else if(menuConfig == 2)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn99
	MOVLW       2
	XORWF       _menuConfig+0, 0 
L__leituraBtn99:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn40
;controlador_pid_pic18f.c,394 :: 		kp+= 0.1;
	MOVF        _kp+0, 0 
	MOVWF       R0 
	MOVF        _kp+1, 0 
	MOVWF       R1 
	MOVF        _kp+2, 0 
	MOVWF       R2 
	MOVF        _kp+3, 0 
	MOVWF       R3 
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _kp+0 
	MOVF        R1, 0 
	MOVWF       _kp+1 
	MOVF        R2, 0 
	MOVWF       _kp+2 
	MOVF        R3, 0 
	MOVWF       _kp+3 
;controlador_pid_pic18f.c,395 :: 		if(kp > KP_MAX)
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       102
	MOVWF       R0 
	MOVLW       102
	MOVWF       R1 
	MOVLW       30
	MOVWF       R2 
	MOVLW       130
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn41
;controlador_pid_pic18f.c,397 :: 		kp = KP_MIN;
	CLRF        _kp+0 
	CLRF        _kp+1 
	CLRF        _kp+2 
	CLRF        _kp+3 
;controlador_pid_pic18f.c,398 :: 		}
L_leituraBtn41:
;controlador_pid_pic18f.c,399 :: 		}
	GOTO        L_leituraBtn42
L_leituraBtn40:
;controlador_pid_pic18f.c,401 :: 		else if(menuConfig == 3)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn100
	MOVLW       3
	XORWF       _menuConfig+0, 0 
L__leituraBtn100:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn43
;controlador_pid_pic18f.c,403 :: 		ki+= 0.1;
	MOVF        _ki+0, 0 
	MOVWF       R0 
	MOVF        _ki+1, 0 
	MOVWF       R1 
	MOVF        _ki+2, 0 
	MOVWF       R2 
	MOVF        _ki+3, 0 
	MOVWF       R3 
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _ki+0 
	MOVF        R1, 0 
	MOVWF       _ki+1 
	MOVF        R2, 0 
	MOVWF       _ki+2 
	MOVF        R3, 0 
	MOVWF       _ki+3 
;controlador_pid_pic18f.c,404 :: 		if(ki > KI_MAX)
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       102
	MOVWF       R0 
	MOVLW       102
	MOVWF       R1 
	MOVLW       30
	MOVWF       R2 
	MOVLW       130
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn44
;controlador_pid_pic18f.c,406 :: 		ki = KI_MIN;
	MOVLW       205
	MOVWF       _ki+0 
	MOVLW       204
	MOVWF       _ki+1 
	MOVLW       76
	MOVWF       _ki+2 
	MOVLW       123
	MOVWF       _ki+3 
;controlador_pid_pic18f.c,407 :: 		}
L_leituraBtn44:
;controlador_pid_pic18f.c,408 :: 		}
	GOTO        L_leituraBtn45
L_leituraBtn43:
;controlador_pid_pic18f.c,410 :: 		else if(menuConfig == 4)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn101
	MOVLW       4
	XORWF       _menuConfig+0, 0 
L__leituraBtn101:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn46
;controlador_pid_pic18f.c,412 :: 		kd += 0.1;
	MOVF        _kd+0, 0 
	MOVWF       R0 
	MOVF        _kd+1, 0 
	MOVWF       R1 
	MOVF        _kd+2, 0 
	MOVWF       R2 
	MOVF        _kd+3, 0 
	MOVWF       R3 
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _kd+0 
	MOVF        R1, 0 
	MOVWF       _kd+1 
	MOVF        R2, 0 
	MOVWF       _kd+2 
	MOVF        R3, 0 
	MOVWF       _kd+3 
;controlador_pid_pic18f.c,413 :: 		if(kd > KD_MAX)
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       102
	MOVWF       R0 
	MOVLW       102
	MOVWF       R1 
	MOVLW       30
	MOVWF       R2 
	MOVLW       130
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn47
;controlador_pid_pic18f.c,415 :: 		kd = KD_MIN;
	MOVLW       205
	MOVWF       _kd+0 
	MOVLW       204
	MOVWF       _kd+1 
	MOVLW       76
	MOVWF       _kd+2 
	MOVLW       123
	MOVWF       _kd+3 
;controlador_pid_pic18f.c,416 :: 		}
L_leituraBtn47:
;controlador_pid_pic18f.c,417 :: 		}
L_leituraBtn46:
L_leituraBtn45:
L_leituraBtn42:
L_leituraBtn39:
;controlador_pid_pic18f.c,418 :: 		contTempo2s = 0;
	CLRF        _contTempo2s+0 
	CLRF        _contTempo2s+1 
;controlador_pid_pic18f.c,419 :: 		btnIncPress = 0;
	BCF         _btnIncPress+0, BitPos(_btnIncPress+0) 
;controlador_pid_pic18f.c,420 :: 		}
L_leituraBtn36:
;controlador_pid_pic18f.c,422 :: 		if(!BTN_DEC)
	BTFSC       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_leituraBtn48
;controlador_pid_pic18f.c,424 :: 		if(debounceBtn)
	BTFSS       _debounceBtn+0, BitPos(_debounceBtn+0) 
	GOTO        L_leituraBtn49
;controlador_pid_pic18f.c,426 :: 		btnDecPress = 1;
	BSF         _btnDecPress+0, BitPos(_btnDecPress+0) 
;controlador_pid_pic18f.c,427 :: 		debounceBtn = 0;
	BCF         _debounceBtn+0, BitPos(_debounceBtn+0) 
;controlador_pid_pic18f.c,428 :: 		}
L_leituraBtn49:
;controlador_pid_pic18f.c,429 :: 		}
L_leituraBtn48:
;controlador_pid_pic18f.c,431 :: 		if(BTN_DEC && btnDecPress)
	BTFSS       RB6_bit+0, BitPos(RB6_bit+0) 
	GOTO        L_leituraBtn52
	BTFSS       _btnDecPress+0, BitPos(_btnDecPress+0) 
	GOTO        L_leituraBtn52
L__leituraBtn82:
;controlador_pid_pic18f.c,434 :: 		if(menuConfig == 1)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn102
	MOVLW       1
	XORWF       _menuConfig+0, 0 
L__leituraBtn102:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn53
;controlador_pid_pic18f.c,436 :: 		setpoint-= 0.5;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       126
	MOVWF       R7 
	MOVF        _setpoint+0, 0 
	MOVWF       R0 
	MOVF        _setpoint+1, 0 
	MOVWF       R1 
	MOVF        _setpoint+2, 0 
	MOVWF       R2 
	MOVF        _setpoint+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _setpoint+0 
	MOVF        R1, 0 
	MOVWF       _setpoint+1 
	MOVF        R2, 0 
	MOVWF       _setpoint+2 
	MOVF        R3, 0 
	MOVWF       _setpoint+3 
;controlador_pid_pic18f.c,437 :: 		if(setpoint < SETPOINT_MIN)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn54
;controlador_pid_pic18f.c,439 :: 		setpoint = SETPOINT_MAX;
	MOVLW       0
	MOVWF       _setpoint+0 
	MOVLW       0
	MOVWF       _setpoint+1 
	MOVLW       32
	MOVWF       _setpoint+2 
	MOVLW       133
	MOVWF       _setpoint+3 
;controlador_pid_pic18f.c,440 :: 		}
L_leituraBtn54:
;controlador_pid_pic18f.c,441 :: 		}
	GOTO        L_leituraBtn55
L_leituraBtn53:
;controlador_pid_pic18f.c,442 :: 		else if(menuConfig == 2)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn103
	MOVLW       2
	XORWF       _menuConfig+0, 0 
L__leituraBtn103:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn56
;controlador_pid_pic18f.c,444 :: 		kp-= 0.1;
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	MOVF        _kp+0, 0 
	MOVWF       R0 
	MOVF        _kp+1, 0 
	MOVWF       R1 
	MOVF        _kp+2, 0 
	MOVWF       R2 
	MOVF        _kp+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _kp+0 
	MOVF        R1, 0 
	MOVWF       _kp+1 
	MOVF        R2, 0 
	MOVWF       _kp+2 
	MOVF        R3, 0 
	MOVWF       _kp+3 
;controlador_pid_pic18f.c,445 :: 		if(kp < KP_MIN)
	CLRF        R4 
	CLRF        R5 
	CLRF        R6 
	CLRF        R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn57
;controlador_pid_pic18f.c,447 :: 		kp = KP_MAX;
	MOVLW       102
	MOVWF       _kp+0 
	MOVLW       102
	MOVWF       _kp+1 
	MOVLW       30
	MOVWF       _kp+2 
	MOVLW       130
	MOVWF       _kp+3 
;controlador_pid_pic18f.c,448 :: 		}
L_leituraBtn57:
;controlador_pid_pic18f.c,449 :: 		}
	GOTO        L_leituraBtn58
L_leituraBtn56:
;controlador_pid_pic18f.c,451 :: 		else if(menuConfig == 3)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn104
	MOVLW       3
	XORWF       _menuConfig+0, 0 
L__leituraBtn104:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn59
;controlador_pid_pic18f.c,453 :: 		ki-= 0.1;
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	MOVF        _ki+0, 0 
	MOVWF       R0 
	MOVF        _ki+1, 0 
	MOVWF       R1 
	MOVF        _ki+2, 0 
	MOVWF       R2 
	MOVF        _ki+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _ki+0 
	MOVF        R1, 0 
	MOVWF       _ki+1 
	MOVF        R2, 0 
	MOVWF       _ki+2 
	MOVF        R3, 0 
	MOVWF       _ki+3 
;controlador_pid_pic18f.c,454 :: 		if(ki < KI_MIN)
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn60
;controlador_pid_pic18f.c,456 :: 		ki = KI_MAX;
	MOVLW       102
	MOVWF       _ki+0 
	MOVLW       102
	MOVWF       _ki+1 
	MOVLW       30
	MOVWF       _ki+2 
	MOVLW       130
	MOVWF       _ki+3 
;controlador_pid_pic18f.c,457 :: 		}
L_leituraBtn60:
;controlador_pid_pic18f.c,458 :: 		}
	GOTO        L_leituraBtn61
L_leituraBtn59:
;controlador_pid_pic18f.c,460 :: 		else if(menuConfig == 4)
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__leituraBtn105
	MOVLW       4
	XORWF       _menuConfig+0, 0 
L__leituraBtn105:
	BTFSS       STATUS+0, 2 
	GOTO        L_leituraBtn62
;controlador_pid_pic18f.c,462 :: 		kd -= 0.1;
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	MOVF        _kd+0, 0 
	MOVWF       R0 
	MOVF        _kd+1, 0 
	MOVWF       R1 
	MOVF        _kd+2, 0 
	MOVWF       R2 
	MOVF        _kd+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _kd+0 
	MOVF        R1, 0 
	MOVWF       _kd+1 
	MOVF        R2, 0 
	MOVWF       _kd+2 
	MOVF        R3, 0 
	MOVWF       _kd+3 
;controlador_pid_pic18f.c,463 :: 		if(kd < KD_MIN)
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_leituraBtn63
;controlador_pid_pic18f.c,465 :: 		kd = KD_MAX;
	MOVLW       102
	MOVWF       _kd+0 
	MOVLW       102
	MOVWF       _kd+1 
	MOVLW       30
	MOVWF       _kd+2 
	MOVLW       130
	MOVWF       _kd+3 
;controlador_pid_pic18f.c,466 :: 		}
L_leituraBtn63:
;controlador_pid_pic18f.c,467 :: 		}
L_leituraBtn62:
L_leituraBtn61:
L_leituraBtn58:
L_leituraBtn55:
;controlador_pid_pic18f.c,468 :: 		contTempo2s = 0;
	CLRF        _contTempo2s+0 
	CLRF        _contTempo2s+1 
;controlador_pid_pic18f.c,469 :: 		btnDecPress = 0;
	BCF         _btnDecPress+0, BitPos(_btnDecPress+0) 
;controlador_pid_pic18f.c,470 :: 		}
L_leituraBtn52:
;controlador_pid_pic18f.c,471 :: 		}
L_leituraBtn31:
;controlador_pid_pic18f.c,475 :: 		if(modoConfig && tempo2s)
	BTFSS       _modoConfig+0, BitPos(_modoConfig+0) 
	GOTO        L_leituraBtn66
	BTFSS       _tempo2s+0, BitPos(_tempo2s+0) 
	GOTO        L_leituraBtn66
L__leituraBtn81:
;controlador_pid_pic18f.c,477 :: 		tempo2s = 0;
	BCF         _tempo2s+0, BitPos(_tempo2s+0) 
;controlador_pid_pic18f.c,478 :: 		trocaTela = 1;
	BSF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,479 :: 		menuConfig = 5;
	MOVLW       5
	MOVWF       _menuConfig+0 
	MOVLW       0
	MOVWF       _menuConfig+1 
;controlador_pid_pic18f.c,480 :: 		}
L_leituraBtn66:
;controlador_pid_pic18f.c,481 :: 		}
L_end_leituraBtn:
	RETURN      0
; end of _leituraBtn

_limpaDisplay:

;controlador_pid_pic18f.c,483 :: 		void limpaDisplay(short estado)
;controlador_pid_pic18f.c,485 :: 		if(estado)
	MOVF        FARG_limpaDisplay_estado+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_limpaDisplay67
;controlador_pid_pic18f.c,487 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;controlador_pid_pic18f.c,488 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOVLW       2
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;controlador_pid_pic18f.c,489 :: 		estado = 0;
	CLRF        FARG_limpaDisplay_estado+0 
;controlador_pid_pic18f.c,490 :: 		}
L_limpaDisplay67:
;controlador_pid_pic18f.c,491 :: 		}
L_end_limpaDisplay:
	RETURN      0
; end of _limpaDisplay

_ajusteConfig:

;controlador_pid_pic18f.c,493 :: 		void ajusteConfig()
;controlador_pid_pic18f.c,495 :: 		switch(menuConfig)
	GOTO        L_ajusteConfig68
;controlador_pid_pic18f.c,497 :: 		case 1:
L_ajusteConfig70:
;controlador_pid_pic18f.c,498 :: 		configSetpoint();
	CALL        _configSetpoint+0, 0
;controlador_pid_pic18f.c,499 :: 		break;
	GOTO        L_ajusteConfig69
;controlador_pid_pic18f.c,500 :: 		case 2:
L_ajusteConfig71:
;controlador_pid_pic18f.c,501 :: 		configKP();
	CALL        _configKP+0, 0
;controlador_pid_pic18f.c,502 :: 		break;
	GOTO        L_ajusteConfig69
;controlador_pid_pic18f.c,503 :: 		case 3:
L_ajusteConfig72:
;controlador_pid_pic18f.c,504 :: 		configKI();
	CALL        _configKI+0, 0
;controlador_pid_pic18f.c,505 :: 		break;
	GOTO        L_ajusteConfig69
;controlador_pid_pic18f.c,506 :: 		case 4:
L_ajusteConfig73:
;controlador_pid_pic18f.c,507 :: 		configKD();
	CALL        _configKD+0, 0
;controlador_pid_pic18f.c,508 :: 		break;
	GOTO        L_ajusteConfig69
;controlador_pid_pic18f.c,509 :: 		case 5:
L_ajusteConfig74:
;controlador_pid_pic18f.c,510 :: 		saiModoConfig();
	CALL        _saiModoConfig+0, 0
;controlador_pid_pic18f.c,511 :: 		break;
	GOTO        L_ajusteConfig69
;controlador_pid_pic18f.c,512 :: 		}
L_ajusteConfig68:
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ajusteConfig108
	MOVLW       1
	XORWF       _menuConfig+0, 0 
L__ajusteConfig108:
	BTFSC       STATUS+0, 2 
	GOTO        L_ajusteConfig70
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ajusteConfig109
	MOVLW       2
	XORWF       _menuConfig+0, 0 
L__ajusteConfig109:
	BTFSC       STATUS+0, 2 
	GOTO        L_ajusteConfig71
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ajusteConfig110
	MOVLW       3
	XORWF       _menuConfig+0, 0 
L__ajusteConfig110:
	BTFSC       STATUS+0, 2 
	GOTO        L_ajusteConfig72
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ajusteConfig111
	MOVLW       4
	XORWF       _menuConfig+0, 0 
L__ajusteConfig111:
	BTFSC       STATUS+0, 2 
	GOTO        L_ajusteConfig73
	MOVLW       0
	XORWF       _menuConfig+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ajusteConfig112
	MOVLW       5
	XORWF       _menuConfig+0, 0 
L__ajusteConfig112:
	BTFSC       STATUS+0, 2 
	GOTO        L_ajusteConfig74
L_ajusteConfig69:
;controlador_pid_pic18f.c,513 :: 		}
L_end_ajusteConfig:
	RETURN      0
; end of _ajusteConfig

_configSetpoint:

;controlador_pid_pic18f.c,515 :: 		void configSetpoint()
;controlador_pid_pic18f.c,517 :: 		if(trocaTela)
	BTFSS       _trocaTela+0, BitPos(_trocaTela+0) 
	GOTO        L_configSetpoint75
;controlador_pid_pic18f.c,519 :: 		limpaTela = 1;
	BSF         _limpaTela+0, BitPos(_limpaTela+0) 
;controlador_pid_pic18f.c,520 :: 		trocaTela = 0;
	BCF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,521 :: 		limpaDisplay(limpaTela);
	MOVLW       0
	BTFSC       _limpaTela+0, BitPos(_limpaTela+0) 
	MOVLW       1
	MOVWF       FARG_limpaDisplay_estado+0 
	CALL        _limpaDisplay+0, 0
;controlador_pid_pic18f.c,522 :: 		}
L_configSetpoint75:
;controlador_pid_pic18f.c,524 :: 		FloatToStr(setpoint, txt);
	MOVF        _setpoint+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _setpoint+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _setpoint+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _setpoint+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;controlador_pid_pic18f.c,526 :: 		LCD_chr(1,4,'A');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       65
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,527 :: 		LCD_chr_cp ('J');
	MOVLW       74
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,528 :: 		LCD_chr_cp ('U');
	MOVLW       85
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,529 :: 		LCD_chr_cp ('S');
	MOVLW       83
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,530 :: 		LCD_chr_cp ('T');
	MOVLW       84
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,531 :: 		LCD_chr_cp ('E');
	MOVLW       69
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,532 :: 		LCD_chr_cp (' ');
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,533 :: 		LCD_chr_cp ('S');
	MOVLW       83
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,534 :: 		LCD_chr_cp ('P');
	MOVLW       80
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,535 :: 		Lcd_Chr(2, 7, txt[0]);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _txt+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,536 :: 		Lcd_Chr_Cp (txt[1]);
	MOVF        _txt+1, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,537 :: 		Lcd_Chr_Cp (txt[2]);
	MOVF        _txt+2, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,538 :: 		Lcd_Chr_Cp (txt[3]);
	MOVF        _txt+3, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,539 :: 		}
L_end_configSetpoint:
	RETURN      0
; end of _configSetpoint

_configKP:

;controlador_pid_pic18f.c,541 :: 		void configKP()
;controlador_pid_pic18f.c,543 :: 		if(trocaTela)
	BTFSS       _trocaTela+0, BitPos(_trocaTela+0) 
	GOTO        L_configKP76
;controlador_pid_pic18f.c,545 :: 		limpaTela = 1;
	BSF         _limpaTela+0, BitPos(_limpaTela+0) 
;controlador_pid_pic18f.c,546 :: 		trocaTela = 0;
	BCF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,547 :: 		limpaDisplay(limpaTela);
	MOVLW       0
	BTFSC       _limpaTela+0, BitPos(_limpaTela+0) 
	MOVLW       1
	MOVWF       FARG_limpaDisplay_estado+0 
	CALL        _limpaDisplay+0, 0
;controlador_pid_pic18f.c,548 :: 		}
L_configKP76:
;controlador_pid_pic18f.c,550 :: 		FloatToStr(kp, txt);
	MOVF        _kp+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _kp+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _kp+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _kp+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;controlador_pid_pic18f.c,552 :: 		LCD_chr(1,4,'A');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       65
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,553 :: 		LCD_chr_cp ('J');
	MOVLW       74
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,554 :: 		LCD_chr_cp ('U');
	MOVLW       85
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,555 :: 		LCD_chr_cp ('S');
	MOVLW       83
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,556 :: 		LCD_chr_cp ('T');
	MOVLW       84
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,557 :: 		LCD_chr_cp ('E');
	MOVLW       69
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,558 :: 		LCD_chr_cp (' ');
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,559 :: 		LCD_chr_cp ('K');
	MOVLW       75
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,560 :: 		LCD_chr_cp ('P');
	MOVLW       80
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,561 :: 		Lcd_Chr(2, 7, txt[0]);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _txt+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,562 :: 		Lcd_Chr_Cp (txt[1]);
	MOVF        _txt+1, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,563 :: 		Lcd_Chr_Cp (txt[2]);
	MOVF        _txt+2, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,564 :: 		}
L_end_configKP:
	RETURN      0
; end of _configKP

_configKI:

;controlador_pid_pic18f.c,566 :: 		void configKI()
;controlador_pid_pic18f.c,568 :: 		if(trocaTela)
	BTFSS       _trocaTela+0, BitPos(_trocaTela+0) 
	GOTO        L_configKI77
;controlador_pid_pic18f.c,570 :: 		limpaTela = 1;
	BSF         _limpaTela+0, BitPos(_limpaTela+0) 
;controlador_pid_pic18f.c,571 :: 		trocaTela = 0;
	BCF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,572 :: 		limpaDisplay(limpaTela);
	MOVLW       0
	BTFSC       _limpaTela+0, BitPos(_limpaTela+0) 
	MOVLW       1
	MOVWF       FARG_limpaDisplay_estado+0 
	CALL        _limpaDisplay+0, 0
;controlador_pid_pic18f.c,573 :: 		}
L_configKI77:
;controlador_pid_pic18f.c,575 :: 		FloatToStr(ki, txt);
	MOVF        _ki+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _ki+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _ki+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _ki+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;controlador_pid_pic18f.c,577 :: 		LCD_chr(1,4,'A');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       65
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,578 :: 		LCD_chr_cp ('J');
	MOVLW       74
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,579 :: 		LCD_chr_cp ('U');
	MOVLW       85
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,580 :: 		LCD_chr_cp ('S');
	MOVLW       83
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,581 :: 		LCD_chr_cp ('T');
	MOVLW       84
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,582 :: 		LCD_chr_cp ('E');
	MOVLW       69
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,583 :: 		LCD_chr_cp (' ');
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,584 :: 		LCD_chr_cp ('K');
	MOVLW       75
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,585 :: 		LCD_chr_cp ('I');
	MOVLW       73
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,586 :: 		Lcd_Chr(2, 7, txt[0]);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _txt+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,587 :: 		Lcd_Chr_Cp (txt[1]);
	MOVF        _txt+1, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,588 :: 		Lcd_Chr_Cp (txt[2]);
	MOVF        _txt+2, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,589 :: 		}
L_end_configKI:
	RETURN      0
; end of _configKI

_configKD:

;controlador_pid_pic18f.c,591 :: 		void configKD()
;controlador_pid_pic18f.c,593 :: 		if(trocaTela)
	BTFSS       _trocaTela+0, BitPos(_trocaTela+0) 
	GOTO        L_configKD78
;controlador_pid_pic18f.c,595 :: 		limpaTela = 1;
	BSF         _limpaTela+0, BitPos(_limpaTela+0) 
;controlador_pid_pic18f.c,596 :: 		trocaTela = 0;
	BCF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,597 :: 		limpaDisplay(limpaTela);
	MOVLW       0
	BTFSC       _limpaTela+0, BitPos(_limpaTela+0) 
	MOVLW       1
	MOVWF       FARG_limpaDisplay_estado+0 
	CALL        _limpaDisplay+0, 0
;controlador_pid_pic18f.c,598 :: 		}
L_configKD78:
;controlador_pid_pic18f.c,600 :: 		FloatToStr(kd, txt);
	MOVF        _kd+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        _kd+1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        _kd+2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        _kd+3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;controlador_pid_pic18f.c,602 :: 		LCD_chr(1,4,'A');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       65
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,603 :: 		LCD_chr_cp ('J');
	MOVLW       74
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,604 :: 		LCD_chr_cp ('U');
	MOVLW       85
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,605 :: 		LCD_chr_cp ('S');
	MOVLW       83
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,606 :: 		LCD_chr_cp ('T');
	MOVLW       84
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,607 :: 		LCD_chr_cp ('E');
	MOVLW       69
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,608 :: 		LCD_chr_cp (' ');
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,609 :: 		LCD_chr_cp ('K');
	MOVLW       75
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,610 :: 		LCD_chr_cp ('D');
	MOVLW       68
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,611 :: 		Lcd_Chr(2, 7, txt[0]);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _txt+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;controlador_pid_pic18f.c,612 :: 		Lcd_Chr_Cp (txt[1]);
	MOVF        _txt+1, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,613 :: 		Lcd_Chr_Cp (txt[2]);
	MOVF        _txt+2, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;controlador_pid_pic18f.c,614 :: 		}
L_end_configKD:
	RETURN      0
; end of _configKD

_saiModoConfig:

;controlador_pid_pic18f.c,616 :: 		void saiModoConfig()
;controlador_pid_pic18f.c,618 :: 		if(trocaTela)
	BTFSS       _trocaTela+0, BitPos(_trocaTela+0) 
	GOTO        L_saiModoConfig79
;controlador_pid_pic18f.c,620 :: 		limpaTela = 1;
	BSF         _limpaTela+0, BitPos(_limpaTela+0) 
;controlador_pid_pic18f.c,621 :: 		trocaTela = 0;
	BCF         _trocaTela+0, BitPos(_trocaTela+0) 
;controlador_pid_pic18f.c,622 :: 		limpaDisplay(limpaTela);
	MOVLW       0
	BTFSC       _limpaTela+0, BitPos(_limpaTela+0) 
	MOVLW       1
	MOVWF       FARG_limpaDisplay_estado+0 
	CALL        _limpaDisplay+0, 0
;controlador_pid_pic18f.c,623 :: 		}
L_saiModoConfig79:
;controlador_pid_pic18f.c,625 :: 		menuConfig = 1;
	MOVLW       1
	MOVWF       _menuConfig+0 
	MOVLW       0
	MOVWF       _menuConfig+1 
;controlador_pid_pic18f.c,626 :: 		temperaturaAtual = 0; //Zero temperatura Atual para atualizar leitor de temp.
	CLRF        _temperaturaAtual+0 
	CLRF        _temperaturaAtual+1 
	CLRF        _temperaturaAtual+2 
	CLRF        _temperaturaAtual+3 
;controlador_pid_pic18f.c,627 :: 		telaInicialSistema();
	CALL        _telaInicialSistema+0, 0
;controlador_pid_pic18f.c,628 :: 		modoConfig = 0;
	BCF         _modoConfig+0, BitPos(_modoConfig+0) 
;controlador_pid_pic18f.c,630 :: 		}
L_end_saiModoConfig:
	RETURN      0
; end of _saiModoConfig
