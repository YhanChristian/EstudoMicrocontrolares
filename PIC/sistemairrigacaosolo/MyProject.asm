
_interrupt:

;MyProject.c,50 :: 		void interrupt() {
;MyProject.c,51 :: 		if(TMR0IF_bit) {
	BTFSS       TMR0IF_bit+0, 2 
	GOTO        L_interrupt0
;MyProject.c,52 :: 		TMR0IF_bit = 0x00;
	BCF         TMR0IF_bit+0, 2 
;MyProject.c,53 :: 		TMR0L = 0xFF;
	MOVLW       255
	MOVWF       TMR0L+0 
;MyProject.c,54 :: 		TMR0H = 0x7F;
	MOVLW       127
	MOVWF       TMR0H+0 
;MyProject.c,55 :: 		timerCounterAux++;
	INFSNZ      _timerCounterAux+0, 1 
	INCF        _timerCounterAux+1, 1 
;MyProject.c,57 :: 		if(timerCounterAux == 180) {
	MOVLW       0
	XORWF       _timerCounterAux+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt15
	MOVLW       180
	XORWF       _timerCounterAux+0, 0 
L__interrupt15:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;MyProject.c,58 :: 		timerCounterAux = 0;
	CLRF        _timerCounterAux+0 
	CLRF        _timerCounterAux+1 
;MyProject.c,59 :: 		switchInfo = ~switchInfo;
	BTG         _flagA+0, 0 
;MyProject.c,60 :: 		}
L_interrupt1:
;MyProject.c,61 :: 		}
L_interrupt0:
;MyProject.c,62 :: 		}
L_end_interrupt:
L__interrupt14:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,64 :: 		void main() {
;MyProject.c,65 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;MyProject.c,66 :: 		initDisplay();
	CALL        _initDisplay+0, 0
;MyProject.c,67 :: 		initDht11();
	CALL        _initDht11+0, 0
;MyProject.c,69 :: 		while(1) {
L_main2:
;MyProject.c,70 :: 		readTemperature();
	CALL        _readTemperature+0, 0
;MyProject.c,71 :: 		delay_ms(150);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	DECFSZ      R11, 1, 1
	BRA         L_main4
	NOP
	NOP
;MyProject.c,72 :: 		readHumidity();
	CALL        _readHumidity+0, 0
;MyProject.c,73 :: 		delay_ms(150);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       12
	MOVWF       R12, 0
	MOVLW       51
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	DECFSZ      R11, 1, 1
	BRA         L_main5
	NOP
	NOP
;MyProject.c,74 :: 		}
	GOTO        L_main2
;MyProject.c,75 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;MyProject.c,77 :: 		void configureMcu() {
;MyProject.c,78 :: 		CMCON = 0x07; //Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;MyProject.c,79 :: 		ADCON1 = 0x0E; //Habilita AN0, VDD e VSS como referencia
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,80 :: 		ADCON0 = 0x00; // Seleciona AN0
	CLRF        ADCON0+0 
;MyProject.c,81 :: 		ADC_Init(); // Inicia ADC
	CALL        _ADC_Init+0, 0
;MyProject.c,82 :: 		INTCON = 0xE0; // Habilita interrupçoes externa, habilita TMR0
	MOVLW       224
	MOVWF       INTCON+0 
;MyProject.c,83 :: 		OSCCON = 0x72; //Configura OSC interno 8MHz
	MOVLW       114
	MOVWF       OSCCON+0 
;MyProject.c,84 :: 		TRISC2_bit = 0x00; //Configura C2 como saida
	BCF         TRISC2_bit+0, 2 
;MyProject.c,85 :: 		TRISD0_bit = 0x00; // Configura D0 como saida
	BCF         TRISD0_bit+0, 0 
;MyProject.c,86 :: 		LATD0_bit = 0x00;
	BCF         LATD0_bit+0, 0 
;MyProject.c,87 :: 		TMR1IE_bit = 0x01; // Habilita TMR1
	BSF         TMR1IE_bit+0, 0 
;MyProject.c,88 :: 		T0CON = 0x80; // TMR0, 16bits, inc ciclo maquina, prescaler 1:2 (pg. 127)
	MOVLW       128
	MOVWF       T0CON+0 
;MyProject.c,89 :: 		TMR0L = 0xFF; //byte menos significativo
	MOVLW       255
	MOVWF       TMR0L+0 
;MyProject.c,90 :: 		TMR0H = 0x7F; //byte mais significativo
	MOVLW       127
	MOVWF       TMR0H+0 
;MyProject.c,91 :: 		PWM1_Init(5000); //Inicia pwm com f = 5kHz (Funcao mikroC)
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       199
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;MyProject.c,92 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_initDisplay:

;MyProject.c,95 :: 		void initDisplay() {
;MyProject.c,96 :: 		Lcd_INIT();
	CALL        _Lcd_Init+0, 0
;MyProject.c,97 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,98 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,99 :: 		}
L_end_initDisplay:
	RETURN      0
; end of _initDisplay

_groundHumidity:

;MyProject.c,101 :: 		int groundHumidity() {
;MyProject.c,103 :: 		value = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;MyProject.c,104 :: 		value = value * 0.09765625; //Valor retornado em % (100/1024)
	CALL        _Int2Double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _Double2Int+0, 0
;MyProject.c,105 :: 		value = 100 - value; // Explicado relacao solo molhado/seco por isso subtrai 100.
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       R0 
	MOVF        R1, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
;MyProject.c,106 :: 		return value;
;MyProject.c,107 :: 		}
L_end_groundHumidity:
	RETURN      0
; end of _groundHumidity

_readTemperature:

;MyProject.c,109 :: 		void readTemperature() {
;MyProject.c,111 :: 		temp = dht11(2);
	MOVLW       2
	MOVWF       FARG_dht11_type+0 
	CALL        _dht11+0, 0
	MOVF        R0, 0 
	MOVWF       readTemperature_temp_L0+0 
	MOVF        R1, 0 
	MOVWF       readTemperature_temp_L0+1 
;MyProject.c,114 :: 		temp = temp / 100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       readTemperature_temp_L0+0 
	MOVF        R1, 0 
	MOVWF       readTemperature_temp_L0+1 
;MyProject.c,115 :: 		digit01 = temp / 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _digit01+0 
;MyProject.c,116 :: 		digit02 = temp % 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        readTemperature_temp_L0+0, 0 
	MOVWF       R0 
	MOVF        readTemperature_temp_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digit02+0 
;MyProject.c,119 :: 		lcd_out(1, 1, "Temperatura:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,120 :: 		lcd_chr(1, 14, digit01 + 48);
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       _digit01+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,121 :: 		lcd_chr_cp(digit02 + 48);
	MOVLW       48
	ADDWF       _digit02+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,122 :: 		}
L_end_readTemperature:
	RETURN      0
; end of _readTemperature

_readHumidity:

;MyProject.c,124 :: 		void readHumidity() {
;MyProject.c,126 :: 		hum01 = dht11(1);
	MOVLW       1
	MOVWF       FARG_dht11_type+0 
	CALL        _dht11+0, 0
	MOVF        R0, 0 
	MOVWF       readHumidity_hum01_L0+0 
	MOVF        R1, 0 
	MOVWF       readHumidity_hum01_L0+1 
;MyProject.c,127 :: 		hum02 = groundHumidity();
	CALL        _groundHumidity+0, 0
	MOVF        R0, 0 
	MOVWF       readHumidity_hum02_L0+0 
	MOVF        R1, 0 
	MOVWF       readHumidity_hum02_L0+1 
;MyProject.c,142 :: 		if(hum02 <= 40) turnOnWaterPump(1);
	MOVLW       128
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readHumidity22
	MOVF        R0, 0 
	SUBLW       40
L__readHumidity22:
	BTFSS       STATUS+0, 0 
	GOTO        L_readHumidity6
	MOVLW       1
	MOVWF       FARG_turnOnWaterPump_status+0 
	CALL        _turnOnWaterPump+0, 0
	GOTO        L_readHumidity7
L_readHumidity6:
;MyProject.c,144 :: 		if(hum02 >= 65) turnOnWaterPump(0);
	MOVLW       128
	XORWF       readHumidity_hum02_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readHumidity23
	MOVLW       65
	SUBWF       readHumidity_hum02_L0+0, 0 
L__readHumidity23:
	BTFSS       STATUS+0, 0 
	GOTO        L_readHumidity8
	CLRF        FARG_turnOnWaterPump_status+0 
	CALL        _turnOnWaterPump+0, 0
L_readHumidity8:
;MyProject.c,145 :: 		}
L_readHumidity7:
;MyProject.c,150 :: 		if(switchInfo) {
	BTFSS       _flagA+0, 0 
	GOTO        L_readHumidity9
;MyProject.c,151 :: 		hum01 = hum01 / 100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        readHumidity_hum01_L0+0, 0 
	MOVWF       R0 
	MOVF        readHumidity_hum01_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       readHumidity_hum01_L0+0 
	MOVF        R1, 0 
	MOVWF       readHumidity_hum01_L0+1 
;MyProject.c,152 :: 		digit01 = hum01 / 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _digit01+0 
;MyProject.c,153 :: 		digit02 = hum01 % 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        readHumidity_hum01_L0+0, 0 
	MOVWF       R0 
	MOVF        readHumidity_hum01_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digit02+0 
;MyProject.c,154 :: 		lcd_out(2, 1, "Umidade Ar:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,155 :: 		lcd_chr(2, 14, digit01 + 48);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       _digit01+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,156 :: 		lcd_chr_cp(digit02 + 48);
	MOVLW       48
	ADDWF       _digit02+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,157 :: 		}
	GOTO        L_readHumidity10
L_readHumidity9:
;MyProject.c,160 :: 		digit01 = hum02 / 100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        readHumidity_hum02_L0+0, 0 
	MOVWF       R0 
	MOVF        readHumidity_hum02_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _digit01+0 
;MyProject.c,161 :: 		digit02 = hum02 / 10 - digit01 * 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        readHumidity_hum02_L0+0, 0 
	MOVWF       R0 
	MOVF        readHumidity_hum02_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVLW       10
	MULWF       _digit01+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       R0, 0 
	MOVWF       _digit02+0 
;MyProject.c,162 :: 		digit03 = hum02 % 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        readHumidity_hum02_L0+0, 0 
	MOVWF       R0 
	MOVF        readHumidity_hum02_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _digit03+0 
;MyProject.c,163 :: 		lcd_out(2, 1, "Umid. Solo:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,164 :: 		lcd_chr(2,13, digit01 + 48);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       _digit01+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,165 :: 		lcd_chr_cp(digit02 + 48);
	MOVLW       48
	ADDWF       _digit02+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,166 :: 		lcd_chr_cp(digit03 + 48);
	MOVLW       48
	ADDWF       _digit03+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,167 :: 		}
L_readHumidity10:
;MyProject.c,168 :: 		}
L_end_readHumidity:
	RETURN      0
; end of _readHumidity

_turnOnWaterPump:

;MyProject.c,170 :: 		void turnOnWaterPump(unsigned short status) {
;MyProject.c,171 :: 		if(status == 1) {
	MOVF        FARG_turnOnWaterPump_status+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_turnOnWaterPump11
;MyProject.c,172 :: 		PWM1_Start();      // Liga bomba c/ controle PWM
	CALL        _PWM1_Start+0, 0
;MyProject.c,173 :: 		PWM1_Set_Duty(80);
	MOVLW       80
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;MyProject.c,174 :: 		}
	GOTO        L_turnOnWaterPump12
L_turnOnWaterPump11:
;MyProject.c,175 :: 		else PWM1_Stop();
	CALL        _PWM1_Stop+0, 0
L_turnOnWaterPump12:
;MyProject.c,176 :: 		}
L_end_turnOnWaterPump:
	RETURN      0
; end of _turnOnWaterPump
