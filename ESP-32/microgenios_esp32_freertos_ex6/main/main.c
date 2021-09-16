/* Curso Formação IoT ESP32
   Módulo: ESP-32 com FreeRTOS (SDK IDF)
   Exemplo 3: Passagem de String (constante) fila FreeRTOS
   Autor: Yhan Christian Souza Silva - data: 15/09/2021
   Descrição: Este Projeto tem por objetivo passar uma string constante por fila 
   de uma task para outra.
*/
   
/*
 * Lib C
 */
#include <stdio.h>
#include <stdint.h>  
#include <string.h>

/*
 * FreeRTOS
 */
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"

/*
 * Drivers
 */
#include "driver/gpio.h"

/*
 * logs
 */
#include "esp_log.h"

/*
 * Definições Gerais
 */
#define BLINK_GPIO 		2 //Led building azul do kit ESP32
#define BUTTON_GPIO  GPIO_NUM_17
static const char * TAG = "Main: ";

/*
 * Variável Global. 
 */
QueueHandle_t xQueue_button; 

/**
 * Protótipos;
 */
void task_button( void * pvParameter );
void task_print( void * pvParameter ); 
void task_blink( void *pvParameter ); 

/*
 * Task Responsável pelo incremento e envio da variável count
 * na fila.
 */
void task_button( void * pvParameter )
{
	/* uint32_t é um typedef padrão definido em stdint.h */
	uint32_t status = 0;

	const char * txt =  "Palmeiras n tem mundial";

    /**
     * Configuração da GPIO 17 como saída;
     */
    gpio_pad_select_gpio( BUTTON_GPIO );
    gpio_set_direction( BUTTON_GPIO, GPIO_MODE_INPUT );
    gpio_set_pull_mode( BUTTON_GPIO, GPIO_PULLUP_ONLY );	

	/* As Tasks normalmente possuem um loop sem saída */
	for( ;; )
	{

		/**
		 * Botão pressionado?
		 */
		if( gpio_get_level( BUTTON_GPIO ) == 0 && status == 0)
		{
			/**
			 * Delay necessário para não processar o bounce causado
			 * pelo acionamento do botão;
			 */
			vTaskDelay( 100 / portTICK_PERIOD_MS ); 

			/**
			 * O botão ainda está sendo pressionado? Sim, então...
			 */
			if( gpio_get_level( BUTTON_GPIO ) == 0 && status == 0 )
			{

				ESP_LOGI( TAG, "Button foi pressionado.\n" );
				/**
				 * Envia na o endereço do vetor na fila;
				 */
				if( xQueueSend( xQueue_button, &txt, ( 10/portTICK_PERIOD_MS ) ) == pdPASS )
				{
					ESP_LOGI( TAG, "Mensagem enviada com sucesso!\n" );
					
				}
				status = 1; 				
			}

		}

		/**
		 * Botão Solto?
		 */
		if( gpio_get_level( BUTTON_GPIO ) == 1 && status == 1 )
		{
			/**
			 * Delay necessário para não processar o bounce causado
			 * pelo acionamento do botão;
			 */
			vTaskDelay( 100 / portTICK_PERIOD_MS ); 

			/**
			 * O botão ainda está realmente solto? Sim, então...
			 */
			if( gpio_get_level(BUTTON_GPIO) == 1 && status == 1 )
			{
				ESP_LOGI( TAG, "Button foi solto.\n" );
				status = 0; 
			}
		}
		
		/* Bloqueia esta task por 10ms */
		vTaskDelay( 10/portTICK_PERIOD_MS );
	}
	
	/* este comando não deveria ser executado... Caso algo estranho aconteça, 
	 * esta task será deletada; O parametro NULL informa que é para desalocar
	 * da memória ESTA task;
	*/
    vTaskDelete( NULL );	
}

/*
 * Esta task é responsável em receber o valor de count
 * por meio da leitura da fila e imprimir na saída do console.
*/
void task_print( void * pvParameter )
{
	char * str = NULL; 
	
	for( ;; )
	{
		/**
		 * Aguarda a chegada de algum valor na fila;
		 */
		xQueueReceive( xQueue_button, &str, portMAX_DELAY ); 	
		ESP_LOGI( TAG, "Mensagem Recebida = %s. \n", str );
		
		
		/* Bloqueia intencionalmente esta task por 10ms */
		vTaskDelay( 10/portTICK_PERIOD_MS );
	}
	/**
	 * Este comando não deve ser executado...
	 */
    vTaskDelete( NULL );
}

/*
 * Task responsável em inverter o estado lógico do led building
 * do kit;
*/
void task_blink( void *pvParameter )
{
	/*
	 * Configura a GPIO2 do ESP32 como GPIO-OUTPUT;
	 * Sobre o Led Building do ESP32; 
	 * Ligado 		-> GPIO2 - Nível 0
	 * Desligado 	-> GPIO2 - Nível 1
	*/
    gpio_pad_select_gpio( BLINK_GPIO );
    gpio_set_direction( BLINK_GPIO, GPIO_MODE_OUTPUT );

    for(;;)
	{
        /* Liga Led building */
        gpio_set_level( BLINK_GPIO, 0 );
        vTaskDelay( 1000 / portTICK_PERIOD_MS );

        /* Desliga Led building */
        gpio_set_level( BLINK_GPIO, 1 );
        vTaskDelay( 1000 / portTICK_PERIOD_MS );
    }
}

/**
 * Inicio do Programa; 
 */
void app_main( void )
{
	/*
	 * Realiza a alocação dinâmica da fila na memória RAM do ESP32;
	 * Neste caso foi criado um fila com 5 elementos do tipo unsigned int 32 bits.
	 */
	if( ( xQueue_button = xQueueCreate( 5, sizeof( char * ) ) ) == NULL )
	{
		ESP_LOGI( TAG, "error - nao foi possivel alocar xQueue_button.\n" );
		/* app_main será finalizada e o programa finalizado */
		return;
	} 
	
	/* configMINIMAL_STACK_SIZE é um #define que informa para o FreeRTOS qual o tamanho mínimo
	necessário para rodar uma task. Por meio do menuconfig é possível saber o tamanho de configMINIMAL_STACK_SIZE; 
	*/
    if( ( xTaskCreate( task_blink, "task_blink", configMINIMAL_STACK_SIZE, NULL, 5, NULL )) != pdTRUE )
	{
		ESP_LOGI( TAG, "error - nao foi possivel alocar task_blink.\n" );	
		return;		
	}

	/**
	 * Task button;
	 */
	if( (xTaskCreate( task_button, "task_button", 2048, NULL, 5, NULL )) != pdTRUE )
	{
		ESP_LOGI( TAG, "error - nao foi possivel alocar task_button.\n" );	
		return;		
	}

	/*
	 * Task_print e task_button contém a função printf (ESP_LOGI). Portanto, foi aumentado o stack
	 * para 2k;
	 */
	if( (xTaskCreate( task_print, "task_print", 2048, NULL, 5, NULL )) != pdTRUE )
	{
		ESP_LOGI( TAG, "error - nao foi possivel alocar task_print.\n" );	
		return;		
	}

	
}





