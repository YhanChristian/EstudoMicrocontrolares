
_initDht11:

;dht11.c,23 :: 		void initDht11(){
;dht11.c,24 :: 		dhtData_Direction = 0;
	BCF         TRISD7_bit+0, 7 
;dht11.c,25 :: 		dhtData = 1;
	BSF         RD7_bit+0, 7 
;dht11.c,26 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_initDht110:
	DECFSZ      R13, 1, 1
	BRA         L_initDht110
	DECFSZ      R12, 1, 1
	BRA         L_initDht110
	DECFSZ      R11, 1, 1
	BRA         L_initDht110
;dht11.c,28 :: 		}
L_end_initDht11:
	RETURN      0
; end of _initDht11

_startDht11:

;dht11.c,30 :: 		unsigned short startDht11(){
;dht11.c,31 :: 		unsigned short time = 0;
	CLRF        startDht11_time_L0+0 
;dht11.c,32 :: 		dhtData = 0;
	BCF         RD7_bit+0, 7 
;dht11.c,33 :: 		delay_ms(18);
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       128
	MOVWF       R13, 0
L_startDht111:
	DECFSZ      R13, 1, 1
	BRA         L_startDht111
	DECFSZ      R12, 1, 1
	BRA         L_startDht111
	NOP
;dht11.c,34 :: 		dhtData = 1;
	BSF         RD7_bit+0, 7 
;dht11.c,35 :: 		dhtData_Direction = 1;
	BSF         TRISD7_bit+0, 7 
;dht11.c,36 :: 		time = 0;
	CLRF        startDht11_time_L0+0 
;dht11.c,37 :: 		while (dhtData && time <= 40){
L_startDht112:
	BTFSS       RD7_bit+0, 7 
	GOTO        L_startDht113
	MOVF        startDht11_time_L0+0, 0 
	SUBLW       40
	BTFSS       STATUS+0, 0 
	GOTO        L_startDht113
L__startDht1143:
;dht11.c,38 :: 		time++;
	INCF        startDht11_time_L0+0, 1 
;dht11.c,39 :: 		delay_us(1);
	NOP
	NOP
	NOP
	NOP
;dht11.c,40 :: 		}
	GOTO        L_startDht112
L_startDht113:
;dht11.c,41 :: 		time = 0;
	CLRF        startDht11_time_L0+0 
;dht11.c,42 :: 		while (!dhtData && time <= 80){
L_startDht116:
	BTFSC       RD7_bit+0, 7 
	GOTO        L_startDht117
	MOVF        startDht11_time_L0+0, 0 
	SUBLW       80
	BTFSS       STATUS+0, 0 
	GOTO        L_startDht117
L__startDht1142:
;dht11.c,43 :: 		time++;
	INCF        startDht11_time_L0+0, 1 
;dht11.c,44 :: 		delay_us(1);
	NOP
	NOP
	NOP
	NOP
;dht11.c,45 :: 		}
	GOTO        L_startDht116
L_startDht117:
;dht11.c,46 :: 		time = 0;
	CLRF        startDht11_time_L0+0 
;dht11.c,47 :: 		while (dhtData && time <= 80){
L_startDht1110:
	BTFSS       RD7_bit+0, 7 
	GOTO        L_startDht1111
	MOVF        startDht11_time_L0+0, 0 
	SUBLW       80
	BTFSS       STATUS+0, 0 
	GOTO        L_startDht1111
L__startDht1141:
;dht11.c,48 :: 		time++;
	INCF        startDht11_time_L0+0, 1 
;dht11.c,49 :: 		delay_us(1);
	NOP
	NOP
	NOP
	NOP
;dht11.c,50 :: 		}
	GOTO        L_startDht1110
L_startDht1111:
;dht11.c,51 :: 		dhtData = 0;
	BCF         RD7_bit+0, 7 
;dht11.c,52 :: 		}
L_end_startDht11:
	RETURN      0
; end of _startDht11

_dht11:

;dht11.c,54 :: 		int dht11(unsigned short type){
;dht11.c,55 :: 		int time = 0;
	CLRF        dht11_time_L0+0 
	CLRF        dht11_time_L0+1 
	CLRF        dht11_result_L0+0 
	CLRF        dht11_i_L0+0 
;dht11.c,57 :: 		startDht11();
	CALL        _startDht11+0, 0
;dht11.c,58 :: 		dhtData_Direction = 1;
	BSF         TRISD7_bit+0, 7 
;dht11.c,59 :: 		byte = 0;
	CLRF        dht11_byte_L0+0 
;dht11.c,62 :: 		for (byte=0; byte <= 3; byte++){
	CLRF        dht11_byte_L0+0 
L_dht1114:
	MOVF        dht11_byte_L0+0, 0 
	SUBLW       3
	BTFSS       STATUS+0, 0 
	GOTO        L_dht1115
;dht11.c,63 :: 		i=1;
	MOVLW       1
	MOVWF       dht11_i_L0+0 
;dht11.c,64 :: 		for (i=1; i<=8;i++){
	MOVLW       1
	MOVWF       dht11_i_L0+0 
L_dht1117:
	MOVF        dht11_i_L0+0, 0 
	SUBLW       8
	BTFSS       STATUS+0, 0 
	GOTO        L_dht1118
;dht11.c,65 :: 		while(!dhtData) { //Aguarda proxima borda de subida
L_dht1120:
	BTFSC       RD7_bit+0, 7 
	GOTO        L_dht1121
;dht11.c,66 :: 		result = 0;
	CLRF        dht11_result_L0+0 
;dht11.c,67 :: 		time = 0;
	CLRF        dht11_time_L0+0 
	CLRF        dht11_time_L0+1 
;dht11.c,68 :: 		cicleReset++;
	INCF        dht11_cicleReset_L0+0, 1 
;dht11.c,69 :: 		if(cicleReset > 30) {
	MOVF        dht11_cicleReset_L0+0, 0 
	SUBLW       30
	BTFSC       STATUS+0, 0 
	GOTO        L_dht1122
;dht11.c,70 :: 		cicleReset = 0;
	CLRF        dht11_cicleReset_L0+0 
;dht11.c,71 :: 		break;
	GOTO        L_dht1121
;dht11.c,73 :: 		}
L_dht1122:
;dht11.c,74 :: 		}
	GOTO        L_dht1120
L_dht1121:
;dht11.c,76 :: 		while (dhtData){
L_dht1123:
	BTFSS       RD7_bit+0, 7 
	GOTO        L_dht1124
;dht11.c,77 :: 		time++;
	INFSNZ      dht11_time_L0+0, 1 
	INCF        dht11_time_L0+1, 1 
;dht11.c,78 :: 		if (time >= 4 && !result ) result = 1;
	MOVLW       128
	XORWF       dht11_time_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dht1148
	MOVLW       4
	SUBWF       dht11_time_L0+0, 0 
L__dht1148:
	BTFSS       STATUS+0, 0 
	GOTO        L_dht1127
	MOVF        dht11_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_dht1127
L__dht1144:
	MOVLW       1
	MOVWF       dht11_result_L0+0 
L_dht1127:
;dht11.c,79 :: 		if(time > 30) {
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       dht11_time_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__dht1149
	MOVF        dht11_time_L0+0, 0 
	SUBLW       30
L__dht1149:
	BTFSC       STATUS+0, 0 
	GOTO        L_dht1128
;dht11.c,80 :: 		cicleReset = 0;
	CLRF        dht11_cicleReset_L0+0 
;dht11.c,81 :: 		break;
	GOTO        L_dht1124
;dht11.c,82 :: 		}
L_dht1128:
;dht11.c,84 :: 		}
	GOTO        L_dht1123
L_dht1124:
;dht11.c,85 :: 		switch (i) {
	GOTO        L_dht1129
;dht11.c,86 :: 		case 8:
L_dht1131:
;dht11.c,87 :: 		D0B0 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1150
	BCF         _myData1+0, 0 
	GOTO        L__dht1151
L__dht1150:
	BSF         _myData1+0, 0 
L__dht1151:
;dht11.c,88 :: 		break;
	GOTO        L_dht1130
;dht11.c,89 :: 		case 7:
L_dht1132:
;dht11.c,90 :: 		D0B1 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1152
	BCF         _myData1+0, 1 
	GOTO        L__dht1153
L__dht1152:
	BSF         _myData1+0, 1 
L__dht1153:
;dht11.c,91 :: 		break;
	GOTO        L_dht1130
;dht11.c,92 :: 		case 6:
L_dht1133:
;dht11.c,93 :: 		D0B2 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1154
	BCF         _myData1+0, 2 
	GOTO        L__dht1155
L__dht1154:
	BSF         _myData1+0, 2 
L__dht1155:
;dht11.c,94 :: 		break;
	GOTO        L_dht1130
;dht11.c,95 :: 		case 5:
L_dht1134:
;dht11.c,96 :: 		D0B3 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1156
	BCF         _myData1+0, 3 
	GOTO        L__dht1157
L__dht1156:
	BSF         _myData1+0, 3 
L__dht1157:
;dht11.c,97 :: 		break;
	GOTO        L_dht1130
;dht11.c,98 :: 		case 4:
L_dht1135:
;dht11.c,99 :: 		D0B4 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1158
	BCF         _myData1+0, 4 
	GOTO        L__dht1159
L__dht1158:
	BSF         _myData1+0, 4 
L__dht1159:
;dht11.c,100 :: 		break;
	GOTO        L_dht1130
;dht11.c,101 :: 		case 3:
L_dht1136:
;dht11.c,102 :: 		D0B5 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1160
	BCF         _myData1+0, 5 
	GOTO        L__dht1161
L__dht1160:
	BSF         _myData1+0, 5 
L__dht1161:
;dht11.c,103 :: 		break;
	GOTO        L_dht1130
;dht11.c,104 :: 		case 2:
L_dht1137:
;dht11.c,105 :: 		D0B6 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1162
	BCF         _myData1+0, 6 
	GOTO        L__dht1163
L__dht1162:
	BSF         _myData1+0, 6 
L__dht1163:
;dht11.c,106 :: 		break;
	GOTO        L_dht1130
;dht11.c,107 :: 		case 1:
L_dht1138:
;dht11.c,108 :: 		D0B7 = result;
	BTFSC       dht11_result_L0+0, 0 
	GOTO        L__dht1164
	BCF         _myData1+0, 7 
	GOTO        L__dht1165
L__dht1164:
	BSF         _myData1+0, 7 
L__dht1165:
;dht11.c,109 :: 		break;
	GOTO        L_dht1130
;dht11.c,110 :: 		}
L_dht1129:
	MOVF        dht11_i_L0+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1131
	MOVF        dht11_i_L0+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1132
	MOVF        dht11_i_L0+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1133
	MOVF        dht11_i_L0+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1134
	MOVF        dht11_i_L0+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1135
	MOVF        dht11_i_L0+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1136
	MOVF        dht11_i_L0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1137
	MOVF        dht11_i_L0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_dht1138
L_dht1130:
;dht11.c,64 :: 		for (i=1; i<=8;i++){
	INCF        dht11_i_L0+0, 1 
;dht11.c,111 :: 		}
	GOTO        L_dht1117
L_dht1118:
;dht11.c,112 :: 		sendDhtData[byte] = myData1;
	MOVF        dht11_byte_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _sendDhtData+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_sendDhtData+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _myData1+0, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
;dht11.c,62 :: 		for (byte=0; byte <= 3; byte++){
	INCF        dht11_byte_L0+0, 1 
;dht11.c,113 :: 		}
	GOTO        L_dht1114
L_dht1115:
;dht11.c,115 :: 		dhtData_Direction = 0;
	BCF         TRISD7_bit+0, 7 
;dht11.c,116 :: 		dhtData = 1;
	BSF         RD7_bit+0, 7 
;dht11.c,117 :: 		if (type == 1 ){
	MOVF        FARG_dht11_type+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_dht1139
;dht11.c,118 :: 		return sendDhtData[0] * 100 + sendDhtData[1];
	MOVF        _sendDhtData+0, 0 
	MOVWF       R0 
	MOVF        _sendDhtData+1, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        _sendDhtData+2, 0 
	ADDWF       R0, 1 
	MOVF        _sendDhtData+3, 0 
	ADDWFC      R1, 1 
	GOTO        L_end_dht11
;dht11.c,119 :: 		}
L_dht1139:
;dht11.c,120 :: 		if (type == 2 ){
	MOVF        FARG_dht11_type+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_dht1140
;dht11.c,121 :: 		return sendDhtData[2] * 100 + sendDhtData[3];
	MOVF        _sendDhtData+4, 0 
	MOVWF       R0 
	MOVF        _sendDhtData+5, 0 
	MOVWF       R1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16x16_U+0, 0
	MOVF        _sendDhtData+6, 0 
	ADDWF       R0, 1 
	MOVF        _sendDhtData+7, 0 
	ADDWFC      R1, 1 
	GOTO        L_end_dht11
;dht11.c,122 :: 		}
L_dht1140:
;dht11.c,123 :: 		}
L_end_dht11:
	RETURN      0
; end of _dht11
