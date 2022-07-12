// Bibliotecas Auxiliares

#include "stm32f1xx.h"

// Protótipos de Funções Auxiliares

void gpio_config(void);
void delay_ms(uint32_t time);

// Função Main

int main()
{
    //Init Gpio 
    gpio_config();

    // Blink LED (loop)
    while (1)
    {
        /*!< XOR - Port output data, bit 13 */
        GPIOC->ODR ^= GPIO_ODR_ODR13;
        delay_ms(1E6);
    }
}

// Funções Auxiliares

void gpio_config(void)
{
    /*!< I/O port C clock enable */
    RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;
    /*! <I/O Fast Output */
    GPIOC->CRH |= GPIO_CRH_MODE13_0 | GPIO_CRH_MODE13_1;
    /*! <Config Push Pull */
    GPIOC->CRH &= ~(GPIO_CRH_CNF13_0 | GPIO_CRH_CNF13_1);
    /*! <Logic Level = 1 (Led Off) */
    GPIOC->ODR |= GPIO_ODR_ODR13;
}

void delay_ms(uint32_t time)
{
    while(time--)
    {
        __NOP();
        __NOP();
        __NOP();
    }
}