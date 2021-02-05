#ifndef _LORA_CRC_H_
#define _LORA_CRC_H_

typedef char BOOL;
typedef char CHAR;
typedef unsigned char UCHAR;
typedef unsigned int USHORT;

USHORT usLORACRC16(UCHAR *pucFrame, USHORT usLen);

#endif