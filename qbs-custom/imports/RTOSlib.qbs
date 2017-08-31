import qbs;

ArmMcuProduct {

	//Depends { name: "startup" }

	id: rtos
	name: "RTOS"
	cpuName: info.cpu
	fpuName: info.fpu
	floatAbi: info.floatAbi

	property bool useMPU: false
	property string MemMang: "1"
	property path rtosConfigFilePath: STM32ProjPath+"/src" // /FreeRTOSConfig.h
	property path rtoslibLocation: STM32SdkPlatformPath + "/FreeRTOS"
	property path rtoslibIncludePath: rtoslibLocation + "/include"
	property pathList rtoslibFiles: {
		base.push(rtoslibLocation + "/*.c");
		base.push(rtoslibLocation + "/MemMang/heap_"+MemMang+".c");
		if (useMPU) { base.push(rtoslibLocation + "/MPU/*.c"); };
		return base;
	}

	property pathList rtoslibDeprecatedFiles: {
		if (useMPU) { base.push(rtoslibLocation + "/port.c"); };
		if (useMPU) { base.push(rtoslibLocation + "/portmacro.h"); };
		return base;
	}


	Group {
		name: product.name + " Headers"
		files: [ rtoslibLocation + "/*.h", rtoslibIncludePath + "/*.h", rtosConfigFilePath + "/*.h", ]
	}//Group

	Group {
		name: product.name + " Sources"
		files: rtoslibFiles
		excludeFiles: rtoslibDeprecatedFiles
	}//Group

	property pathList rtoslibIncludePaths: {
		base.push(rtoslibLocation);
		base.push(rtoslibIncludePath);
		base.push(rtosConfigFilePath);
		if (useMPU) { base.push(rtoslibLocation + "/MPU"); };
		return base;
	}
	property stringList rtoslibDefines: []

	Export {
		Depends { name: "cpp" }
		//Depends { name: "startup" }
		cpp.includePaths: product.rtoslibIncludePaths
		cpp.defines: product.rtoslibDefines
	}

	cpp.includePaths: rtoslibIncludePaths
	cpp.defines: rtoslibDefines

}
