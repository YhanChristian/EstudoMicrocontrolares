
/**
  ******************************************************************************
  * @Company    : Yhan Christian Souza Silva MEI
  * @file       : yc_drv_gpio.c
  * @author     : Name of author
  * @version	: version of driver, API or application files 
  * @date       : Data of the file was created
  * @brief      : What this file does
  ******************************************************************************
*/ 
#ifdef GPIO_ENABLED

/* Includes ------------------------------------------------------------------*/ 
// C language standard library
// Eder Andrade driver library
#include "yc_drv_gpio.h"
// Application

/*******************************************************************************
	HOW TO USE THIS DRIVER
********************************************************************************

1. 	First, you should include in your .c file: "company_name_drv_gpio.h" and call GPIO object,
	after that, you can use the follow resources of the driver

	- GPIO: this is the object that will control the peripheral;	

	Data -----------------------------------------------------------------------

	- GPIO.FlagEnable	===================> It informs if GPIO driver is enabled
	- GPIO.State[x]	===================> Stores the state of a specific pin

	Methods --------------------------------------------------------------------

	- GPIO.Open() =========================> Initializes the GPIO driver;
	- GPIO.Close() ========================> Finishes the GPIO driver;
	- GPIO.Write() ========================> Writes "0" or "1" on a specific pin
	- GPIO.Read() =========================> Read the state of a specific pin

*******************************************************************************/

/* Private define ------------------------------------------------------------*/
/* Private macros ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/

/* Private variables ---------------------------------------------------------*/
const static st_gpio_pin_t IO[NUM_OF_IOS] = 
{
	{LED_Port, LED_Pin},	
        {BUTTON_Port, BUTTON_Pin},

};

/* Private function prototypes -----------------------------------------------*/    
static int8_t   yc_gpio_open   (void);			        // Initialize the peripheral
static int8_t   yc_gpio_close  (void);                          // Close the peripheral
static int8_t   yc_gpio_write  (e_gpio_t, GPIO_PinState);  	// Write (0 or 1) on a specific pin
static int8_t   yc_gpio_read   (e_gpio_t);             	        // Read state of a specific pin

/* Public objects ------------------------------------------------------------*/
st_gpio_t GPIO = 
{
    /* Peripheral disabled ****************************************************/
    .FlagEnable	        = RESET,
    
    /* All pins are reseted ***************************************************/
    .State[eLed]        = GPIO_PIN_RESET,
    .State[eButton]     = GPIO_PIN_RESET,
    
    /* Function pointers loaded ***********************************************/
    .Open   				= &yc_gpio_open,
    .Close  				= &yc_gpio_close,
    .Write  				= &yc_gpio_write,
    .Read   				= &yc_gpio_read
    
};

/* Body of private functions -------------------------------------------------*/

/**
  * @Func       : EXTI15_10_IRQHandler    
  * @brief      : This function handles EXTI line[15:10] interrupts.
  * @pre-cond.  : ea_gpio_open() must be called first
  * @post-cond. : Attends interrupts and invoke callbacks if it's enabled
  * @parameters : void
  * @retval     : void
  */
void EXTI15_10_IRQHandler(void)
{
  /* USER CODE BEGIN EXTI15_10_IRQn 0 */

  /* USER CODE END EXTI15_10_IRQn 0 */
  HAL_GPIO_EXTI_IRQHandler(GPIO_PIN_13);
  /* USER CODE BEGIN EXTI15_10_IRQn 1 */

  /* USER CODE END EXTI15_10_IRQn 1 */
}

/**
  * @Func       : HAL_GPIO_EXTI_Callback    
  * @brief      : It is invoked when a hardware event occurred
  * @pre-cond.  : ea_gpio_open() must be called first
  * @post-cond. : Callback related to hardware event is attended 
  * @parameters : Pin configured for external hardware interrupt 
  * @retval     : Void
  */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{

  /* NOTE: This function Should not be modified, when the callback is needed,
           the HAL_GPIO_EXTI_Callback could be implemented in the user file
   */
}

/**
  * @Func       : ea_gpio_open    
  * @brief      : Initializes GPIO peripheral
  * @pre-cond.  : System Clock Config must be called first
  * @post-cond. : All GPIOs and its related sources clocks are enabled
  * @parameters : void 
  * @retval     : int8_t -> (value == 0) = OK; (value < 0) = ERROR
  */
static int8_t yc_gpio_open(void)
{
  // Clear the GPIO struct
  GPIO_InitTypeDef GPIO_InitStruct = {0};
  
  /* Enabling port clock ****************************************************/	
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();
  
  /* Clear all ports ********************************************************/  
  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(LED_Port, LED_Pin, GPIO_PIN_RESET);
  
  /* Configuring all pins as analog because consuming less current **********/ 
    /*Configure GPIO pins : PC0 PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 PC11 PC12 */
    GPIO_InitStruct.Pin =   GPIO_PIN_0 |
                            GPIO_PIN_1 |
                            GPIO_PIN_2 |
                            GPIO_PIN_3 |
                            GPIO_PIN_4 |
                            GPIO_PIN_5 |
                            GPIO_PIN_6 |
                            GPIO_PIN_7 |
                            GPIO_PIN_8 |
                            GPIO_PIN_9 |
                            GPIO_PIN_10|
                            GPIO_PIN_11|
                            GPIO_PIN_12;
    GPIO_InitStruct.Mode =  GPIO_MODE_ANALOG;
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

    /*Configure GPIO pins : PA1 PA4 PA6 PA7 PA8 PA9 PA10 PA11 PA12 PA15 */
    GPIO_InitStruct.Pin  =  GPIO_PIN_1 |
                            GPIO_PIN_4 |
                            GPIO_PIN_6 |
                            GPIO_PIN_7 |
                            GPIO_PIN_8 |
                            GPIO_PIN_9 |
                            GPIO_PIN_10|
                            GPIO_PIN_11|
                            GPIO_PIN_12|
                            GPIO_PIN_15;
    GPIO_InitStruct.Mode =  GPIO_MODE_ANALOG;
    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

    /*Configure GPIO pins : PB0 PB1 PB2 PB10 PB11 PB12 PB13 PB14 PB15 PB4 PB5 PB6 PB7 PB8 PB9 */
    GPIO_InitStruct.Pin  =  GPIO_PIN_0 |
                            GPIO_PIN_1 |
                            GPIO_PIN_2 |
                            GPIO_PIN_10|
                            GPIO_PIN_11|
                            GPIO_PIN_12|
                            GPIO_PIN_13|
                            GPIO_PIN_14|
                            GPIO_PIN_15|
                            GPIO_PIN_4 |
                            GPIO_PIN_5 |
                            GPIO_PIN_6 |
                            GPIO_PIN_7 |
                            GPIO_PIN_8 |
                            GPIO_PIN_9;
    GPIO_InitStruct.Mode =  GPIO_MODE_ANALOG;
    HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
  
  /* OUTPUTS FIRST **********************************************************/
  /*Configure GPIO pin : LED_Pin */
  GPIO_InitStruct.Pin     = LED_Pin;
  GPIO_InitStruct.Mode    = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull    = GPIO_NOPULL;
  GPIO_InitStruct.Speed   = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(LED_Port, &GPIO_InitStruct);
  
  /* INPUTS *****************************************************************/
  /*Configure GPIO pin : BUTTON_Pin */
  GPIO_InitStruct.Pin     = BUTTON_Pin;
  GPIO_InitStruct.Mode    = GPIO_MODE_IT_RISING;
  GPIO_InitStruct.Pull    = GPIO_NOPULL;
  HAL_GPIO_Init(BUTTON_Port, &GPIO_InitStruct);
  
  /* INTERRUPTS *************************************************************/
  /* BUTTON EXTI interrupt init*/
  HAL_NVIC_SetPriority(BUTTON_EXTI_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(BUTTON_EXTI_IRQn);
  
  // Enabling GPIO peripheral
  GPIO.FlagEnable = SET;
  
  // GPIO enabled!
  return 0;	
  
}

/**
  * @Func       : yc_gpio_close    
  * @brief      : Disable all GPIO ports
  * @pre-cond.  : ea_gpio_open() must be called first
  * @post-cond. : All GPIOs and its related sources clocks are disabled
  * @parameters : void 
  * @retval     : int8_t -> (value == 0) = OK; (value < 0) = ERROR
  */
static int8_t yc_gpio_close(void)
{
  // Check if GPIO was enabled
  if(GPIO.FlagEnable)
  {            
    // Clean up the pin state vector
    for(uint8_t i = 0; i < NUM_OF_IOS; i++)
    {
      // Reset the values
      GPIO.State[i] = GPIO_PIN_RESET;
    }        
    
    // Clear all ports
    HAL_GPIO_DeInit(GPIOA, GPIO_PIN_All);
    HAL_GPIO_DeInit(GPIOB, GPIO_PIN_All);
    HAL_GPIO_DeInit(GPIOC, GPIO_PIN_All);
    HAL_GPIO_DeInit(GPIOD, GPIO_PIN_All);
    HAL_GPIO_DeInit(GPIOE, GPIO_PIN_All);
    
    // IOs disable
    GPIO.FlagEnable = RESET; 		
    
    // OK
    return 0;
  }
  // GPIO is disabled
  return -1;
}

/**
  * @Func       : yc_gpio_write    
  * @brief      : Write on a specific port and pin
  * @pre-cond.  : ea_gpio_open() must be called first
  * @post-cond. : Set/reset specific pin and its value is stored
  * @parameters : eHw       -> pin to be write / clear
  * @parameters : bValue    -> RESET or SET 
  * @retval     : int8_t    -> (value == 0) = OK; (value < 0) = ERROR
  */
static int8_t yc_gpio_write(e_gpio_t eHw, GPIO_PinState Value)
{    
  // Check if GPIO is enabled
  if(GPIO.FlagEnable)
  {        
    // Verifies which action is gonna happens
    if((Value == GPIO_PIN_SET) || (Value == GPIO_PIN_RESET))
    {
      if(eHw == eLed)
      {
        // Set/reset pin            
        HAL_GPIO_WritePin(IO[eHw].port, (uint16_t)IO[eHw].pin, Value);
        // HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, Value);
      }
      else
      {
        // It is not a output!
        return -1;
      }
    }       
    else
    {
      // Some other value different of "0" or "1" was passed 
      return -2;
    }
    // Update the state of pin chosen
    GPIO.State[eHw] = Value;				
    // OK
    return 0;		
  }
  // GPIO is disabled
  return -3;  
}

/**
  * @Func       : yc_gpio_read    
  * @brief      : Read the state of a specific pin
  * @pre-cond.  : ea_gpio_open() must be called first
  * @post-cond. : Specific pin informed is readed and its state is stored
  * @parameters : eHw - specific pin
  * @retval     : state of pin : RESET or SET 
  */
static int8_t yc_gpio_read(e_gpio_t eHw)
{        
  // Check if GPIO was enabled
  if(GPIO.FlagEnable)
  {
    // Load the buffer with value of pin specified
    GPIO.State[eHw] = HAL_GPIO_ReadPin(IO[eHw].port, (uint16_t)IO[eHw].pin);
    
    // retun the state
    return GPIO.State[eHw];
  }
  // GPIO is disabled
  return -1;
}
#endif /* GPIO_ENABLED <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/

/*****************************END OF FILE**************************************/