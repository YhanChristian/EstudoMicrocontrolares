/* Controlador PID de Temperatura com PIC18F4550
   Utilizado: PIC18F4550, LM35, e SAÍDA PWM para controle de Motor DC
*/


//  -- Mapeamento de Hardware LCD --

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

// ---  Hardware e Defines --

// Outputs

#define SAIDA_TMR0 LATB0_bit
#define SAIDA_PWM  LATB2_bit

// Inputs

#define BTN_AJUSTE RB4_bit
#define BTN_INC    RB5_bit
#define BTN_DEC    RB6_bit


// Defines iniciais

#define SETPOINT_INICAL 25.0
#define KP_INICIAL 5.0
#define KI_INICIAL 0.1
#define KD_INICIAL 0.1

#define PWM_INICIAL 128
#define AMOSTRAS_TEMP 100
#define TEMPO_CALCULO_PID 100E-3

#define SETPOINT_MAX 80.0
#define SETPOINT_MIN 20.0

#define KP_MAX 9.9
#define KP_MIN 0.0

#define KI_MAX 9.9
#define KI_MIN 0.1

#define KD_MAX 9.9
#define KD_MIN 0.1


// --- Variáveis Globais ---

unsigned short  larguraPulso = 0x00,                  //armazena largura do pulso
                valor = 0x80;                         //armazena valor a ser escrito no LCD

int mediaADC = 0x00;                                 //armazena valor do ADC
double temperatura = 0.0;                           //Armazena a temperatura em graus Celsius
double temperaturaAtual = 0.0;                     //Armazena a temperatura atual
char txt[15];                                      //String para texto
const char grausCelsius[] = {6,9,6,0,0,0,0,0};    //Matriz para caractere especial de graus em LCD 'º'

double   erroMedido,
         kp = KP_INICIAL,
         ki = KI_INICIAL,
         kd = KD_INICIAL,
         proporcional,
         integral,
         derivativo,
         PID,
         setpoint = SETPOINT_INICAL;

int      medida,
         ultimaMedida,
         pwm = PWM_INICIAL,
         contTempo100ms = 0,
         contTempo2s = 0,
         menuConfig = 1;

bit     debounceBtn,
        btnAjustePress,
        btnIncPress,
        btnDecPress,
        tempo100ms,
        tempo2s,
        modoConfig,
        trocaTela,
        limpaTela;

// --- Protótipo das Funções ---

void telaInicialSistema();                  //Tela inicial sistema
void controlePID();                         //Controle PID
void celsius();                             //Temperatura em Celsius
int tempMedia();                            //retorna a média entre 100 leituras de temperatura
void CustomChar(char r, char c);            //Desenha caracter customizado º
void exibePWMAtual();                       //Função para imprimir valor no LCD
void leituraBtn();                          //Função para tratamento dos botões de ajuste
void limpaDisplay(short estado);             //Função para limpeza do display LCD
void ajusteConfig();
void configSetpoint();
void configKP();
void configKI();
void configKD();
void saiModoConfig();

// --- Tratamento das Interrupções ---

void interrupt()
{
    if(TMR0IF_bit)
    {
       TMR0IF_bit = 0x00;
       TMR0H      = 0x9E;
       TMR0L      = 0x58;

       //Flag Debounce Btn inverte estado (para teste com botões)
       debounceBtn = ~debounceBtn;
       contTempo100ms++;
       contTempo2s++;

       // 4 ciclos de 25ms = 100ms (inverto bit sinalizando).
       if(contTempo100ms == 4)
       {
          tempo100ms = ~tempo100ms;
          contTempo100ms = 0;
       }

       // 80 ciclos de 25ms = 2s (inverto bit sinalizando).
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
          SAIDA_PWM = 0x00;
      }

      else
      {
         if(SAIDA_PWM)
         {
            TMR2 = larguraPulso;
            SAIDA_PWM = 0x00;

         }
         else
         {
            TMR2 = 255 - larguraPulso;
            SAIDA_PWM = 0x01;

         }
      }
    }
}
// --- Função Principal ---

void main()
{
     ADCON0  = 0x01;                           //Liga conversor AD
     ADCON1  = 0x0E;                           //Configura os pinos do PORTB como digitais, e RA0 (PORTA) como analógico
     ADCON2  = 0b00011000;
     INTCON2.F7  = 0x00;                       //Habilita pull-ups no PORTB
     TRISB       = 0xF8;                       //Configura o RB0, RB1, RB2 como saída
     TRISD       = 0x03;                       //Configura PORTD como saída, exceto RD0 e RD1
     LATB        = 0xFC;                       //Inicializa o LATB

     INTCON      = 0xE0;                       //Habilita Interrupção Global, dos Periféricos e do Timer0
     TMR2IE_bit  = 0x01;                       //Habilita interrupção do Timer2
     TMR0H       = 0x9E;                       //Inicializa o TMR0H em 9Eh
     TMR0L       = 0x58;                       //Inicializa o TMR0L em 58h
     T0CON       = 0x81;                       //Liga TMR0, modo 16 bits, prescaler 1:4
     T2CON       = 0x05;                       //Liga TMR2, prescaler 1:4, postscaler 1:1
     PR2         = 0xFF;                       //Compara TMR2 com FFh


     larguraPulso = PWM_INICIAL;                              //inicia PWM com duty 50%


     LCD_Init();                               //Inicializa LCD
     LCD_cmd(_LCD_CURSOR_OFF);                 //apaga cursor
     LCD_cmd(_LCD_CLEAR);                      //limpa display

     telaInicialSistema();

     while(1)
     {
          //Realiza leitura dos botões
          leituraBtn();
          
          //Modo Config true
          
          if(modoConfig)
          {
              ajusteConfig();
          }
          
          else
          {
              exibePWMAtual();                    //imprime valor no LCD
              celsius();                          //calcula temperatura
          }
         
         //Atualiza a função de controle PID a cada 100ms
         
          if(tempo100ms)
          {
              controlePID();
              tempo100ms = 0;                 //limpo a flag
          }


     }


}


// --- Desenvolvimento das Funções ---


void telaInicialSistema()
{
     LCD_chr(1,1,'P');                         //imprime 'P'
     LCD_chr_cp ('W');                         //imprime 'W'
     LCD_chr_cp ('M');                         //imprime 'M'
     LCD_chr_cp (':');                         //imprime ':'
     LCD_chr(2,1,'T');                         //imprime 'T'
     LCD_chr_cp ('M');                         //imprime 'M'
     LCD_chr_cp ('P');                         //imprime 'P'
     LCD_chr_cp (':');                         //imprime ':'
}
void controlePID()
{
    medida = temperatura;

    erroMedido = setpoint - medida;

    proporcional = erroMedido * kp;

    integral += (erroMedido * ki) * TEMPO_CALCULO_PID;

    derivativo = ((ultimaMedida - medida) * kd) / TEMPO_CALCULO_PID;

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

      Lcd_Chr(2, 6, txt[0]);                    //Imprime no LCD posição 0 da string txt
      Lcd_Chr_Cp (txt[1]);                     //Imprime no LCD posição 1 da string txt
      Lcd_Chr_Cp (txt[2]);                     //Imprime no LCD posição 2 da string txt
      Lcd_Chr_Cp (txt[3]);                     //Imprime no LCD posição 3 da string txt
      Lcd_Chr_Cp (txt[4]);                     //Imprime no LCD posição 4 da string txt
      CustomChar(2, 11);                        //Imprime no LCD caractere especial º
      Lcd_Chr(2, 12,  'C');                     //Imprime no LCD

   }

}

int tempMedia()
{
  char i = 0;
  int acumulaTemp = 0;

  for(i = 0; i < AMOSTRAS_TEMP; i++)
  {
    acumulaTemp += ADC_Read(0);

  }

  return(acumulaTemp / AMOSTRAS_TEMP);

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

    dig3 = valor / 100;                        //calcula dígito 3
    dig2 = (valor % 100) / 10;                 //calcula dígito 2
    dig1 = valor % 10;                        //calcula dígito 1

    Lcd_chr(1, 6, dig3 + 0x30);               //imprime dígito 5
    Lcd_chr_cp (dig2 + 0x30);                 //imprime dígito 4
    Lcd_chr_cp (dig1 + 0x30);                 //imprime dígito 3
}

void leituraBtn()
{
    //Verifica BTN AJUSTE pressionado  e ativa modoConfig
    if(!BTN_AJUSTE)
    {
       
       btnAjustePress = 1;
       if (debounceBtn)
       {
          btnAjustePress = 1;
          debounceBtn  = 0;
       }
    }
    if(BTN_AJUSTE && btnAjustePress)
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
    
    //Só lê BTN INC E BTN DEC com modoConfig = 1
    
    if(modoConfig)
    {
        if(!BTN_INC)
        {
            if(debounceBtn)
            {
                btnIncPress = 1;
                debounceBtn = 0;
            }
        }

        if(BTN_INC && btnIncPress)
        {
            //Incrementa Valores conforme menuConfig
            if(menuConfig == 1)
            {
                setpoint+= 0.5;
                if(setpoint > SETPOINT_MAX)
                {
                     setpoint = SETPOINT_MIN;
                }
            }
            else if(menuConfig == 2)
            {
                 kp+= 0.1;
                 if(kp > KP_MAX)
                 {
                      kp = KP_MIN;
                 }
            }
            
            else if(menuConfig == 3)
            {
                ki+= 0.1;
                 if(ki > KI_MAX)
                 {
                      ki = KI_MIN;
                 }
            }
            
            else if(menuConfig == 4)
            {
                 kd += 0.1;
                 if(kd > KD_MAX)
                 {
                      kd = KD_MIN;
                 }
            }
            contTempo2s = 0;
            btnIncPress = 0;
        }

        if(!BTN_DEC)
        {
            if(debounceBtn)
            {
                btnDecPress = 1;
                debounceBtn = 0;
            }
        }
        
        if(BTN_DEC && btnDecPress)
        {
            //Incrementa Valores conforme menuConfig
            if(menuConfig == 1)
            {
                setpoint-= 0.5;
                if(setpoint < SETPOINT_MIN)
                {
                     setpoint = SETPOINT_MAX;
                }
            }
            else if(menuConfig == 2)
            {
                 kp-= 0.1;
                 if(kp < KP_MIN)
                 {
                      kp = KP_MAX;
                 }
            }

            else if(menuConfig == 3)
            {
                ki-= 0.1;
                 if(ki < KI_MIN)
                 {
                      ki = KI_MAX;
                 }
            }

            else if(menuConfig == 4)
            {
                 kd -= 0.1;
                 if(kd < KD_MIN)
                 {
                      kd = KD_MAX;
                 }
            }
            contTempo2s = 0;
            btnDecPress = 0;
        }
    }
    
    //Verifica se esta modo Config e caso nenhum botão seja pressionado por 2s ele sai do modo config
    
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
     temperaturaAtual = 0; //Zero temperatura Atual para atualizar leitor de temp.
     telaInicialSistema();
     modoConfig = 0;

}