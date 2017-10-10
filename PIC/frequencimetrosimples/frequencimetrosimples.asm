
_main:

;frequencimetrosimples.c,40 :: 		void main() {
;frequencimetrosimples.c,41 :: 		configureMcu();
	CALL        _configureMcu+0, 0
;frequencimetrosimples.c,42 :: 		initLcd();
	CALL        _initLcd+0, 0
;frequencimetrosimples.c,48 :: 		while(1) {
L_main0:
;frequencimetrosimples.c,49 :: 		if(TMR1IF_bit) {
	BTFSS       TMR1IF_bit+0, 0 
	GOTO        L_main2
;frequencimetrosimples.c,50 :: 		TMR1IF_bit = 0x00;
	BCF         TMR1IF_bit+0, 0 
;frequencimetrosimples.c,51 :: 		TMR1H = 0x3C;
	MOVLW       60
	MOVWF       TMR1H+0 
;frequencimetrosimples.c,52 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;frequencimetrosimples.c,53 :: 		auxT1++;
	INCF        _auxT1+0, 1 
;frequencimetrosimples.c,54 :: 		if(auxT1 == 10) {
	MOVF        _auxT1+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_main3
;frequencimetrosimples.c,55 :: 		readFrequency();
	CALL        _readFrequency+0, 0
;frequencimetrosimples.c,56 :: 		output = ~output;
	BTG         LATB0_bit+0, 0 
;frequencimetrosimples.c,57 :: 		auxT1 = 0x00;
	CLRF        _auxT1+0 
;frequencimetrosimples.c,58 :: 		}
L_main3:
;frequencimetrosimples.c,59 :: 		}
L_main2:
;frequencimetrosimples.c,60 :: 		}
	GOTO        L_main0
;frequencimetrosimples.c,61 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_configureMcu:

;frequencimetrosimples.c,63 :: 		void configureMcu() {
;frequencimetrosimples.c,64 :: 		ADCON1 = 0x0F; // Todos IO's Digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;frequencimetrosimples.c,65 :: 		T0CON = 0xE8; // Timer 8 bits, prescaler 1:1, incrementa de low to high
	MOVLW       232
	MOVWF       T0CON+0 
;frequencimetrosimples.c,66 :: 		TRISB = 0x0E;
	MOVLW       14
	MOVWF       TRISB+0 
;frequencimetrosimples.c,67 :: 		LATB =  0x00;
	CLRF        LATB+0 
;frequencimetrosimples.c,68 :: 		TMR0L = 0x00;
	CLRF        TMR0L+0 
;frequencimetrosimples.c,69 :: 		T1CON = 0xB1; //Timer 16 bits, prescaler 1:8
	MOVLW       177
	MOVWF       T1CON+0 
;frequencimetrosimples.c,71 :: 		TMR1H = 0x3C;
	MOVLW       60
	MOVWF       TMR1H+0 
;frequencimetrosimples.c,72 :: 		TMR1L = 0xB0;
	MOVLW       176
	MOVWF       TMR1L+0 
;frequencimetrosimples.c,73 :: 		}
L_end_configureMcu:
	RETURN      0
; end of _configureMcu

_initLcd:

;frequencimetrosimples.c,74 :: 		void initLcd(){
;frequencimetrosimples.c,75 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;frequencimetrosimples.c,76 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;frequencimetrosimples.c,77 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;frequencimetrosimples.c,78 :: 		}
L_end_initLcd:
	RETURN      0
; end of _initLcd

_readFrequency:

;frequencimetrosimples.c,83 :: 		void readFrequency() {
;frequencimetrosimples.c,85 :: 		frequency = TMR0L;
	MOVF        TMR0L+0, 0 
	MOVWF       readFrequency_frequency_L0+0 
	MOVLW       0
	MOVWF       readFrequency_frequency_L0+1 
;frequencimetrosimples.c,86 :: 		FloatToStr(frequency, myFrequency);
	MOVF        readFrequency_frequency_L0+0, 0 
	MOVWF       R0 
	MOVF        readFrequency_frequency_L0+1, 0 
	MOVWF       R1 
	CALL        _Word2Double+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _myFrequency+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_myFrequency+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;frequencimetrosimples.c,87 :: 		lcd_chr(1,4, 'F');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       70
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;frequencimetrosimples.c,88 :: 		lcd_chr_cp('r');
	MOVLW       114
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,89 :: 		lcd_chr_cp('e');
	MOVLW       101
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,90 :: 		lcd_chr_cp('q');
	MOVLW       113
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,91 :: 		lcd_chr_cp('u');
	MOVLW       117
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,92 :: 		lcd_chr_cp('e');
	MOVLW       101
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,93 :: 		lcd_chr_cp('n');
	MOVLW       110
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,94 :: 		lcd_chr_cp('c');
	MOVLW       99
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,95 :: 		lcd_chr_cp('i');
	MOVLW       105
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,96 :: 		lcd_chr_cp('a');
	MOVLW       97
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,97 :: 		lcd_chr(2,6,myFrequency[0]);                     //Imprime no LCD posição 0 da string txt
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _myFrequency+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;frequencimetrosimples.c,98 :: 		lcd_chr_cp (myFrequency[1]);                     //Imprime no LCD posição 1 da string txt
	MOVF        _myFrequency+1, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,99 :: 		lcd_chr_cp (myFrequency[2]);                     //Imprime no LCD posição 2 da string txt
	MOVF        _myFrequency+2, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,100 :: 		lcd_chr_cp (myFrequency[3]);                     //Imprime no LCD posição 3 da string txt
	MOVF        _myFrequency+3, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,101 :: 		lcd_chr_cp (myFrequency[4]);                     //Imprime no LCD posição 3 da string txt
	MOVF        _myFrequency+4, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,102 :: 		lcd_chr(2,12, 'H');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       72
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;frequencimetrosimples.c,103 :: 		lcd_chr_cp ('z');
	MOVLW       122
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;frequencimetrosimples.c,104 :: 		}
L_end_readFrequency:
	RETURN      0
; end of _readFrequency
