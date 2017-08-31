import qbs
import qbs.FileInfo

Product {
	property string floatAbi: "-" // hard
	property string cpuName: "-" //cortex-m4
	property string fpuName: "-" //fpv4-sp-d16

	//property script validate: { true; }

	type: "staticlibrary"

	Depends { name: "cpp" }

	FileTagger {
		patterns: "*.ld"
		fileTags: ["linkerscript"]
	}

//	cpp.cLanguageVersion: "c11"
//	cpp.cxxLanguageVersion: "c++11"
	cpp.optimization: undefined//"none"
	cpp.positionIndependentCode: false
	cpp.debugInformation: true
	cpp.enableExceptions: false
	cpp.enableRtti: false
	cpp.enableReproducibleBuilds: true
	cpp.treatSystemHeadersAsDependencies: false

	cpp.staticLibraries: [
		"c",
		"m",
		"gcc",
		"nosys",
	]

	cpp.driverFlags: {
		var arr = [
					"-std="+stdc,
					"-O"+optimization,
					"-mcpu=" + cpuName,
					"-mfloat-abi=" + floatAbi,
					"-mthumb",
					"-mabi=aapcs",
					"-mno-sched-prolog",
					"-mabort-on-noreturn",
					"-fdata-sections",
					"-ffunction-sections",
					"-fno-strict-aliasing",
					"-fno-builtin",
					"-specs=nosys.specs",
					"-specs=nano.specs",
					"-static",
					"-nodefaultlibs",
					"-Wdouble-promotion",			// Give a warning when a value of type float is implicitly promoted to double. CPUs with a 32-bit “single-precision” floating-point unit implement float in hardware, but emulate double in software. On such a machine, doing computations using double values is much more expensive because of the overhead required for software emulation.
					"-ggdb",
					"-g3",
				];

		if (fpuName && typeof(fpuName) === "string") {
			arr.push("-mfpu=" + fpuName);
		}

		return arr;
	}//driverFlags

	cpp.cxxFlags: [
	]

	cpp.linkerFlags: [
		"-(",
		"-lm",								// specify the math library for searching.
		"-lc",
		"-lgcc",
		"-)",
		"--gc-sections",
	]

}//Product

