
function getStdPeriphDeviceFamilyStr(productLine,deviceFamily,featureSetCode,flashSize) {
	var str="";
	if (productLine !== "STM32") throw new Error("Not an STM32 device!");
	if		  (deviceFamily === "F0") { // stm32f0xx.h, Line 108
		if		  (parseInt(featureSetCode) === 30) {
			if		  (flashSize ===  256) {
				str = "STM32F030xC";
			} else {
				str = "STM32F030";
			};//if(flash size)
		} else if (parseInt(featureSetCode) === 31) {
			str = "STM32F031";
		} else if (parseInt(featureSetCode) === 42) {
			str = "STM32F042";
		} else if (parseInt(featureSetCode) === 51) {
			str = "STM32F051";
		} else if (parseInt(featureSetCode) === 70) {
			if		  (flashSize ===  32) {
				str = "STM32F070x6";
			} else if (flashSize === 128) {
				str = "STM32F070xB";
			};//if(flash size)
		} else if (parseInt(featureSetCode) === 72) {
			str = "STM32F072";
		} else if (parseInt(featureSetCode) === 91) {
			str = "STM32F091";
		};//if (featureSetCode)
	} else if (deviceFamily === "F1") { // stm32f10x.h, Line 86
		if		  (parseInt(featureSetCode) ===  0) {
			if		  (flashSize >=  16 && flashSize <=  32) {
				str = "STM32F10X_LD_VL";
			} else if (flashSize >=  64 && flashSize <= 128) {
				str = "STM32F10X_MD_VL";
			} else if (flashSize >= 256 && flashSize <= 512) {
				str = "STM32F10X_HD_VL";
			};//if(flash size)
		} else if (parseInt(featureSetCode) <=   3) {
			if		  (flashSize >=  16 && flashSize <=   32) {
				str = "STM32F10X_LD";
			} else if (flashSize >=  64 && flashSize <=  128) {
				str = "STM32F10X_MD";
			} else if (flashSize >= 256 && flashSize <=  512 && parseInt(featureSetCode) !== 2) {
				str = "STM32F10X_HD";
			} else if (flashSize >  512 && flashSize <= 1024 && parseInt(featureSetCode) !== 2) {
				str = "STM32F10X_XD";
			};//if(flash size)
		} else if (parseInt(featureSetCode) <=   7) {
			str = "STM32F10X_CL";
		};//if (featureSetCode)
	} else if (deviceFamily === "F2") { // stm32f2xx.h, Line 73
		str = "STM32F2XX";
	} else if (deviceFamily === "F3") { // stm32f30x.h, Line 91
		if		  (parseInt(featureSetCode) ===  2) {
			str = "STM32F302x8";
		} else if (parseInt(featureSetCode) ===  3) {
			if		  (flashSize === 256) {
				str = "STM32F303xC";
			} else if (flashSize === 512) {
				str = "STM32F303xE";
			};//if(flash size)
		} else if (parseInt(featureSetCode) === 34) {
			str = "STM32F334x8";
		};//if (featureSetCode)
	} else if (deviceFamily === "F4") { // stm32f40x.h, Line 68
		switch (parseInt(featureSetCode)) {
			case 01:
			case 10:
			case 46: str = productLine+deviceFamily+featureSetCode+"xx"; break;
			case 11: str = productLine+deviceFamily+featureSetCode+"xE"; break;
			case 12: str = productLine+deviceFamily+featureSetCode+"xG"; break;
			case 27:
			case 37: str = "STM32F427_437xx"; break;
			case 29:
			case 39: str = "STM32F429_439xx"; break;
			case 69:
			case 79: str = "STM32F469_479xx"; break;
		};//switch(code)
		if ((str === "") && (parseInt(featureSetCode) < 20)) { str = "STM32F40_41xxx"; };
	} else if (deviceFamily === "L1") { // stm32l1xx.h, Line 98
		if		  (flashSize >=  32 && flashSize <= 128 ) { str = "STM32L1XX_MD";
		} else if (flashSize === 256					) { str = "STM32L1XX_MDP";
		} else if (flashSize === 384					) { str = "STM32L1XX_HD";
		} else if (flashSize === 512					) { str = "STM32L1XX_XL";
		};//if(flash size)
	};//else if(Family)
	if (str === "") { throw new Error("Unrecognized device description for STDPERIPH_DRIVER"); };
	return str;
};//function
