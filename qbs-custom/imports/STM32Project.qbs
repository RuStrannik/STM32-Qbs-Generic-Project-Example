import qbs
import qbs.FileInfo
import "STM32DeviceInfo.js" as STM32DeviceInfo

Project {

	id: proj
	minimumQbsVersion: "1.6"

	property string deviceName: "STM32X000XXX0"
	property variant info: STM32DeviceInfo.parse(deviceName)
	property string infoShort: info ? (info.productLine + info.deviceFamily).toLowerCase() : ""

	property path STM32ProjPath: ""
	property path STM32SdkPlatformPath: ""

	property int deviceHeapSize: undefined
	property string stdc: "c99"
	property string optimization: "0"; //fast

	property bool useStdPeriphDrv:		false
	property int  HSE_VALUE:			undefined // 8000000
	property int  HSE_STARTUP_TIMEOUT:	undefined // 0xFFFF
	property int  PLL_M:				undefined // (HSE_VALUE/1000000)
	property int  PLL_N:				undefined // 336
	property int  PLL_P:				undefined // 2
	property int  PLL_Q:				undefined // 7
}

