import qbs
import qbs.FileInfo

import "qbs-custom/imports/STM32Project.qbs" as STM32Project
import "qbs-custom/imports/STM32Platform.qbs" as STM32Platform
import "qbs-custom/imports/STM32Application.qbs" as STM32Application
import "qbs-custom/imports/RTOSlib.qbs" as RTOS

STM32Project {

	name: "MyProject"
	deviceName: "STM32F407VGT6" // Required full name of the MCU in STM32X000XXX0 format, it is always printed on the chip surface
	HSE_VALUE: 8000000 // Hz

	STM32ProjPath: path
	STM32SdkPlatformPath: STM32ProjPath+"/library"

	stdc: "gnu11"
	optimization: "3"; //fast

	deviceHeapSize: 0
	useStdPeriphDrv: true

		STM32Platform {
			name: "STM32F4_Platform_Lib";
			usedPeriph: [ "gpio","rcc", ];
			deviceIncludePaths: [STM32ProjPath + "/config", ].concat(base);
			deviceLinkerScript: STM32ProjPath + "/config/STM32F407VG_FLASH.ld";
		}//STM32Startup

		RTOS {
			name: "FreeRTOS_900_Lib";
			rtosConfigFilePath: STM32ProjPath+"/config";
			rtoslibLocation: STM32SdkPlatformPath + "/FreeRTOS_9.0.0";
		}//RTOS

		STM32Application {
			name: "MyApp"

			Depends { name: "cpp"; }
			Depends { name: "STM32F4_Platform_Lib";	required: true; }
			Depends { name: "FreeRTOS_900_Lib";		required: true; }

			Group {
				name: "Sources"
				files: [ "src/*.c", ]
				excludeFiles: []
			}//Group

			Group {
				name: "Headers"
				files: [ "src/*.h", ]
				excludeFiles: []
			}//Group

			cpp.defines: [
			]

			cpp.staticLibraries: [
				"c",
				"m",
				"gcc",
				"nosys",
			]

			cpp.linkerFlags: [
				"-Map="+project.STM32ProjPath+"/output.map",
			].concat(base)
		}//STM32Application
//	}//Project
}//MCB Project



