# Projeto de Monografia IFSP #

Projeto tem como objetivo devenvolver a comunicação PaP LoRa com dois módulos, sendo um responsável por iniciar a comunicação e outro responder a requisição.

- Módulo Transmissor: Iniciar a comunicação solicitando o envio do pacote de dados via LoRa dos receptores, ao receber os dados publica em um broker MQTT.
- Módulo Receptor: Recebe a requisição, faz a aquisição dos dados do sensor MPU6050 (Aceleração e temperatura) e retorna os dados via LoRa.

Os dados do acelerômetro serão calculados, a fim de identificar a vibração de equipamentos, sendo os seguintes parãmetros:

- Velocidade (RMS) 
- Aceleração (RMS e Pico)

Dos eixos x, y e z, além da temperatura, o objetivo é desenvolver um protótipo de um sensor IoT - LoRa que capta dados de vibração sendo aplicável em equipamentos rotativos para monitoramento preditivo.