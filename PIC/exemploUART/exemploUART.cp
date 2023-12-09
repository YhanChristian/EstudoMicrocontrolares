#line 1 "C:/Users/yhan/Documents/EstudoMicrocontrolares/PIC/exemploUART/exemploUART.c"
void main() {

 UART1_Init(9600);


 for(;;) {
 UART1_Write_Text("Ola Mundo");
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 Delay_Ms(1000);
 }

}
