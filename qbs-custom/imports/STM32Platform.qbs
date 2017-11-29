import qbs;
import qbs.File
import qbs.FileInfo
import qbs.ModUtils
//import qbs.Environment
//import qbs.PathTools
//import qbs.Utilities
import "STM32PlatformInfo.js" as STM32PlatformInfo

ArmMcuProduct {

	id: startup;
	name: "generic platform startup";
	type: "staticlibrary"

	cpuName: project.info.cpu;
	fpuName: project.info.fpu;
	floatAbi: project.info.floatAbi;
	property string devFamilyStr:  project.info.deviceFamily + ((project.info.deviceFamily === "F1" || project.info.deviceFamily === "F3")?"0x":"xx");

	property stringList usedPeriph: [
			"adc",			"exti",				"pwr",
			"can",			"flash",			"qspi",
			"cec",			"flash_ramfunc",	"rcc",
			"crc",			"fmc",				"rng",
			"cryp",			"fmpi2c",			"rtc",
			"cryp_aes",		"fsmc",				"sai",
			"cryp_des",		"gpio",				"sdio",
			"cryp_tdes",	"hash",				"spdifrx",
			"dac",			"hash_md5",			"spi",
			"dbgmcu",		"hash_sha1",		"syscfg",
			"dcmi",			"i2c",				"tim",
			"dfsdm",		"iwdg",				"usart",
			"dma",			"lptim",			"wwdg",
			"dma2d",		"ltdc",				"dsi",
									];

	property path cmsisLocation: STM32SdkPlatformPath + "/CMSIS";
	property path cmsisIncludePath: cmsisLocation + "/Include";
	property pathList cmsisExcludeSources: [];

	property path deviceFilesLocation: cmsisLocation + "/Device/ST/" + info.productLine + devFamilyStr;
	property path deviceFilesIncludePath: deviceFilesLocation + "/Include";

	property path deviceDriversFilesLocation: ((useStdPeriphDrv) ? STM32SdkPlatformPath + "/" + info.productLine + devFamilyStr + "_StdPeriph_Driver" : printing.shError("If you're not using STM32 Standard Peripheral Drivers, please implement includes of your drivers here."));
	property path deviceDriversFilesIncludePath: deviceDriversFilesLocation + "/inc";
	property path deviceDriversFilesSourcePath: deviceDriversFilesLocation + "/src";

	property path deviceLinkerScript: STM32ProjPath + "/config/" + info.productLine + info.deviceFamily + info.featureSetCode + "*.ld";
	property path deviceStartupScript: deviceFilesLocation + "/Source/Templates/gcc_ride7/startup_" + STM32PlatformInfo.getStdPeriphDeviceFamilyStr(info.productLine,info.deviceFamily,info.featureSetCode,info.flashSize) + ".s";

	property stringList deviceDefines: {
		console.warn(deviceName+" Info: Family=["+info.productLine+"], Type=["+info.deviceFamily+"] ("+info.cpu+", FP=["+info.fpu+"]), FeatureSetCode=["+info.featureSetCode+"], Flash=["+info.flashSize+"KB], Body=["+info.deviceBody+"], TempRange=["+info.deviceTempRange+"]");
		if (deviceHeapSize > 0) base.push("__HEAP_SIZE=" + String(deviceHeapSize));
		if (useStdPeriphDrv) {
			base.push("USE_STDPERIPH_DRIVER=1");
			base.push(STM32PlatformInfo.getStdPeriphDeviceFamilyStr(info.productLine,info.deviceFamily,info.featureSetCode,info.flashSize));
			if (HSE_VALUE !== undefined) base.push("HSE_VALUE="+HSE_VALUE);
			if (HSE_STARTUP_TIMEOUT !== undefined) base.push("HSE_STARTUP_TIMEOUT="+HSE_STARTUP_TIMEOUT);
			if (PLL_M !== undefined) base.push("PLL_M="+PLL_M);
			if (PLL_N !== undefined) base.push("PLL_N="+PLL_N);
			if (PLL_P !== undefined) base.push("PLL_P="+PLL_P);
			if (PLL_Q !== undefined) base.push("PLL_Q="+PLL_Q);
		};//if(useStdPeriphDrv)
		console.info(name + ": base defines: "+base);
		return base;
	}

	property pathList deviceIncludePaths: {
		base.push(STM32SdkPlatformPath);
		base.push(cmsisIncludePath);
		base.push(deviceFilesIncludePath);
		base.push(deviceDriversFilesIncludePath);
		console.info(name+": base includes: "+base);
		return base;
	}

	property pathList startupFiles: {
		base.push(deviceStartupScript);
		console.info(name + ": base startup: "+base);
		return base;
	}

	property string infoShortUpperCase: infoShort.toUpperCase()

	Group {
		id: linkerScripts
		name: product.infoShortUpperCase + " Linker Scripts"
		files: product.deviceLinkerScript
	}

	Group {
		name: product.infoShortUpperCase + " Startup files"
		files: product.startupFiles
	}

	Group {
		name: product.infoShortUpperCase + " Headers"
		files: [ product.deviceFilesIncludePath + "/*.h", product.deviceConfigFilePath + "/*.h", ]
	}

	Group {
		name: product.infoShortUpperCase + " Driver headers"
		files: [ product.deviceDriversFilesIncludePath + "/*.h" ]
	}
	Group {
		name: product.infoShortUpperCase + " Driver Sources"
		files: {
			base.push(product.cmsisIncludePath + "/*.c");
			base.push(deviceDriversFilesSourcePath + "/" + "misc.c");
			for (i=0; ((usedPeriph[i] !== undefined) && (i<100)); ++i) {
				base.push(deviceDriversFilesSourcePath + "/" + (product.info.productLine + devFamilyStr).toLowerCase() + "_" + usedPeriph[i] + ".c");
			};
			return base;
		}
	}


	Group {
		name: "CMSIS Headers"
		files: [
			product.cmsisIncludePath + "/*.h"
		]
	}
	Group {
		name: "CMSIS Sources"
		files: [
			product.deviceFilesLocation + "/Source/Templates/*.c",
		]
		excludeFiles: product.cmsisExcludeSources
	}


	cpp.includePaths: deviceIncludePaths;
	cpp.defines: deviceDefines;

	Export {
		Depends { name: "cpp" }
		cpp.includePaths: product.deviceIncludePaths;
		cpp.defines: product.deviceDefines;
		cpp.linkerFlags: {
			base.push("-T" + product.deviceLinkerScript);
			console.info(product.name+": base linker script: "+base);
			return base;
		}
	}


}
