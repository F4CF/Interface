@ECHO off
setlocal EnableDelayedExpansion

REM Variables
REM ===========================================================
SET EXE=E:\Software\Adobe\Flash\JPEXS\9.0.0\ffdec.bat
SET OutputDirectory=D:\Games\Steam\SteamApps\common\Fallout 4\Mods\FO4 Interface\Commands\Output\Decompiled

REM Command Interface
REM ===========================================================
CD /D "D:\Games\Steam\SteamApps\common\Fallout 4\Mods\FO4 Interface\Commands\Output\Extracted\Interface"
FOR %%F in (*.swf) do (
	ECHO Starting FFDEC for %%~nF
	SET ExportCommand=-export fla "!OutputDirectory!\%%~nF"
	REM PAUSE
	CALL "%EXE%" !ExportCommand! %%~nxF
	ECHO.
	ECHO.
	ECHO.
)

REM Command Programs
REM ===========================================================
CD /D "D:\Games\Steam\SteamApps\common\Fallout 4\Mods\FO4 Interface\Commands\Output\Extracted\Programs"
FOR %%F in (*.swf) do (
	ECHO Starting FFDEC for %%~nF
	SET ExportCommand=-export fla "!OutputDirectory!\%%~nF"
	REM PAUSE
	CALL "%EXE%" !ExportCommand! %%~nxF
	ECHO.
	ECHO.
	ECHO.
)

PAUSE