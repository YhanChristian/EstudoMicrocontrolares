
/*
  Exemplo de Utilização LM35 
  Utilizado: MSP-EXP430FR2433 e LM35
  Autor: Yhan Christian Souza Silva - Data: 28/03/2018
*/


const int sensorTemperatura = A7;


void setup() {
  Serial.begin(9600);
}

void loop() {
  float temp = (float(analogRead(sensorTemperatura)) * 3 / (1023)) / 0.01;  
  Serial.print("Temperatura ºC: ");
  Serial.println(temp);
  delay(1000);
}
