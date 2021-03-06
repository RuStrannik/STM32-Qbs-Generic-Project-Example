import qbs;

ArmMcuProduct {

	//Depends { name: "startup" }

	id: rtos
	name: "RTOS"
	type: "staticlibrary" // application // staticlibrary // dynamiclibrary // cppapplication
	cpuName: project.info.cpu
	fpuName: project.info.fpu
	floatAbi: project.info.floatAbi

	property bool useMPU: false
	property string MemMang: "1"
	property path rtosConfigFilePath: STM32ProjPath+"/src" // /FreeRTOSConfig.h
	property path rtoslibLocation: STM32SdkPlatformPath + "/FreeRTOS"
	property path rtoslibIncludePath: rtoslibLocation + "/include"
	property path rtoslibPortDir: {
		base = (cpuName.substr(0,1) + cpuName.substr(7,2)).toUpperCase(); //cortex-m4 -> CM4
		base = rtoslibLocation + "/portable/GCC/ARM_" + base;

		switch(parseInt(cpuName.substr(8,1))) {
			case 0:
			case 7: break;
			case 3: base += (useMPU)?"_MPU":""; break;
			case 4: base += (useMPU)?"_MPU":"F"; break;
			default: throw new Error("Unknown port! Please, configure your port directory manually.");
		};//switch()

		return base;
	}
	property pathList rtoslibFiles: {
		base.push(rtoslibLocation + "/*.c");
		base.push(rtoslibPortDir + "/*.c");
		base.push(rtoslibLocation + "/portable/MemMang/heap_"+MemMang+".c");
		if (useMPU) { base.push(rtoslibLocation + "/portable/common/*.c"); };
		return base;
	}

	property pathList rtoslibDeprecatedFiles: []


	Group {
		name: product.name + " Headers"
		files: [ rtoslibLocation + "/*.h", rtoslibPortDir + "/*.h", rtoslibIncludePath + "/*.h", rtosConfigFilePath + "/FreeRTOSConfig.h", ]
	}//Group

	Group {
		name: product.name + " Sources"
		files: rtoslibFiles
		excludeFiles: rtoslibDeprecatedFiles
	}//Group

	property pathList rtoslibIncludePaths: {
		base.push(rtoslibLocation);
		base.push(rtoslibPortDir);
		base.push(rtoslibIncludePath);
		base.push(rtosConfigFilePath);
		return base;
	}
	property stringList rtoslibDefines: []

	Export {
		Depends { name: "cpp" }
		cpp.includePaths: product.rtoslibIncludePaths
		cpp.defines: product.rtoslibDefines
	}

	cpp.includePaths: rtoslibIncludePaths
	cpp.defines: rtoslibDefines

}
