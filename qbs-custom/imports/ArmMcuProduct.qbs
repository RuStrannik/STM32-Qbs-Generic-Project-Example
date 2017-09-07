import qbs
import qbs.FileInfo

Product {
	property string floatAbi: "-" // hard
	property string cpuName: "-" //cortex-m4
	property string fpuName: "-" //fpv4-sp-d16

	//type: "staticlibrary"
	//type: "application"
	//consoleApplication: true

	Depends { name: "cpp" }

	FileTagger {
		patterns: "*.ld"
		fileTags: ["linkerscript"]
	}


	cpp.optimization: undefined						// "none"
//	cpp.cLanguageVersion: "c11"
//	cpp.cxxLanguageVersion: "c++11"
//	cpp.optimization: "none"

	cpp.positionIndependentCode: false
	cpp.debugInformation: true
//	cpp.enableExceptions: false
//	cpp.enableRtti: false
//	cpp.enableReproducibleBuilds: true
//	cpp.treatSystemHeadersAsDependencies: false

//	cpp.positionIndependentCode: undefined			// false
//	cpp.debugInformation: undefined					// true
//	cpp.enableExceptions: undefined					// false
//	cpp.enableRtti: undefined						// false
//	cpp.enableReproducibleBuilds: undefined			// true
//	cpp.treatSystemHeadersAsDependencies: undefined	// false

//	cpp.commonCompilerFlags: [ "-Ofast", ]; // only for compiling (common for for C and C++ compilers)

	cpp.driverFlags: {
		base = [
			//"-x c",
			"-mcpu=" + cpuName,
			"-mfloat-abi=" + floatAbi,
			"-mthumb",
			"-std="+stdc,
			"-O"+optimization,
			"-mabi=aapcs",					// Generate code for the specified ABI. Permissible values are: ‘apcs-gnu’, ‘atpcs’, ‘aapcs’, ‘aapcs-linux’ and ‘iwmmxt’.
			//"-mno-sched-prolog",				// Prevent the reordering of instructions in the function prologue, or the merging of those instruction with the instructions in the function’s body. This means that all functions start with a recognizable set of instructions (or in fact one of a choice from a small set of different function prologues), and this information can be used to locate the start of functions inside an executable piece of code. The default is -msched-prolog.
			//"-mabort-on-noreturn",			// Generate a call to the function abort at the end of a noreturn function. It is executed if the function tries to return.
			"-ffunction-sections",				// for removing unused code in linker
			"-fdata-sections",					// for removing unused data in linker
			"-fno-strict-aliasing",
			"-fmessage-length=0",				// If n is zero, then no line-wrapping is done; each error message appears on a single line.
			"-fno-builtin",						// The ISO C90 functions abort, abs, acos, asin, atan2, atan, calloc, ceil, cosh, cos, exit, exp, fabs, floor, fmod, fprintf, fputs, frexp, fscanf, isalnum, isalpha, iscntrl, isdigit, isgraph, islower, isprint, ispunct, isspace, isupper, isxdigit, tolower, toupper, labs, ldexp, log10, log, malloc, memchr, memcmp, memcpy, memset, modf, pow, printf, putchar, puts, scanf, sinh, sin, snprintf, sprintf, sqrt, sscanf, strcat, strchr, strcmp, strcpy, strcspn, strlen, strncat, strncmp, strncpy, strpbrk, strrchr, strspn, strstr, tanh, tan, vfprintf, vprintf and vsprintf are all recognized as built-in functions unless -fno-builtin is specified (or -fno-builtin-function is specified for an individual function). All of these functions have corresponding versions prefixed with __builtin_.
			//"-specs=nosys.specs",
			//"-specs=nano.specs",
			//"-static",						// On systems that support dynamic linking, this prevents linking with the shared libraries. On other systems, this option has no effect.
			//"-nodefaultlibs",					// Do not use the standard system libraries when linking. Only the libraries you specify are passed to the linker, and options specifying linkage of the system libraries, such as -static-libgcc or -shared-libgcc, are ignored. The standard startup files are used normally, unless -nostartfiles is used.
												// The compiler may generate calls to memcmp, memset, memcpy and memmove. These entries are usually resolved by entries in libc. These entry points should be supplied through some other mechanism when this option is specified.
			"-Wdouble-promotion",				// Give a warning when a value of type float is implicitly promoted to double. CPUs with a 32-bit “single-precision” floating-point unit implement float in hardware, but emulate double in software. On such a machine, doing computations using double values is much more expensive because of the overhead required for software emulation.
			"-ggdb",							// or just -g debug output, compatible with GNU Debugger
			"-g3",								// level of debug
		];

		if (fpuName && typeof(fpuName) === "string") {
			base.push("-mfpu=" + fpuName);
		};
		//console.warn(name+": compiler flags: "+base);
		return base;
	}//driverFlags

	cpp.cxxFlags: [
	]

	cpp.linkerFlags: [
//		"-(",
//		"-lc",
//		"-lgcc",
//		"-lm",
//		//"-lpthread",
//		"-)",
		//"-pthread",
		"--gc-sections",
	]

}//Product

