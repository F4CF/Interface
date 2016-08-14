@ECHO off
SETLOCAL EnableDelayedExpansion
ECHO The batch script will document the decompiled AS3 classes now.
PAUSE
ECHO.

REM TODO Parameters
REM ===========================================================
SET GameFolder=D:\Games\Steam\SteamApps\common\Fallout 4


REM Commands
REM ===========================================================
CD /D "%GameFolder%\Mods\FO4 Interface\Commands\Output\Decompiled"
FOR /R %%F in (*.fla) do (
	SET CurrentDirectory=%%~dpF
	IF "!CurrentDirectory:~-1!"=="\" SET CurrentDirectory=!CurrentDirectory:~0,-1!

	CD /D "!CurrentDirectory!"
	SET LogFile=!CurrentDirectory!\%%~nF_Dependency.txt

	ECHO.
	ECHO.---------------------------
	ECHO Documenting the %%~nxF actionscript classes.
	ECHO Directory: !CurrentDirectory!
	ECHO LogFile: !LogFile!
	ECHO.---------------------------
	ECHO.

	Tree /F /A "!CurrentDirectory!" > "!LogFile!"
)

ECHO Documentation has finished.
PAUSE
ECHO.
ECHO.
ECHO.