# STM32 Generic Qbs Project
#### Allows you compile and link an STM32 application, which uses Standard Peripheral Driver Library, in 1 click with minimal configuration time.
Recommended STM32 library folder structure:
```
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
```
