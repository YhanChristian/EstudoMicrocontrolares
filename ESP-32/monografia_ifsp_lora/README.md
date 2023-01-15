# Projeto de Monografia IFSP #

Projeto tem como objetivo devenvolver a comunicação PaP LoRa com dois módulos, sendo um responsável por iniciar a comunicação e outro responder a requisição.

- Módulo Transmissor: Iniciar a comunicação solicitando o envio do pacote de dados via LoRa dos receptores, ao receber os dados publica em um broker MQTT.
- Módulo Receptor: Recebe a requisição, faz a aquisição dos dados do sensor MPU6050 (Aceleração e temperatura) e retorna os dados via LoRa.

Os dados do acelerômetro serão calculados, a fim de identificar a vibração de equipamentos, sendo os seguintes parãmetros:

- Velocidade (RMS) 
- Aceleração (RMS e Pico)

Dos eixos x, y e z, além da temperatura, o objetivo é desenvolver um protótipo de um sensor IoT - LoRa que capta dados de vibração sendo aplicável em equipamentos rotativos para monitoramento preditivo.

# <h3>Arquitetura Resumida Projeto </h3> #

![IFSP - Diagrama Rede Projeto](https://user-images.githubusercontent.com/11355408/201549796-90a14d85-143c-4dde-857e-bb7316cfc136.png)

Para visualização dos dados através do Dashboard no Grafana o projeto segue a seguinte topologia:

- Servidor em Nuvem: Instância criada na Amazon AWS (instalado Broker MQTT (mosquitto) e Grafana)
- Módulo Transmissor: Após receber dados do Módulo Receptor publica os dados via MQTT;
- Script Python: Verifica os dados recebidos e insere no banco de dados MySQL;
- Grafana: Visualização dos dados e alertas de outliers aos usuários.

# <h3> Visualização do Dashboard </h3> #

![dash_board_grafana](https://user-images.githubusercontent.com/11355408/201550007-c40635e9-2551-42c8-8c4b-2f95d10f2361.png)

Os códigos fontes são separados em 3 pastas:

- transmissor: código fonte do Módulo Transmissor;
- receptor: código fonte do Módulo Receptor;
- script: script Python para inserção dos dados no banco MySQL
