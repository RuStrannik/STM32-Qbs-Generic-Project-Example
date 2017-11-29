/*

Recommended library folder structure:

STM32/library
 ├─CMSIS
 │  ├─Device
 │  │  └─ST
 │  │    └─STM32F4xx
 │  │      ├─Include
 │  │      └─Source
 │  │        └─Templates
 │  │          └─gcc_ride7
 │  └─Include
 ├─FreeRTOS_9.0.0
 │  ├─include
 │  └─portable
 │    ├─Common
 │    ├─GCC
 │    │  └─ARM_CM4F
 │    └─MemMang
 └─STM32F4xx_StdPeriph_Driver
   ├─inc
   └─src
*/



#include "stm32f4xx.h"
#include "stm32f4xx_rcc.h"
#include "stm32f4xx_gpio.h"

#include "FreeRTOS.h"
#include "task.h"

// Good for STM32F4 Discovery Board
#define LED_GREEN		GPIO_Pin_12
#define LED_ORANGE		GPIO_Pin_13
#define LED_RED			GPIO_Pin_14
#define LED_BLUE		GPIO_Pin_15
#define LED_ALL			LED_GREEN | LED_RED | LED_ORANGE | LED_BLUE

#define LedOn(led)		(GPIOD->BSRRL = led)
#define LedOff(led)		(GPIOD->BSRRH = led)
#define LedTog(led)		(GPIOD->ODR  ^= led)


void InitAll(void) {

	SystemCoreClockUpdate();

	GPIO_InitTypeDef GPIO_InitStruct;

	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);

	GPIO_InitStruct.GPIO_Pin = LED_ALL;
	GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_InitStruct.GPIO_Speed = GPIO_Speed_100MHz;

	GPIO_Init(GPIOD, &GPIO_InitStruct);

}//InitAll()

void Task_Blinky (void* par) {

	for (;;) {
		LedTog(LED_GREEN);
		vTaskDelay(500);
	};//inf loop

};//Task_Blinky()

int main(void) {

	InitAll();

	LedOn(LED_BLUE);


	xTaskCreate(Task_Blinky,	"BLNK",		1*configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);

	vTaskStartScheduler();

	// Normally, should never get here
	for (int i=0;;++i) {
		if (i >= 1000000) { i=0; LedTog(LED_RED); };
	};//inf loop

}//main()


