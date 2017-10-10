
_bcdData:

;displaybcd.c,1 :: 		unsigned short bcdData(unsigned short digit){
;displaybcd.c,7 :: 		switch(digit) {
	GOTO       L_bcdData0
;displaybcd.c,8 :: 		case 0:                       //abcdefg
L_bcdData2:
;displaybcd.c,9 :: 		returnData = 0b0111111;// 1111110;
	MOVLW      63
	MOVWF      R1+0
;displaybcd.c,10 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,12 :: 		case 1:
L_bcdData3:
;displaybcd.c,13 :: 		returnData = 0b0000110;// 0110000;
	MOVLW      6
	MOVWF      R1+0
;displaybcd.c,14 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,16 :: 		case 2:
L_bcdData4:
;displaybcd.c,17 :: 		returnData = 0b1011011;// 1101101;
	MOVLW      91
	MOVWF      R1+0
;displaybcd.c,18 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,20 :: 		case 3:
L_bcdData5:
;displaybcd.c,21 :: 		returnData = 0b1001111;// 1111001;
	MOVLW      79
	MOVWF      R1+0
;displaybcd.c,22 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,24 :: 		case 4:
L_bcdData6:
;displaybcd.c,25 :: 		returnData = 0b1100110; //0110011;
	MOVLW      102
	MOVWF      R1+0
;displaybcd.c,26 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,28 :: 		case 5:
L_bcdData7:
;displaybcd.c,29 :: 		returnData = 0b1101101;//1011011;
	MOVLW      109
	MOVWF      R1+0
;displaybcd.c,30 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,32 :: 		case 6:
L_bcdData8:
;displaybcd.c,33 :: 		returnData = 0b1111101;//1011111;
	MOVLW      125
	MOVWF      R1+0
;displaybcd.c,34 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,36 :: 		case 7:
L_bcdData9:
;displaybcd.c,37 :: 		returnData = 0b0000111;//1110000;
	MOVLW      7
	MOVWF      R1+0
;displaybcd.c,38 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,40 :: 		case 8:
L_bcdData10:
;displaybcd.c,41 :: 		returnData = 0b1111111;//1111111;
	MOVLW      127
	MOVWF      R1+0
;displaybcd.c,42 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,44 :: 		case 9:
L_bcdData11:
;displaybcd.c,45 :: 		returnData = 0b1101111;//1111011;
	MOVLW      111
	MOVWF      R1+0
;displaybcd.c,46 :: 		break;
	GOTO       L_bcdData1
;displaybcd.c,47 :: 		}
L_bcdData0:
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData2
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData3
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData4
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData5
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData6
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData7
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData8
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData9
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData10
	MOVF       FARG_bcdData_digit+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_bcdData11
L_bcdData1:
;displaybcd.c,48 :: 		return ~returnData;
	COMF       R1+0, 0
	MOVWF      R0+0
;displaybcd.c,49 :: 		}
L_end_bcdData:
	RETURN
; end of _bcdData
