void main() {
     //Inicia Comunicação Serial
     UART1_Init(9600);

     //Loop Infinito
     for(;;) {
          UART1_Write_Text("Ola Mundo");
          UART1_Write(0x0D);
          UART1_Write(0x0A);
          Delay_Ms(1000);
     }

}