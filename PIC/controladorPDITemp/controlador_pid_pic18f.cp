#line 1 "C:/Users/User/Google Drive/Atividades - Freelancer/Em Andamento/PIC - Controle PI de Temperatura/controlador_pid_pic18f.c"
#line 8 "C:/Users/User/Google Drive/Atividades - Freelancer/Em Andamento/PIC - Controle PI de Temperatura/controlador_pid_pic18f.c"
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;
#line 62 "C:/Users/User/Google Drive/Atividades - Freelancer/Em Andamento/PIC - Controle PI de Temperatura/controlador_pid_pic18f.c"
unsigned short larguraPulso = 0x00,
 valor = 0x80;

int mediaADC = 0x00;
double temperatura = 0.0;
double temperaturaAtual = 0.0;
char txt[15];
const char grausCelsius[] = {6,9,6,0,0,0,0,0};

double erroMedido,
 kp =  5.0 ,
 ki =  0.1 ,
 kd =  0.1 ,
 proporcional,
 integral,
 derivativo,
 PID,
 setpoint =  25.0 ;

int medida,
 ultimaMedida,
 pwm =  128 ,
 contTempo100ms = 0,
 contTempo2s = 0,
 menuConfig = 1;

bit debounceBtn,
 btnAjustePress,
 btnIncPress,
 btnDecPress,
 tempo100ms,
 tempo2s,
 modoConfig,
 trocaTela,
 limpaTela;



void telaInicialSistema();
void controlePID();
void celsius();
int tempMedia();
void CustomChar(char r, char c);
void exibePWMAtual();
void leituraBtn();
void limpaDisplay(short estado);
void ajusteConfig();
void configSetpoint();
void configKP();
void configKI();
void configKD();
void saiModoConfig();



void interrupt()
{
 if(TMR0IF_bit)
 {
 TMR0IF_bit = 0x00;
 TMR0H = 0x9E;
 TMR0L = 0x58;


 debounceBtn = ~debounceBtn;
 contTempo100ms++;
 contTempo2s++;


 if(contTempo100ms == 4)
 {
 tempo100ms = ~tempo100ms;
 contTempo100ms = 0;
 }


 if(contTempo2s == 80)
 {
 tempo2s = ~tempo2s;
 contTempo2s = 0;
 }
 }

 if(TMR2IF_bit)
 {
 TMR2IF_bit = 0x00;

 if(larguraPulso == 0x00)
 {
  LATB2_bit  = 0x00;
 }

 else
 {
 if( LATB2_bit )
 {
 TMR2 = larguraPulso;
  LATB2_bit  = 0x00;

 }
 else
 {
 TMR2 = 255 - larguraPulso;
  LATB2_bit  = 0x01;

 }
 }
 }
}


void main()
{
 ADCON0 = 0x01;
 ADCON1 = 0x0E;
 ADCON2 = 0b00011000;
 INTCON2.F7 = 0x00;
 TRISB = 0xF8;
 TRISD = 0x03;
 LATB = 0xFC;

 INTCON = 0xE0;
 TMR2IE_bit = 0x01;
 TMR0H = 0x9E;
 TMR0L = 0x58;
 T0CON = 0x81;
 T2CON = 0x05;
 PR2 = 0xFF;


 larguraPulso =  128 ;


 LCD_Init();
 LCD_cmd(_LCD_CURSOR_OFF);
 LCD_cmd(_LCD_CLEAR);

 telaInicialSistema();

 while(1)
 {

 leituraBtn();



 if(modoConfig)
 {
 ajusteConfig();
 }

 else
 {
 exibePWMAtual();
 celsius();
 }



 if(tempo100ms)
 {
 controlePID();
 tempo100ms = 0;
 }


 }


}





void telaInicialSistema()
{
 LCD_chr(1,1,'P');
 LCD_chr_cp ('W');
 LCD_chr_cp ('M');
 LCD_chr_cp (':');
 LCD_chr(2,1,'T');
 LCD_chr_cp ('M');
 LCD_chr_cp ('P');
 LCD_chr_cp (':');
}
void controlePID()
{
 medida = temperatura;

 erroMedido = setpoint - medida;

 proporcional = erroMedido * kp;

 integral += (erroMedido * ki) *  100E-3 ;

 derivativo = ((ultimaMedida - medida) * kd) /  100E-3 ;

 ultimaMedida = medida;

 PID = proporcional + integral + derivativo;

 PID = PID / 4;
 larguraPulso = PID + 128;
 if(larguraPulso == 256) larguraPulso = 255;

}

void celsius()
{

 mediaADC = tempMedia();

 temperatura = ((mediaADC * 5.0) / 1024.0);

 temperatura = temperatura * 100.0;


 if(temperatura < (temperaturaAtual - 0.5) || temperatura > (temperaturaAtual + 0.5))
 {

 temperaturaAtual = temperatura;

 FloatToStr(temperatura, txt);

 Lcd_Chr(2, 6, txt[0]);
 Lcd_Chr_Cp (txt[1]);
 Lcd_Chr_Cp (txt[2]);
 Lcd_Chr_Cp (txt[3]);
 Lcd_Chr_Cp (txt[4]);
 CustomChar(2, 11);
 Lcd_Chr(2, 12, 'C');

 }

}

int tempMedia()
{
 char i = 0;
 int acumulaTemp = 0;

 for(i = 0; i <  100 ; i++)
 {
 acumulaTemp += ADC_Read(0);

 }

 return(acumulaTemp /  100 );

}

void CustomChar(char r, char c)
{
 char i;
 Lcd_Cmd(72);
 for (i = 0; i<=7; i++) Lcd_Chr_CP(grausCelsius[i]);
 Lcd_Cmd(_LCD_RETURN_HOME);
 Lcd_Chr(r, c, 1);

}

void exibePWMAtual()
{
 unsigned char dig3,dig2,dig1;

 valor = larguraPulso;

 dig3 = valor / 100;
 dig2 = (valor % 100) / 10;
 dig1 = valor % 10;

 Lcd_chr(1, 6, dig3 + 0x30);
 Lcd_chr_cp (dig2 + 0x30);
 Lcd_chr_cp (dig1 + 0x30);
}

void leituraBtn()
{

 if(! RB4_bit )
 {

 btnAjustePress = 1;
 if (debounceBtn)
 {
 btnAjustePress = 1;
 debounceBtn = 0;
 }
 }
 if( RB4_bit  && btnAjustePress)
 {
 if(!modoConfig)
 {
 modoConfig = 1;
 trocaTela = 1;
 }
 else if(modoConfig)
 {
 menuConfig++;
 trocaTela = 1;
 }
 contTempo2s = 0;
 btnAjustePress = 0;
 }



 if(modoConfig)
 {
 if(! RB5_bit )
 {
 if(debounceBtn)
 {
 btnIncPress = 1;
 debounceBtn = 0;
 }
 }

 if( RB5_bit  && btnIncPress)
 {

 if(menuConfig == 1)
 {
 setpoint+= 0.5;
 if(setpoint >  80.0 )
 {
 setpoint =  20.0 ;
 }
 }
 else if(menuConfig == 2)
 {
 kp+= 0.1;
 if(kp >  9.9 )
 {
 kp =  0.0 ;
 }
 }

 else if(menuConfig == 3)
 {
 ki+= 0.1;
 if(ki >  9.9 )
 {
 ki =  0.1 ;
 }
 }

 else if(menuConfig == 4)
 {
 kd += 0.1;
 if(kd >  9.9 )
 {
 kd =  0.1 ;
 }
 }
 contTempo2s = 0;
 btnIncPress = 0;
 }

 if(! RB6_bit )
 {
 if(debounceBtn)
 {
 btnDecPress = 1;
 debounceBtn = 0;
 }
 }

 if( RB6_bit  && btnDecPress)
 {

 if(menuConfig == 1)
 {
 setpoint-= 0.5;
 if(setpoint <  20.0 )
 {
 setpoint =  80.0 ;
 }
 }
 else if(menuConfig == 2)
 {
 kp-= 0.1;
 if(kp <  0.0 )
 {
 kp =  9.9 ;
 }
 }

 else if(menuConfig == 3)
 {
 ki-= 0.1;
 if(ki <  0.1 )
 {
 ki =  9.9 ;
 }
 }

 else if(menuConfig == 4)
 {
 kd -= 0.1;
 if(kd <  0.1 )
 {
 kd =  9.9 ;
 }
 }
 contTempo2s = 0;
 btnDecPress = 0;
 }
 }



 if(modoConfig && tempo2s)
 {
 tempo2s = 0;
 trocaTela = 1;
 menuConfig = 5;
 }
}

void limpaDisplay(short estado)
{
 if(estado)
 {
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_RETURN_HOME);
 estado = 0;
 }
}

void ajusteConfig()
{
 switch(menuConfig)
 {
 case 1:
 configSetpoint();
 break;
 case 2:
 configKP();
 break;
 case 3:
 configKI();
 break;
 case 4:
 configKD();
 break;
 case 5:
 saiModoConfig();
 break;
 }
}

void configSetpoint()
{
 if(trocaTela)
 {
 limpaTela = 1;
 trocaTela = 0;
 limpaDisplay(limpaTela);
 }

 FloatToStr(setpoint, txt);

 LCD_chr(1,4,'A');
 LCD_chr_cp ('J');
 LCD_chr_cp ('U');
 LCD_chr_cp ('S');
 LCD_chr_cp ('T');
 LCD_chr_cp ('E');
 LCD_chr_cp (' ');
 LCD_chr_cp ('S');
 LCD_chr_cp ('P');
 Lcd_Chr(2, 7, txt[0]);
 Lcd_Chr_Cp (txt[1]);
 Lcd_Chr_Cp (txt[2]);
 Lcd_Chr_Cp (txt[3]);
}

void configKP()
{
 if(trocaTela)
 {
 limpaTela = 1;
 trocaTela = 0;
 limpaDisplay(limpaTela);
 }

 FloatToStr(kp, txt);

 LCD_chr(1,4,'A');
 LCD_chr_cp ('J');
 LCD_chr_cp ('U');
 LCD_chr_cp ('S');
 LCD_chr_cp ('T');
 LCD_chr_cp ('E');
 LCD_chr_cp (' ');
 LCD_chr_cp ('K');
 LCD_chr_cp ('P');
 Lcd_Chr(2, 7, txt[0]);
 Lcd_Chr_Cp (txt[1]);
 Lcd_Chr_Cp (txt[2]);
}

void configKI()
{
 if(trocaTela)
 {
 limpaTela = 1;
 trocaTela = 0;
 limpaDisplay(limpaTela);
 }

 FloatToStr(ki, txt);

 LCD_chr(1,4,'A');
 LCD_chr_cp ('J');
 LCD_chr_cp ('U');
 LCD_chr_cp ('S');
 LCD_chr_cp ('T');
 LCD_chr_cp ('E');
 LCD_chr_cp (' ');
 LCD_chr_cp ('K');
 LCD_chr_cp ('I');
 Lcd_Chr(2, 7, txt[0]);
 Lcd_Chr_Cp (txt[1]);
 Lcd_Chr_Cp (txt[2]);
}

void configKD()
{
 if(trocaTela)
 {
 limpaTela = 1;
 trocaTela = 0;
 limpaDisplay(limpaTela);
 }

 FloatToStr(kd, txt);

 LCD_chr(1,4,'A');
 LCD_chr_cp ('J');
 LCD_chr_cp ('U');
 LCD_chr_cp ('S');
 LCD_chr_cp ('T');
 LCD_chr_cp ('E');
 LCD_chr_cp (' ');
 LCD_chr_cp ('K');
 LCD_chr_cp ('D');
 Lcd_Chr(2, 7, txt[0]);
 Lcd_Chr_Cp (txt[1]);
 Lcd_Chr_Cp (txt[2]);
}

void saiModoConfig()
{
 if(trocaTela)
 {
 limpaTela = 1;
 trocaTela = 0;
 limpaDisplay(limpaTela);
 }

 menuConfig = 1;
 temperaturaAtual = 0;
 telaInicialSistema();
 modoConfig = 0;

}
