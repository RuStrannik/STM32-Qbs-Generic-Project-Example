<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body>

<center><h1>STM32 Generic Qbs Project</h1></center>
<br><h3>Allows you to compile and link an STM32 application (which uses Standard Peripheral Driver Library) in 1 click with minimal configuration time.</h3>
Recommended STM32 library folder structure:
<pre>STM32/library
 ├─CMSIS
 │  ├─Device/ST/STM32F4xx/
 │  │  ├─Include
 │  │  └─Source/Templates/gcc_ride7
 │  └─Include
 ├─FreeRTOS_9.0.0
 │  ├─include
 │  ├─MemMang
 │  └─MPU
 └─STM32F4xx_StdPeriph_Driver
    ├─inc
    └─src
</pre>

</body>
</html>