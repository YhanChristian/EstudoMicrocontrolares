#Imports necessários projeto

import paho.mqtt.client as mqtt
import requests
import mysql.connector as sql
from datetime import datetime

#Print Timestamp
#print(datetime.today())

# Mosquitto MQTT

# Banco de dados MySql


# Funções de Callback dos eventos
# on_connect = função chamada quando ocorre a conexão entre o cliente e o broker MQTT.
# on_message = função chamada quando uma mensagem de um tópico assinado for recebido.
# on_publish = função chamada quando uma mensagem for publicada. 
# on_subscribe = função chamada quando um tópico for assinado pelo cliente MQTT.
# on_log = função para debug do Paho.