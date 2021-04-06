
/**
 * C library
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

/**
 * FreeRTOS
 */
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "freertos/event_groups.h"

/**
 * MQTT 
 */
#include "mqtt.h"

/**
 * Carrega as configurações padrão;
 */
#include "sys_config.h"

/**
 * Logs;
 */
#include "esp_log.h"

/**
 * Lib MQTT
 */
#include "mqtt_client.h"

/**
 * LoRa API;
 */
#include "lora.h"

/**
 * cJSON
 */
#include "cJSON.h"

/**
 * Variáveis
 */
static const char *TAG = "mqtt: ";
static EventGroupHandle_t mqtt_event_group;
esp_mqtt_client_handle_t client;

/**
 * Variáveis externas; 
 */
const static int CONNECTED_BIT = BIT0;

/**
 * Protótipos;
 */
extern void lora_data_send(char *node_address, char *command, char *value);

typedef struct _ret
{
    char address[30];
    char command[30];
    char value[30];
} Json_Data;

int processJson(char *payload, Json_Data *res)
{
    /**
     * payload = {"node":"1","command":"3"}
     */
    int error = 0;
    cJSON *json = cJSON_Parse(payload);

    if (json != NULL)
    {
        cJSON *address = cJSON_GetObjectItem(json, "node");
        if (address != NULL)
        {
            if (cJSON_IsString(address) && (address->valuestring != NULL))
            {
                /**
                 * Se chegou aqui é porque o json é válido, porém é preciso verificar
                 * o campo command do json;
                 */
                if (DEBUG)
                    ESP_LOGI(TAG, "Node: %s.\n", address->valuestring);

                cJSON *command = cJSON_GetObjectItem(json, "command");
                if (command != NULL)
                {
                    if (cJSON_IsString(command) && (command->valuestring != NULL))
                    {
                        /**
                         * Se chegou aqui é porque o json é válido. Tanto o address
                         * quanto command são válidos, portanto podem ser resgatados;
                         */
                        if (DEBUG)
                            ESP_LOGI(TAG, "Command: %s.\n", command->valuestring);

                        memcpy(res->address, address->valuestring, strlen(address->valuestring) + 1);
                        memcpy(res->command, command->valuestring, strlen(command->valuestring) + 1);

                        /**
                         * O campo value é opcional no Json;
                         */
                        cJSON *value = cJSON_GetObjectItem(json, "value");
                        if (value != NULL)
                        {
                            if (cJSON_IsString(value) && (value->valuestring != NULL))
                            {
                                if (DEBUG)
                                    ESP_LOGI(TAG, "Value: %s.\n", value->valuestring);

                                memcpy(res->value, value->valuestring, strlen(value->valuestring) + 1);
                            }
                        }
                    }
                }
                else
                {
                    if (DEBUG)
                        ESP_LOGI(TAG, "error in cJSON");
                    error = -1;
                }
            }
        }
        else
        {
            if (DEBUG)
                ESP_LOGI(TAG, "error in cJSON");
            error = -1;
        }

        cJSON_Delete(json);
    }

    return error;
}

/**
 * Função responsável pelo tratamento das mensagem recebidas via MQTT; 
 */
esp_err_t mqtt_read(esp_mqtt_client_handle_t client, esp_mqtt_event_handle_t mqtt_msg)
{
    Json_Data res = {{0}, {0}, {0}};
    /*
      Reserva
    */
    int total = 1 * 512;
    char *data = pvPortMalloc(total); //reserva 512 bytes do heap (RAM);
    if (data == NULL)
    {
        if (DEBUG)
            ESP_LOGI(TAG, "pvPortMalloc Error\r\n");
        return ESP_FAIL;
    }

    /*
       Comando "TOOGLE" enviado pelo cliente para um non-root. 
    */
    if (mqtt_msg->data_len > 0)
    {
        snprintf(data, total, "%.*s", mqtt_msg->data_len, mqtt_msg->data);
        if (processJson((char *)data, &res) == 0)
        {
            if (DEBUG)
            {
                ESP_LOGI(TAG, "%s", res.address);
                ESP_LOGI(TAG, "%s", res.command);
                ESP_LOGI(TAG, "%s", res.value);
            }
            /**
            * Envia mensagem MQTT para o node da rede LoRa;
            */
            lora_data_send(res.address, res.command, res.value);
        }
    }

    /*
       Libera o buffer data utilizado no armazenamento dos bytes recebidos que foi criado de maneira dinâmica;
    */
    vPortFree(data);

    return ESP_OK;
}

/**
 * Função de callback do stack MQTT;
 */

esp_err_t mqtt_event_handler(esp_mqtt_event_handle_t event)
{
    client = event->client;

    switch (event->event_id)
    {
    case MQTT_EVENT_ANY:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_ANY");
        break;

    case MQTT_EVENT_BEFORE_CONNECT:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_BEFORE_CONNECT");
        break;

    case MQTT_EVENT_CONNECTED:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_CONNECTED");

        /**
             * Assina um único tópico no broker MQTT com QoS 0;
             */
        esp_mqtt_client_subscribe(client, TOPIC_SUBSCRIBE, 0);

        /**
             * Sinaliza o app que estamos conectados ao broker MQTT; 
             */
        xEventGroupSetBits(mqtt_event_group, CONNECTED_BIT);

        break;

    case MQTT_EVENT_DISCONNECTED:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_DISCONNECTED");

        /**
             * Caso, por algum motivo, o broker MQTT venha a desconectar o cliente
             * Ex: rede offline, servidor offline, usuário não mais autenticado...
             * Sinaliza a app que não estamos mais conectados ao broker;
             */
        xEventGroupClearBits(mqtt_event_group, CONNECTED_BIT);

        break;

    case MQTT_EVENT_SUBSCRIBED:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_SUBSCRIBED, msg_id=%d", event->msg_id);
        break;

    case MQTT_EVENT_UNSUBSCRIBED:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_UNSUBSCRIBED, msg_id=%d", event->msg_id);
        break;

    case MQTT_EVENT_PUBLISHED:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_PUBLISHED, msg_id=%d", event->msg_id);
        break;

    case MQTT_EVENT_DATA:

        /**
             * Se este case for chamado significa que alguma mensagem foi recebida pelo ESP32
             * ou seja, alguma mensagem foi publicada no tópico 'TOPIC_SUBSCRIBE';
             */
        if (DEBUG)
        {
            ESP_LOGI(TAG, "MQTT_EVENT_DATA");
            /**
                 * Imprime o nome do tópico no qual a mensagem foi publicada.
                 */
            ESP_LOGI(TAG, "Topico = %.*s\r\n", event->topic_len, event->topic);
            /**
                 * Imprime o conteúdo da mensagem recebida via MQTT;
                 */
            ESP_LOGI(TAG, "Data = %.*s\r\n", event->data_len, event->data);
        }

        /**
             * Já que a mensagem foi recebida, vamos processar os dados!
             * Os dados serão processados na folha app.c;
             */
        if (mqtt_read(client, event) == ESP_OK)
        {
            if (DEBUG)
                ESP_LOGI(TAG, "Ok, mensagem processada com sucesso");
        }
        else
        {
            if (DEBUG)
                ESP_LOGI(TAG, "Falha no processamento da mensagem.");
        }

        break;

    case MQTT_EVENT_ERROR:
        if (DEBUG)
            ESP_LOGI(TAG, "MQTT_EVENT_ERROR");
        break;
    }

    return ESP_OK;
}

esp_err_t mqtt_publish_data(char *data, int data_size)
{
    if (xEventGroupWaitBits(mqtt_event_group, CONNECTED_BIT, false, true, 0) == pdTRUE)
    {
        if (esp_mqtt_client_publish(client, TOPIC_PUBLISH, (char *)data, data_size, 0, 0) == 0)
        {
            if (DEBUG)
                ESP_LOGI(TAG, "Mensagem publicada com sucesso!\r\n");
            return ESP_OK;
        }
    }
    return ESP_FAIL;
}

/**
 * Caso seja desejado encerrar o serviço MQTT use esta função;
 */
void mqtt_stop(void)
{
    if (DEBUG)
        ESP_LOGI(TAG, "mqtt_stop()");

    esp_mqtt_client_stop(client);
    esp_mqtt_client_destroy(client);
}

/**
 * Configuração do stack MQTT; 
 */
void mqtt_start(void)
{
    if (DEBUG)
        ESP_LOGI(TAG, "chamado mqtt_start()");

    mqtt_event_group = xEventGroupCreate();

    /**
     * Sem SSL/TLS
     */
    const esp_mqtt_client_config_t mqtt_cfg = {
        .uri = "mqtt://" MQTT_SERVER ":" MQTT_PORTA,
        .event_handle = mqtt_event_handler,
        .username = MQTT_USERNAME,
        .password = MQTT_PASSWORD,
    };

    /**
     * Carrega configuração do descritor e inicializa stack MQTT;
     */
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_start(client);
}