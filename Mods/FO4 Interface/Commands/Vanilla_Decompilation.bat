@ECHO off
SETLOCAL EnableDelayedExpansion
ECHO The batch script will decompile the vanilla interface now.
PAUSE
ECHO.

REM TODO Parameters
REM ===========================================================
SET GameFolder=D:\Games\Steam\SteamApps\common\Fallout 4

REM Variables
REM ===========================================================
SET ProcessEXE=E:\Software\Adobe\Flash\JPEXS\9.0.0\ffdec.bat
SET ProcessOutputFolder=%GameFolder%\Mods\FO4 Interface\Commands\Output\Decompiled


REM Decompile Interface
REM ===========================================================
CD /D "%GameFolder%\Mods\FO4 Interface\Commands\Output\Extracted\Interface"
SET SubFolder=Menus
FOR %%F in (*.swf) do (
	CD /D "%%~dpF"
	SET OutputFolder=!ProcessOutputFolder!\!SubFolder!\%%~nF
	SET ExportCommand=-export fla "!OutputFolder!"
	SET LogFile=!OutputFolder!.log
	MD "!OutputFolder!"

	ECHO Starting FFDEC for %%~nxF
	ECHO Directory: %%~dpF
	ECHO OutputFolder: !OutputFolder!
	ECHO LogFile: !LogFile!

	ECHO CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	ECHO.
	ECHO.
	ECHO.
)

REM Decompile Programs
REM ===========================================================
CD /D "%GameFolder%\Mods\FO4 Interface\Commands\Output\Extracted\Programs"
SET SubFolder=Programs
FOR %%F in (*.swf) do (
	CD /D "%%~dpF"
	SET OutputFolder=!ProcessOutputFolder!\!SubFolder!\%%~nF
	SET ExportCommand=-export fla "!OutputFolder!"
	SET LogFile=!OutputFolder!.log
	MD "!OutputFolder!"

	ECHO Starting FFDEC for %%~nxF
	ECHO Directory: %%~dpF
	ECHO OutputFolder: !OutputFolder!
	ECHO LogFile: !LogFile!

	ECHO CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	ECHO.
	ECHO.
	ECHO.
)

REM Decompile Exported
REM ===========================================================
CD /D "%GameFolder%\Mods\FO4 Interface\Commands\Output\Extracted\Interface\Exported"
SET SubFolder=Exported
FOR %%F in (*.gfx) do (
	CD /D "%%~dpF"
	SET OutputFolder=!ProcessOutputFolder!\!SubFolder!\%%~nF
	SET ExportCommand=-export fla "!OutputFolder!"
	SET LogFile=!OutputFolder!.log
	MD "!OutputFolder!"

	ECHO Starting FFDEC for %%~nxF
	ECHO Directory: %%~dpF
	ECHO OutputFolder: !OutputFolder!
	ECHO LogFile: !LogFile!

	ECHO CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	ECHO.
	ECHO.
	ECHO.
)

REM Decompile Components Recursive
REM ===========================================================
CD /D "%GameFolder%\Mods\FO4 Interface\Commands\Output\Extracted\Interface\Components"
SET SubFolder=Components
FOR /R %%F in (*.swf) do (
	CD /D "%%~dpF"
	SET OutputFolder=!ProcessOutputFolder!\!SubFolder!\%%~nF
	SET ExportCommand=-export fla "!OutputFolder!"
	SET LogFile=!OutputFolder!.log
	MD "!OutputFolder!"

	ECHO Starting FFDEC for %%~nxF
	ECHO Directory: %%~dpF
	ECHO OutputFolder: !OutputFolder!
	ECHO LogFile: !LogFile!

	ECHO CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	CALL "%ProcessEXE%" !ExportCommand! "%%~nxF" >> "!LogFile!"
	ECHO.
	ECHO.
	ECHO.
)

ECHO Decompilation has finished.
PAUSE
ECHO.
ECHO.
ECHO.