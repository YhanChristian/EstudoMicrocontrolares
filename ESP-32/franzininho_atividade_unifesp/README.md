# Air – DIS: Uma abordagem de sensoriamento do ar em cidades inteligentes

Atividade realizada como requisito parcial para obter aprovação na matéria de IoT _(Internet of Things)_ do Programa de Pós Graduação da Universidade Federal de São Paulo - UNIFESP. Projeto realizado por Lucas Barros e Yhan Crhistian.

## Solucção Simplicada

A arquitetura da solução pode ser observada conforme imagem abaixo:



Os códigos fontes são separados em 2 pastas:
- smart-cities: projeto realizado com a placa de desenvolvimento Franzininho WiFi utilizando PlatformIO;
- script: script python responsável por aguardar dados publicados no broker, processá-los e armazenar em um banco de dados relacional (MySQL).