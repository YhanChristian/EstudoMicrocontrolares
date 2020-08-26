
#include "rtos.h"

/*
Task             Core  Prioridade     Descrição
-------------------------------------------------------------------------------
vTaskSensor        1     1              faz a leitura do sensor analógico
vTaskPrint         1     1              Imprime o valor do sensor o display
vTaskMQTT          0     2              Publica valor do Sensor em tópico MQTT
vTaskKeyboard      0     3              Faz a leitura da tecla e aciona saida
*/

xTimerHandle xTimer;
QueueHandle_t xFila;

/* Variables to store the handle of Task */

TaskHandle_t xTaskSensorHandle;
TaskHandle_t xTaskPrintHandle;
TaskHandle_t xTaskMQTTHandle;
TaskHandle_t xTaskKeyboardHandle;

/*Prototypes */

void vTaskSensor(void *pvParameters);
void vTaskPrint(void *pvParameters);
void vTaskMQTT(void *pvParameters);
void vTaskKeyboard(void *pvParameters);

/* Prototype - Callback Function from the timer */
void callBackTimer(TimerHandle_t pxTimer);

/* Create tasks, queue and timer*/

void initRTOS()
{
    /*Create Queue 1pos*/
    xFila = xQueueCreate(1, sizeof(int));

    /* Create Timer */

    xTimer = xTimerCreate("TIMER",             /*identificação timer */
                          pdMS_TO_TICKS(2000), /* tempo timer em ticks*/
                          pdTRUE,              /*pdTRUE = timer autoreload*/
                          0,                   /*id*/
                          callBackTimer);      /*função de callback */

    /* Create tasks*/
    xTaskCreatePinnedToCore(
        vTaskSensor,                     /*task*/
        "TaskLM35",                      /*identificação task*/
        configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
        NULL,                            /*parametros passados para task*/
        1,                               /*prioridade*/
        &xTaskSensorHandle,              /*handle*/
        APP_CPU_NUM);                    /* APP_CPU_NUM = 1 (CORE 01)*/

    xTaskCreatePinnedToCore(
        vTaskPrint,                      /*task*/
        "TaskPrint",                     /*identificação task*/
        configMINIMAL_STACK_SIZE + 1024, /*tamanho stack*/
        NULL,                            /*parametros passados para task*/
        1,                               /*prioridade*/
        &xTaskPrintHandle,               /*handle*/
        APP_CPU_NUM);                    /* APP_CPU_NUM = 1 (CORE 01)*/

    xTaskCreatePinnedToCore(
        vTaskMQTT,                       /*task*/
        "TaskMQTT",                      /*identificação task*/
        configMINIMAL_STACK_SIZE + 2048, /*tamanho stack*/
        NULL,                            /*parametros passados para task*/
        2,                               /*prioridade*/
        &xTaskMQTTHandle,                /*handle*/
        PRO_CPU_NUM);                    /* PRO_CPU_NUM = 0 (CORE 00)*/

    xTaskCreatePinnedToCore(
        vTaskKeyboard,            /*task*/
        "TaskKeyboard",           /*identificação task*/
        configMINIMAL_STACK_SIZE, /*tamanho stack*/
        (void *)BUTTON,           /*parametros passados para task*/
        3,                        /*prioridade*/
        &xTaskKeyboardHandle,     /*handle*/
        PRO_CPU_NUM);             /* PRO_CPU_NUM = 0 (CORE 00)*/

    xTimerStart(xTimer, 0);
}

/*Task Sensor - Implement*/
void vTaskSensor(void *pvParameters)
{
    (void)pvParameters;

    float readADCValue;
    while (true)
    {
        readADCValue = readSensor();
        xQueueOverwrite(xFila, &readADCValue); /* envia valor atual de count para fila*/
        vTaskDelay(pdMS_TO_TICKS(1000));       /* Aguarda 1000 ms antes de uma nova iteração*/
    }
}

/*Task Print - Implement*/

void vTaskPrint(void *pvParameters)
{
    (void)pvParameters; /* Apenas para o Compilador não retornar warnings */
    float value = 0;
    while (true)
    {
        if (xQueueReceive(xFila, &value, portMAX_DELAY) == pdTRUE) //verifica se há valor na fila para ser lido. Espera 1 segundo
        {
            showDisplay(value);
        }
    }
}

/*Task MQTT - Implement*/

void vTaskMQTT(void *pvParameters)
{
    (void)pvParameters;

    float value = 0;

    while (true)
    {
        if (xQueueReceive(xFila, &value, portMAX_DELAY) == pdTRUE) //verifica se há valor na fila para ser lido. Espera 1 segundo
        {
            /* Verifica conexão WiFi e MQTT*/

            verifyWifiConnect();
            verifyMQTTConnect();

            /*Publica valor lido pelo sensor */

            publishDataToMQTT(value);
            vTaskDelay(30000); /*30s para nova publicação*/
        }
    }
}

/*Task Keyboard - Implement*/

void vTaskKeyboard(void *pvParameters)
{
    int pin = (int)pvParameters;

    uint8_t debouncingTime = 0;

    bool estadoAnterior = 0;
    
    pinMode(OUT_01, OUTPUT);

    keyboardInit(pin);

    while (true)
    {
        /*Botão com input_pullup le com nível lógico baixo !read == LOW*/
        if (readKeyboard(pin) == PRESSED)
        {
            debouncingTime++;

            /* Tratamento do Debounce do botão*/

            if ((debouncingTime >= 10) && (estadoAnterior == LOOSE))
            {

                debouncingTime = 0;
                digitalWrite(OUT_01, !digitalRead(OUT_01));
                estadoAnterior = PRESSED;
            }
        }
        else
        {
            debouncingTime = 0;
            estadoAnterior = LOOSE;
        }

        vTaskDelay(pdMS_TO_TICKS(10));
    }
}

/*Callback Function from the timer */

void callBackTimer(TimerHandle_t pxTimer)
{
    digitalWrite(LED_HEART_BEAT, !digitalRead(LED_HEART_BEAT));
    vTaskDelay(pdMS_TO_TICKS(100));
}