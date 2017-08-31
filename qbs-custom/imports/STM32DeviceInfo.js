
function cpuName(productLine, deviceFamily) {
	switch (productLine) {
		case "STM32":
			break;
		default:
			throw new Error("Unsupported product line.");
	}
	switch (deviceFamily) {
		case "F0":
			return "cortex-m0";
		case "L0":
		case "ZG":
		case "HG":
			return "cortex-m0plus";
		case "F1":
		case "F2":
		case "L1":
		case "W":
			return "cortex-m3";
		case "WG":
		case "PG":
		case "F3":
		case "F4":
		case "L4":
		case "J":
			return "cortex-m4";
		case "F7":
		case "H7":
			return "cortex-m7";
		default:
			throw new Error("Unsupported device family.");
	}

}

function ioNum(io) {
	switch (io) {
		case "A": return 169;
		case "B": return 208;
		case "C": return 48;
		case "F": return 20;
		case "G": return 28;
		case "H": return 40;
		case "I": return 176;
		case "J": return 72;
		case "K": return 32;
		case "M": return 81;
		case "N": return 216;
		case "O": return 90;
		case "Q": return 132;
		case "R": return 64;
		case "T": return 36;
		case "U": return 63;
		case "V": return 100;
		case "Z": return 144;
		default: return undefined;
	}
}

function flashSize(num) {
	switch (num) {
		case "4": return 16;
		case "6": return 32;
		case "8": return 64;
		case "B": return 128;
		case "Z": return 192;
		case "C": return 256;
		case "D": return 384;
		case "E": return 512;
		case "F": return 768;
		case "G": return 1024;
		case "H": return 1536;
		case "I": return 2048;
		default: return undefined;
	}
}

function bodyType(bt) {
	switch (bt) {
		case "H": return "UFBGA";
		case "N": return "TFBGA";
		case "P": return "TSSOP";
		case "T": return "LQFP";
		case "U": return "V/UFQFPN";
		case "Y": return "WLCSP";
		default: return undefined;
	}
}

function tempRange(t) {
	switch (t) {
		case "6": return "-40..+85°C";
		case "7": return "-40..+105°C";
		default: return undefined;
	}
}

function fpuName(cpu) {
	switch (cpu) {
	case "cortex-m4":
		return "fpv4-sp-d16";
	default:
		return undefined;
	}
}

function parse(deviceName) {

	if (typeof(deviceName) !== "string") {
		throw new Error("deviceName should be a string, but isn't.");
	}

	var regex = new RegExp("([A-Z]{3}32)(F[0-9])([0-9]{2})([A-Z])([A-Z0-9])([A-Z])([0-9])", "i");
	var arr = deviceName.match(regex);

//	arr = "STM32F429ZIT6".match(regex);

	if (arr === null) {
		throw new Error("deviceName could not be parsed.");
	}
	if (arr.index !== 0) {
		throw new Error("deviceName is invalid, contains invalid characters.");
	}

	var cpu = cpuName(arr[1], arr[2]);
	var fpu = fpuName(cpu);
	var floatAbi = fpu ? "hard" : "soft";

	//throw new Error(deviceName+": Family: ["+arr[1]+"], Type: ["+arr[2]+"] ("+cpu+", "+fpu+"), FeatureSetCode: ["+arr[3]+"], Flash: ["+flashSize(arr[5])+"KB], Body: ["+bodyType(arr[6])+ioNum(arr[4])+"], TempRange: ["+tempRange(arr[7])+"]");

	return {
		productLine: arr[1],
		deviceFamily: arr[2],
		featureSetCode: arr[3],
		deviceIONum: ioNum(arr[4]),
		flashSize: flashSize(arr[5]),
		deviceBody: bodyType(arr[6])+ioNum(arr[4]),
		deviceTempRange: tempRange(arr[7]),
		cpu: cpu,
		fpu: fpu,
		floatAbi: floatAbi
	};
}

function parseRadioType(radio) {
	if (typeof(radio) === "undefined") {
		return undefined;
	}

	if (typeof(radio) !== "string" || radio.length !== 4) {
		throw new Error("Invalid radio type specified. Should be like 4455, 4467, etc.");
	}

	var commonInc;
	var deviceInc;

	if (radio.startsWith("445")) {
		commonInc = "4x55";
		deviceInc = "4455";
	}
	else if (radio.startsWith("446")) {
		commonInc = "4x6x";
		if (radio.endsWith("7") || radio.endsWith("8"))
			deviceInc = "4468";
		else
			deviceInc = "4460";
	}
	else {
		throw new Error("Unknown radio type. Should be like 4455, 4467, etc.");
	}

	return {
		commonInc: commonInc,
		deviceInc: deviceInc
	};
}

