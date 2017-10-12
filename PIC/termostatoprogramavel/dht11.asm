
_initDht11:

;dht11.c,23 :: 		void initDht11(){
;dht11.c,24 :: 		dhtData_Direction = 0;
	BCF        TRISB2_bit+0, 2
;dht11.c,25 :: 		dhtData = 1;
	BSF        RB2_bit+0, 2
;dht11.c,26 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_initDht110:
	DECFSZ     R13+0, 1
	GOTO       L_initDht110
	DECFSZ     R12+0, 1
	GOTO       L_initDht110
	DECFSZ     R11+0, 1
	GOTO       L_initDht110
	NOP
	NOP
;dht11.c,28 :: 		}
L_end_initDht11:
	RETURN
; end of _initDht11

_startDht11:

;dht11.c,30 :: 		unsigned short startDht11(){
;dht11.c,31 :: 		unsigned short time = 0;
	CLRF       startDht11_time_L0+0
;dht11.c,32 :: 		dhtData = 0;
	BCF        RB2_bit+0, 2
;dht11.c,33 :: 		delay_ms(18);
	MOVLW      47
	MOVWF      R12+0
	MOVLW      191
	MOVWF      R13+0
L_startDht111:
	DECFSZ     R13+0, 1
	GOTO       L_startDht111
	DECFSZ     R12+0, 1
	GOTO       L_startDht111
	NOP
	NOP
;dht11.c,34 :: 		dhtData = 1;
	BSF        RB2_bit+0, 2
;dht11.c,35 :: 		dhtData_Direction = 1;
	BSF        TRISB2_bit+0, 2
;dht11.c,36 :: 		time = 0;
	CLRF       startDht11_time_L0+0
;dht11.c,37 :: 		while (dhtData && time <= 40){
L_startDht112:
	BTFSS      RB2_bit+0, 2
	GOTO       L_startDht113
	MOVF       startDht11_time_L0+0, 0
	SUBLW      40
	BTFSS      STATUS+0, 0
	GOTO       L_startDht113
L__startDht1141:
;dht11.c,38 :: 		time++;
	INCF       startDht11_time_L0+0, 1
;dht11.c,39 :: 		delay_us(1);
	NOP
	NOP
;dht11.c,40 :: 		}
	GOTO       L_startDht112
L_startDht113:
;dht11.c,41 :: 		time = 0;
	CLRF       startDht11_time_L0+0
;dht11.c,42 :: 		while (!dhtData && time <= 80){
L_startDht116:
	BTFSC      RB2_bit+0, 2
	GOTO       L_startDht117
	MOVF       startDht11_time_L0+0, 0
	SUBLW      80
	BTFSS      STATUS+0, 0
	GOTO       L_startDht117
L__startDht1140:
;dht11.c,43 :: 		time++;
	INCF       startDht11_time_L0+0, 1
;dht11.c,44 :: 		delay_us(1);
	NOP
	NOP
;dht11.c,45 :: 		};
	GOTO       L_startDht116
L_startDht117:
;dht11.c,46 :: 		time = 0;
	CLRF       startDht11_time_L0+0
;dht11.c,47 :: 		while (dhtData && time <= 80){
L_startDht1110:
	BTFSS      RB2_bit+0, 2
	GOTO       L_startDht1111
	MOVF       startDht11_time_L0+0, 0
	SUBLW      80
	BTFSS      STATUS+0, 0
	GOTO       L_startDht1111
L__startDht1139:
;dht11.c,48 :: 		time++;
	INCF       startDht11_time_L0+0, 1
;dht11.c,49 :: 		delay_us(1);
	NOP
	NOP
;dht11.c,50 :: 		}
	GOTO       L_startDht1110
L_startDht1111:
;dht11.c,51 :: 		}
L_end_startDht11:
	RETURN
; end of _startDht11

_dht11:

;dht11.c,53 :: 		int dht11(unsigned short type){
;dht11.c,54 :: 		int time = 0;
	CLRF       dht11_time_L0+0
	CLRF       dht11_time_L0+1
	CLRF       dht11_result_L0+0
	CLRF       dht11_i_L0+0
;dht11.c,56 :: 		startDht11();
	CALL       _startDht11+0
;dht11.c,57 :: 		dhtData_Direction = 1;
	BSF        TRISB2_bit+0, 2
;dht11.c,58 :: 		byte = 0;
	CLRF       dht11_byte_L0+0
;dht11.c,61 :: 		for (byte=0; byte <= 3; byte++){
	CLRF       dht11_byte_L0+0
L_dht1114:
	MOVF       dht11_byte_L0+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_dht1115
;dht11.c,62 :: 		i=1;
	MOVLW      1
	MOVWF      dht11_i_L0+0
;dht11.c,63 :: 		for (i=1; i<=8;i++){
	MOVLW      1
	MOVWF      dht11_i_L0+0
L_dht1117:
	MOVF       dht11_i_L0+0, 0
	SUBLW      8
	BTFSS      STATUS+0, 0
	GOTO       L_dht1118
;dht11.c,64 :: 		while(!dhtData); //Aguarda proxima borda de subida
L_dht1120:
	BTFSC      RB2_bit+0, 2
	GOTO       L_dht1121
	GOTO       L_dht1120
L_dht1121:
;dht11.c,65 :: 		result = 0;
	CLRF       dht11_result_L0+0
;dht11.c,66 :: 		time = 0;
	CLRF       dht11_time_L0+0
	CLRF       dht11_time_L0+1
;dht11.c,67 :: 		while (dhtData){
L_dht1122:
	BTFSS      RB2_bit+0, 2
	GOTO       L_dht1123
;dht11.c,68 :: 		time++;
	INCF       dht11_time_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       dht11_time_L0+1, 1
;dht11.c,69 :: 		if (time >= 2 && !result ){
	MOVLW      128
	XORWF      dht11_time_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dht1146
	MOVLW      2
	SUBWF      dht11_time_L0+0, 0
L__dht1146:
	BTFSS      STATUS+0, 0
	GOTO       L_dht1126
	MOVF       dht11_result_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_dht1126
L__dht1142:
;dht11.c,70 :: 		result = 1;
	MOVLW      1
	MOVWF      dht11_result_L0+0
;dht11.c,71 :: 		}
L_dht1126:
;dht11.c,72 :: 		}
	GOTO       L_dht1122
L_dht1123:
;dht11.c,73 :: 		switch (i) {
	GOTO       L_dht1127
;dht11.c,74 :: 		case 8:
L_dht1129:
;dht11.c,75 :: 		D0B0 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1147
	BCF        _myData1+0, 0
	GOTO       L__dht1148
L__dht1147:
	BSF        _myData1+0, 0
L__dht1148:
;dht11.c,76 :: 		break;
	GOTO       L_dht1128
;dht11.c,77 :: 		case 7:
L_dht1130:
;dht11.c,78 :: 		D0B1 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1149
	BCF        _myData1+0, 1
	GOTO       L__dht1150
L__dht1149:
	BSF        _myData1+0, 1
L__dht1150:
;dht11.c,79 :: 		break;
	GOTO       L_dht1128
;dht11.c,80 :: 		case 6:
L_dht1131:
;dht11.c,81 :: 		D0B2 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1151
	BCF        _myData1+0, 2
	GOTO       L__dht1152
L__dht1151:
	BSF        _myData1+0, 2
L__dht1152:
;dht11.c,82 :: 		break;
	GOTO       L_dht1128
;dht11.c,83 :: 		case 5:
L_dht1132:
;dht11.c,84 :: 		D0B3 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1153
	BCF        _myData1+0, 3
	GOTO       L__dht1154
L__dht1153:
	BSF        _myData1+0, 3
L__dht1154:
;dht11.c,85 :: 		break;
	GOTO       L_dht1128
;dht11.c,86 :: 		case 4:
L_dht1133:
;dht11.c,87 :: 		D0B4 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1155
	BCF        _myData1+0, 4
	GOTO       L__dht1156
L__dht1155:
	BSF        _myData1+0, 4
L__dht1156:
;dht11.c,88 :: 		break;
	GOTO       L_dht1128
;dht11.c,89 :: 		case 3:
L_dht1134:
;dht11.c,90 :: 		D0B5 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1157
	BCF        _myData1+0, 5
	GOTO       L__dht1158
L__dht1157:
	BSF        _myData1+0, 5
L__dht1158:
;dht11.c,91 :: 		break;
	GOTO       L_dht1128
;dht11.c,92 :: 		case 2:
L_dht1135:
;dht11.c,93 :: 		D0B6 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1159
	BCF        _myData1+0, 6
	GOTO       L__dht1160
L__dht1159:
	BSF        _myData1+0, 6
L__dht1160:
;dht11.c,94 :: 		break;
	GOTO       L_dht1128
;dht11.c,95 :: 		case 1:
L_dht1136:
;dht11.c,96 :: 		D0B7 = result;
	BTFSC      dht11_result_L0+0, 0
	GOTO       L__dht1161
	BCF        _myData1+0, 7
	GOTO       L__dht1162
L__dht1161:
	BSF        _myData1+0, 7
L__dht1162:
;dht11.c,97 :: 		break;
	GOTO       L_dht1128
;dht11.c,98 :: 		}
L_dht1127:
	MOVF       dht11_i_L0+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_dht1129
	MOVF       dht11_i_L0+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_dht1130
	MOVF       dht11_i_L0+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_dht1131
	MOVF       dht11_i_L0+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_dht1132
	MOVF       dht11_i_L0+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_dht1133
	MOVF       dht11_i_L0+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_dht1134
	MOVF       dht11_i_L0+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_dht1135
	MOVF       dht11_i_L0+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_dht1136
L_dht1128:
;dht11.c,63 :: 		for (i=1; i<=8;i++){
	INCF       dht11_i_L0+0, 1
;dht11.c,99 :: 		}
	GOTO       L_dht1117
L_dht1118:
;dht11.c,100 :: 		sendDhtData[byte] = myData1;
	MOVF       dht11_byte_L0+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _sendDhtData+0
	MOVWF      FSR
	MOVF       _myData1+0, 0
	MOVWF      INDF+0
	INCF       FSR, 1
	CLRF       INDF+0
;dht11.c,61 :: 		for (byte=0; byte <= 3; byte++){
	INCF       dht11_byte_L0+0, 1
;dht11.c,101 :: 		}
	GOTO       L_dht1114
L_dht1115:
;dht11.c,103 :: 		dhtData_Direction = 0;
	BCF        TRISB2_bit+0, 2
;dht11.c,104 :: 		dhtData = 1;
	BSF        RB2_bit+0, 2
;dht11.c,105 :: 		if (type == 1 ){
	MOVF       FARG_dht11_type+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_dht1137
;dht11.c,106 :: 		return sendDhtData[0] * 100 + sendDhtData[1];
	MOVF       _sendDhtData+0, 0
	MOVWF      R0+0
	MOVF       _sendDhtData+1, 0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       _sendDhtData+2, 0
	ADDWF      R0+0, 1
	MOVF       _sendDhtData+3, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	GOTO       L_end_dht11
;dht11.c,107 :: 		}
L_dht1137:
;dht11.c,108 :: 		if (type == 2 ){
	MOVF       FARG_dht11_type+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_dht1138
;dht11.c,109 :: 		return sendDhtData[2] * 100 + sendDhtData[3];
	MOVF       _sendDhtData+4, 0
	MOVWF      R0+0
	MOVF       _sendDhtData+5, 0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       _sendDhtData+6, 0
	ADDWF      R0+0, 1
	MOVF       _sendDhtData+7, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	GOTO       L_end_dht11
;dht11.c,110 :: 		}
L_dht1138:
;dht11.c,111 :: 		}
L_end_dht11:
	RETURN
; end of _dht11
