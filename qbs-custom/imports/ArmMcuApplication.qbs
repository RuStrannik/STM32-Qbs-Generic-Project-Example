import qbs
import qbs.FileInfo

ArmMcuProduct {

	cpuName: project.info.cpu
	fpuName: project.info.fpu
	floatAbi: project.info.floatAbi


	cpp.executableSuffix: ".out"

	Rule {
		id: hex
		inputs: ["application"]
		prepare: {
			var args = ["-O", "ihex", input.filePath, output.filePath];
			var cmd = new Command("arm-none-eabi-objcopy", args);
			cmd.description = "converting to hex: " + FileInfo.fileName(input.filePath);
			cmd.highlight = "linker";
			console.info(product.name + ": final linker flags: "+product.cpp.linkerFlags)
			return cmd;
		}
		Artifact {
			fileTags: ["hex"]
			filePath: FileInfo.baseName(input.filePath) + ".hex"
		}
	}//Rule

	Rule {
		id: bin
		inputs: ["application"]
		prepare: {
			var args = ["-O", "binary", input.filePath, output.filePath];
			var cmd = new Command("arm-none-eabi-objcopy", args);
			cmd.description = "converting to bin: "+ FileInfo.fileName(input.filePath);
			cmd.highlight = "linker";
			return cmd;
		}
		Artifact {
			fileTags: ["bin"]
			filePath: FileInfo.baseName(input.filePath) + ".bin"
		}
	}//Rule


	Rule { // Loading to Microcontroller
		id: load
		inputs: ["bin"]
		condition: product.PerformFlash === true; //qbs.buildVariant == "release"//"debug"//
//		alwaysRun: true
		prepare: {
			var args = ["-C",										// connect
						"SWD",										// using SWD (Serial Wire Interface)
						"UR",										// under target reset
						"LPM",										// debug in Low Power mode
						"-Q",										// Enable quiet mode. No progress bar displayed
						"-P", input.filePath, "0x08000000",			// Load a into device. Syntax: -P <File_Path> [<Address>]
						"-V", "while_programming",					// Verify if the programming operation was performed successfully Syntax: -V <while_programming/after_programming>
						"-Rst",										// System reset
//						"-HardRst",									// Hardware reset
//						"-TVolt",									// Display target voltage
						];
			var cmd = new Command("d:/Programs/ST-LINK Utility/ST-LINK Utility/ST-LINK_CLI.exe", args);
			cmd.description = "Flashing: "+ input.filePath;
			cmd.highlight = "linker";
			return cmd;
		}
		Artifact {
			fileTags: ["load"]
			filePath: FileInfo.baseName(input.filePath) + ".load"
		}
	}//Rule

	Rule { // Reset Microcontroller
		id: reset
		inputs: ["load"]
//		inputs: ["bin"]
		condition: product.PerformExtraReset === true; //qbs.buildVariant == "release"//"debug"//
//		condition: qbs.buildVariant == "release"//"debug"//
//		alwaysRun: true
		prepare: {
			var args = ["-Rst"]; // Cannot use -HardRst: it works too quickly
			var cmd = new Command("d:/Programs/ST-LINK Utility/ST-LINK Utility/ST-LINK_CLI.exe", args);
			cmd.description = "Resetting: "+ input.filePath;
			cmd.highlight = "linker";
			return cmd;
		}
		Artifact {
			fileTags: ["reset"]
			filePath: "reset"
		}
	}//Rule


	Rule {
		multiplex: true
		id: size
		inputs: ["application", "load"]
		alwaysRun: true
		prepare: {
			var args = [ FileInfo.path(output.filePath) + "/*"+ product.cpp.executableSuffix, ];
			var cmd = new Command("arm-none-eabi-size", args);
			cmd.description = "File size: " + FileInfo.fileName(output.filePath);
			cmd.highlight = "linker";
			//console.warn("size: "+input.filePath);
			return cmd;
		}
		Artifact {
			fileTags: ["size"]
			filePath: "size"
		}
	}//Rule

	Group {	 // Properties for the produced executable
		fileTagsFilter: ["hex", "bin"] // product.type
		qbs.install: true
	}
}//ArmMcuProduct

