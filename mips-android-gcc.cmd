@echo off

setlocal
set SRCLOC=%~dp0

REM By default, 'nmake' is used
if "%OSMAND_BUILD_TOOL%"=="" (
	set OSMAND_BUILD_TOOL=nmake
)

set OSMAND_CROSSPLATFORM_TARGET=mips-android-gcc
"%SRCLOC%utils\%OSMAND_BUILD_TOOL%.cmd" %*

endlocal
