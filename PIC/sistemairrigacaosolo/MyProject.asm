
_interrupt:

;MyProject.c,53 :: 		void interrupt() {
;MyProject.c,54 :: 		if(TMR0IF_bit) {
	BTFSS       TMR0IF_bit+0, 2 
	GOTO        L_interrupt0
;MyProject.c,55 :: 		TMR0IF_bit = 0x00;
	BCF         TMR0IF_bit+0, 2 
;MyProject.c,56 :: 		TMR0L = 0xFF;
	MOVLW       255
	MOVWF       TMR0L+0 
;MyProject.c,57 :: 		TMR0H = 0x7F;
	MOVLW       127
	MOVWF       TMR0H+0 
;MyProject.c,58 :: 		timerCounterAux++;
	INFSNZ      _timerCounterAux+0, 1 
	INCF        _timerCounterAux+1, 1 
;MyProject.c,60 :: 		if(timerCounterAux == 180) {
	MOVLW       0
	XORWF       _timerCounterAux+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt22
	MOVLW       180
	XORWF       _timerCounterAux+0, 0 
L__interrupt22:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;MyProject.c,61 :: 		timerCounterAux = 0;
	CLRF        _timerCounterAux+0 
	CLRF        _timerCounterAux+1 
;MyProject.c,62 :: 		switchInfo = ~switchInfo;
	BTG         _flagA+0, 0 
;MyProject.c,63 :: 		}
L_interrupt1:
;MyProject.c,64 :: 		}
L_interrupt0:
;MyProject.c,65 :: 		}
L_end_interrupt:
L__interrupt21:
	RETFIE      1
; end of _interrupt

_main:

;MyProject.c,67 :: 		void main() {
;MyProject.c,68 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;MyProject.c,69 :: 		initDisplay();
	CALL        _initDisplay+0, 0
;MyProject.c,70 :: 		initDht11();
	CALL        _initDht11+0, 0
;MyProject.c,72 :: 		while(1) {
L_main2:
;MyProject.c,73 :: 		readTemperature();
	CALL        _readTemperature+0, 0
;MyProject.c,74 :: 		delay_ms(150);
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
;MyProject.c,75 :: 		readHumidity();
	CALL        _readHumidity+0, 0
;MyProject.c,76 :: 		delay_ms(150);
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
;MyProject.c,77 :: 		}
	GOTO        L_main2
;MyProject.c,78 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;MyProject.c,80 :: 		void configureMcu() {
;MyProject.c,81 :: 		CMCON = 0x07; //Desabilita comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;MyProject.c,82 :: 		ADCON1 = 0x0E; //Habilita AN0, VDD e VSS como referencia
	MOVLW       14
	MOVWF       ADCON1+0 
;MyProject.c,83 :: 		ADCON0 = 0x00; // Seleciona AN0
	CLRF        ADCON0+0 
;MyProject.c,84 :: 		ADC_Init(); // Inicia ADC
	CALL        _ADC_Init+0, 0
;MyProject.c,85 :: 		INTCON = 0xE0; // Habilita interrupçoes externa, habilita TMR0
	MOVLW       224
	MOVWF       INTCON+0 
;MyProject.c,86 :: 		OSCCON = 0x72; //Configura OSC interno 8MHz
	MOVLW       114
	MOVWF       OSCCON+0 
;MyProject.c,88 :: 		TRISD = 0x02; // Configura pino D1 como entrada e demais como saidas
	MOVLW       2
	MOVWF       TRISD+0 
;MyProject.c,89 :: 		LATD0_bit = 0x00;  // Inicializa em nivel zero RD0
	BCF         LATD0_bit+0, 0 
;MyProject.c,90 :: 		LATD1_bit = 0x00; // Inicializa em nivel zero RD1
	BCF         LATD1_bit+0, 1 
;MyProject.c,91 :: 		TMR1IE_bit = 0x01; // Habilita TMR1
	BSF         TMR1IE_bit+0, 0 
;MyProject.c,92 :: 		T0CON = 0x80; // TMR0, 16bits, inc ciclo maquina, prescaler 1:2 (pg. 127)
	MOVLW       128
	MOVWF       T0CON+0 
;MyProject.c,93 :: 		TMR0L = 0xFF; //byte menos significativo
	MOVLW       255
	MOVWF       TMR0L+0 
;MyProject.c,94 :: 		TMR0H = 0x7F; //byte mais significativo
	MOVLW       127
	MOVWF       TMR0H+0 
;MyProject.c,95 :: 		PWM1_Init(5000); //Inicia pwm com f = 5kHz (Funcao mikroC) RC2
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       199
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;MyProject.c,96 :: 		PWM2_Init(5000); // Iniciar pwm com f = 5kHz (Funcao mikroC) RC1
	BSF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       199
	MOVWF       PR2+0, 0
	CALL        _PWM2_Init+0, 0
;MyProject.c,97 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_initDisplay:

;MyProject.c,100 :: 		void initDisplay() {
;MyProject.c,101 :: 		Lcd_INIT();
	CALL        _Lcd_Init+0, 0
;MyProject.c,102 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,103 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;MyProject.c,104 :: 		}
L_end_initDisplay:
	RETURN      0
; end of _initDisplay

_groundHumidity:

;MyProject.c,106 :: 		int groundHumidity() {
;MyProject.c,108 :: 		value = ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
;MyProject.c,109 :: 		value = value * 0.09765625; //Valor retornado em % (100/1024)
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
;MyProject.c,110 :: 		value = 100 - value; // Explicado relacao solo molhado/seco por isso subtrai 100.
	MOVF        R0, 0 
	SUBLW       100
	MOVWF       R0 
	MOVF        R1, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
;MyProject.c,111 :: 		return value;
;MyProject.c,112 :: 		}
L_end_groundHumidity:
	RETURN      0
; end of _groundHumidity

_readTemperature:

;MyProject.c,114 :: 		void readTemperature() {
;MyProject.c,116 :: 		temp = dht11(2);
	MOVLW       2
	MOVWF       FARG_dht11_type+0 
	CALL        _dht11+0, 0
	MOVF        R0, 0 
	MOVWF       readTemperature_temp_L0+0 
	MOVF        R1, 0 
	MOVWF       readTemperature_temp_L0+1 
;MyProject.c,119 :: 		exhaustFan(temp, 25.4);
	MOVF        R0, 0 
	MOVWF       FARG_exhaustFan_temperature+0 
	MOVF        R1, 0 
	MOVWF       FARG_exhaustFan_temperature+1 
	MOVLW       51
	MOVWF       FARG_exhaustFan_threshold+0 
	MOVLW       51
	MOVWF       FARG_exhaustFan_threshold+1 
	MOVLW       75
	MOVWF       FARG_exhaustFan_threshold+2 
	MOVLW       131
	MOVWF       FARG_exhaustFan_threshold+3 
	CALL        _exhaustFan+0, 0
;MyProject.c,122 :: 		temp = temp / 100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        readTemperature_temp_L0+0, 0 
	MOVWF       R0 
	MOVF        readTemperature_temp_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       readTemperature_temp_L0+0 
	MOVF        R1, 0 
	MOVWF       readTemperature_temp_L0+1 
;MyProject.c,123 :: 		digit01 = temp / 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _digit01+0 
;MyProject.c,124 :: 		digit02 = temp % 10;
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
;MyProject.c,127 :: 		lcd_out(1, 1, "Temperatura:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,128 :: 		lcd_chr(1, 14, digit01 + 48);
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       _digit01+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,129 :: 		lcd_chr_cp(digit02 + 48);
	MOVLW       48
	ADDWF       _digit02+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,130 :: 		}
L_end_readTemperature:
	RETURN      0
; end of _readTemperature

_readHumidity:

;MyProject.c,132 :: 		void readHumidity() {
;MyProject.c,134 :: 		hum01 = dht11(1);
	MOVLW       1
	MOVWF       FARG_dht11_type+0 
	CALL        _dht11+0, 0
	MOVF        R0, 0 
	MOVWF       readHumidity_hum01_L0+0 
	MOVF        R1, 0 
	MOVWF       readHumidity_hum01_L0+1 
;MyProject.c,135 :: 		hum02 = groundHumidity();
	CALL        _groundHumidity+0, 0
	MOVF        R0, 0 
	MOVWF       readHumidity_hum02_L0+0 
	MOVF        R1, 0 
	MOVWF       readHumidity_hum02_L0+1 
;MyProject.c,152 :: 		if(waterLevel) {
	BTFSS       LATD1_bit+0, 1 
	GOTO        L_readHumidity6
;MyProject.c,153 :: 		if(hum02 <= 40) turnOnWaterPump(1);
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       readHumidity_hum02_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readHumidity29
	MOVF        readHumidity_hum02_L0+0, 0 
	SUBLW       40
L__readHumidity29:
	BTFSS       STATUS+0, 0 
	GOTO        L_readHumidity7
	MOVLW       1
	MOVWF       FARG_turnOnWaterPump_status+0 
	CALL        _turnOnWaterPump+0, 0
	GOTO        L_readHumidity8
L_readHumidity7:
;MyProject.c,155 :: 		if(hum02 >= 65) turnOnWaterPump(0);
	MOVLW       128
	XORWF       readHumidity_hum02_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readHumidity30
	MOVLW       65
	SUBWF       readHumidity_hum02_L0+0, 0 
L__readHumidity30:
	BTFSS       STATUS+0, 0 
	GOTO        L_readHumidity9
	CLRF        FARG_turnOnWaterPump_status+0 
	CALL        _turnOnWaterPump+0, 0
L_readHumidity9:
;MyProject.c,156 :: 		}
L_readHumidity8:
;MyProject.c,157 :: 		}
	GOTO        L_readHumidity10
L_readHumidity6:
;MyProject.c,158 :: 		else turnOnWaterPump(0);
	CLRF        FARG_turnOnWaterPump_status+0 
	CALL        _turnOnWaterPump+0, 0
L_readHumidity10:
;MyProject.c,161 :: 		if(switchInfo) {
	BTFSS       _flagA+0, 0 
	GOTO        L_readHumidity11
;MyProject.c,162 :: 		hum01 = hum01 / 100;
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
;MyProject.c,163 :: 		digit01 = hum01 / 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	MOVF        R0, 0 
	MOVWF       _digit01+0 
;MyProject.c,164 :: 		digit02 = hum01 % 10;
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
;MyProject.c,165 :: 		lcd_out(2, 1, "Umidade Ar:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,166 :: 		lcd_chr(2, 14, digit01 + 48);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       _digit01+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,167 :: 		lcd_chr_cp(digit02 + 48);
	MOVLW       48
	ADDWF       _digit02+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,168 :: 		}
	GOTO        L_readHumidity12
L_readHumidity11:
;MyProject.c,171 :: 		digit01 = hum02 / 100;
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
;MyProject.c,172 :: 		digit02 = hum02 / 10 - digit01 * 10;
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
;MyProject.c,173 :: 		digit03 = hum02 % 10;
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
;MyProject.c,174 :: 		lcd_out(2, 1, "Umid. Solo:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_MyProject+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_MyProject+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;MyProject.c,175 :: 		lcd_chr(2,13, digit01 + 48);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       13
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	ADDWF       _digit01+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;MyProject.c,176 :: 		lcd_chr_cp(digit02 + 48);
	MOVLW       48
	ADDWF       _digit02+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,177 :: 		lcd_chr_cp(digit03 + 48);
	MOVLW       48
	ADDWF       _digit03+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;MyProject.c,178 :: 		}
L_readHumidity12:
;MyProject.c,179 :: 		}
L_end_readHumidity:
	RETURN      0
; end of _readHumidity

_turnOnWaterPump:

;MyProject.c,181 :: 		void turnOnWaterPump(unsigned short status) {
;MyProject.c,182 :: 		if(status == 1) {
	MOVF        FARG_turnOnWaterPump_status+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_turnOnWaterPump13
;MyProject.c,183 :: 		PWM1_Start();      // Liga bomba c/ controle PWM
	CALL        _PWM1_Start+0, 0
;MyProject.c,184 :: 		PWM1_Set_Duty(100);
	MOVLW       100
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;MyProject.c,185 :: 		output = 0x01;
	BSF         LATD0_bit+0, 0 
;MyProject.c,186 :: 		}
	GOTO        L_turnOnWaterPump14
L_turnOnWaterPump13:
;MyProject.c,188 :: 		PWM1_Stop();
	CALL        _PWM1_Stop+0, 0
;MyProject.c,189 :: 		output = 0x00;
	BCF         LATD0_bit+0, 0 
;MyProject.c,190 :: 		}
L_turnOnWaterPump14:
;MyProject.c,191 :: 		}
L_end_turnOnWaterPump:
	RETURN      0
; end of _turnOnWaterPump

_exhaustFan:

;MyProject.c,195 :: 		void exhaustFan(unsigned int temperature, float threshold) {
;MyProject.c,196 :: 		if(temperature > threshold * 100) {
	MOVF        FARG_exhaustFan_threshold+0, 0 
	MOVWF       R0 
	MOVF        FARG_exhaustFan_threshold+1, 0 
	MOVWF       R1 
	MOVF        FARG_exhaustFan_threshold+2, 0 
	MOVWF       R2 
	MOVF        FARG_exhaustFan_threshold+3, 0 
	MOVWF       R3 
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
	MOVWF       FLOC__exhaustFan+0 
	MOVF        R1, 0 
	MOVWF       FLOC__exhaustFan+1 
	MOVF        R2, 0 
	MOVWF       FLOC__exhaustFan+2 
	MOVF        R3, 0 
	MOVWF       FLOC__exhaustFan+3 
	MOVF        FARG_exhaustFan_temperature+0, 0 
	MOVWF       R0 
	MOVF        FARG_exhaustFan_temperature+1, 0 
	MOVWF       R1 
	CALL        _Word2Double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FLOC__exhaustFan+0, 0 
	MOVWF       R0 
	MOVF        FLOC__exhaustFan+1, 0 
	MOVWF       R1 
	MOVF        FLOC__exhaustFan+2, 0 
	MOVWF       R2 
	MOVF        FLOC__exhaustFan+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_exhaustFan15
;MyProject.c,197 :: 		if(pwm2Duty < 254) pwm2Duty++;
	MOVLW       254
	SUBWF       _pwm2Duty+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_exhaustFan16
	INCF        _pwm2Duty+0, 1 
L_exhaustFan16:
;MyProject.c,198 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;MyProject.c,199 :: 		PWM2_Set_Duty(pwm2Duty);
	MOVF        _pwm2Duty+0, 0 
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;MyProject.c,200 :: 		}
	GOTO        L_exhaustFan17
L_exhaustFan15:
;MyProject.c,202 :: 		if (pwm2Duty > 80)pwm2Duty--;
	MOVF        _pwm2Duty+0, 0 
	SUBLW       80
	BTFSC       STATUS+0, 0 
	GOTO        L_exhaustFan18
	DECF        _pwm2Duty+0, 1 
L_exhaustFan18:
;MyProject.c,203 :: 		PWM2_Set_Duty(pwm2Duty);
	MOVF        _pwm2Duty+0, 0 
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;MyProject.c,204 :: 		if(pwm2Duty <= 80) PWM2_Stop();
	MOVF        _pwm2Duty+0, 0 
	SUBLW       80
	BTFSS       STATUS+0, 0 
	GOTO        L_exhaustFan19
	CALL        _PWM2_Stop+0, 0
L_exhaustFan19:
;MyProject.c,205 :: 		}
L_exhaustFan17:
;MyProject.c,206 :: 		}
L_end_exhaustFan:
	RETURN      0
; end of _exhaustFan
