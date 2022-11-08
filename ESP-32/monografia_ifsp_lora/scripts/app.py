#Imports necessários projeto

import paho.mqtt.client as mqtt
import requests
import mysql.connector as sql
import json
import sys
from datetime import datetime


# Conexão - Mosquitto MQTT

server = "23.20.108.171" #localhost
port = 1883
username = "admin"
password = "root"

# Coexão - Banco de dados MySQL
sql_user = "root"
sql_pass = ""
sql_database = "db_monografia"

# Funções de Callback dos eventos
# on_connect = função chamada quando ocorre a conexão entre o cliente e o broker MQTT.
# on_message = função chamada quando uma mensagem de um tópico assinado for recebido.
# on_publish = função chamada quando uma mensagem for publicada. 
# on_subscribe = função chamada quando um tópico for assinado pelo cliente MQTT.
# on_log = função para debug do Paho.

def on_connect(client, userdata, flags, rc):
    print("rc: " + str(rc))

def on_message(client, obj, msg):
    # Imprime o conteudo da messagem.
    print(msg.topic + " " + str(msg.qos) + " " + str(msg.payload) )
    y = json.loads(msg.payload)
    data = (
	y["addr"],
    y["aX"],
    y["aY"],
    y["aZ"],
    y["amX"],
    y["amY"],
    y["amZ"],
    y["vX"],
    y["vY"],
    y["vZ"],
    y["t"],
    y["n"],
    datetime.today()
    )

    # Conexão com o banco de dados Mysql
    conn = sql.connect(user=sql_user, password=sql_pass, database=sql_database, auth_plugin='mysql_native_password')
    cursor = conn.cursor()
    query = ("INSERT INTO tb_sensor_data"
            "(id_receiver, a_rms_x, a_rms_y, a_rms_z,a_max_x, a_max_y, a_max_z,v_rms_x, v_rms_y, v_rms_z, t, n, data)"
            "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
	
    # Carrega e executa a query.
    cursor.execute(query, data)
    conn.commit()

    # Encerra a conexão com o banco de dados. 
    cursor.close()
    conn.close()

      
def on_publish(client, obj, mid):
    print("mid: " + str(mid))

def on_subscribe(client, obj, mid, granted_qos):
    print("Subscribed: " + str(mid) + " " + str(granted_qos))

def on_log(client, obj, level, string):
    print(string)

client = mqtt.Client()

# Assina as funções de callback
client.on_message = on_message
client.on_connect = on_connect
client.on_publish = on_publish
client.on_subscribe = on_subscribe

# Uncomment to enable debug messages
#client.on_log = on_log

#Conecta ao broker passando user, password, server e port

client.username_pw_set(username=username, password=password)
client.connect(server, port=port)

# Assina o tópico, com QoS level 0 (pode ser 0, 1 ou 2)

client.subscribe("ifsp/monografia-lora", 0)

# Permanece em loop mesmo se houver erros. 
client.loop_forever()
