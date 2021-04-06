#Imports necessários projeto

import paho.mqtt.client as mqtt
import time
import random

#Credenciais Cloud MQTT (Credenciais devem ser alteradas pelo user) 
#Conforme Broker utilizado no caso estou utilizando o Cloud MQTT

username = "seu username"
password = "sua senha"
server = "endereco server"
port = 15253

#Variáveis Globais

#Indica conexão ao broker MQTT
connected = False 

#Funções Callback eventos MQTT
# on_connect = função chamada quando ocorre a conexão entre o cliente e o broker MQTT.
# on_message = função chamada quando uma mensagem de um tópico assinado for recebido.
# on_publish = função chamada quando uma mensagem for publicada. 
# on_subscribe = função chamada quando um tópico for assinado pelo cliente MQTT.
# on_log = função para debug do Paho.



def on_connect(client, user_data, flags, rc):
    if rc == 0:
        print("Conectado ao Broker")
        global connected
        connected = True
    else:
        print("Falha na conexão ao broker MQTT")

def on_message(client, obj, msg):
    print(str(msg.payload.decode('utf8')))

def on_publish(client, obj, mid):
    pass#print("mid: " + str(mid))

def on_subscribe(client, obj, mid, granted_qos):
    print("Subscribed: " + str(mid) + " " + str(granted_qos))

def on_log(client, obj, level, string):
    print(string)

#Configurações MQTT

mqttc = mqtt.Client("client")

#Assina as funções de Callback

mqttc.on_message = on_message
mqttc.on_connect = on_connect
mqttc.on_publish = on_publish
mqttc.on_subscribe = on_subscribe

# Descomente para habilitar mensagens de log
#mqttc.on_log = on_log

#Conecta ao broker passando user, password, server e port

mqttc.username_pw_set(username=username, password=password)
mqttc.connect(server, port=port)

# Assina o tópico, com QoS level 0 (pode ser 0, 1 ou 2)

mqttc.subscribe("pub_microgenios_esp32_lora_ex4", 0)

#Loop MQTT
mqttc.loop_start()

#Verifica conexão ao Broker e aguarda 100ms caso n conecte

while connected != True:
    time.sleep(0.1)


value = 0

#Permanece em loop aguardando uma exceção
#Atualmente estou trabalhando com 1 slave logo  apenas 1 node esta sendo subscrito/publicado

try:
    while True:
        value = value + 1
        print( "---------------------" )
        print( "Enviado=" + str(value) )
        print( "---------------------" )
        mqttc.publish("sub_microgenios_esp32_lora_ex4",'{"node":"1","command":"4"}')
        #mqttc.publish("sub_microgenios_esp32_lora_ex4",'{"node":"2","command":"4"}')
        time.sleep(30) #Aguarda 30s e publica novo dado
        
        mqttc.publish("sub_microgenios_esp32_lora_ex4",'{"node":"1","command":"3","value":"' + str(value) + '"}')
        #mqttc.publish("sub_microgenios_esp32_lora_ex4",'{"node":"2","command":"3","value":"' + str(value) + '"}')
        time.sleep(30) #Aguarda 30s e publica novo dado  

except:
    print ("Falha de leitura")
    mqttc.disconnect()
    mqttc.loop_stop()


