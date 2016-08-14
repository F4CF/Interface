@ECHO off
ECHO The batch script will extract the vanilla interface archive now.
PAUSE
ECHO.

REM TODO Parameters
REM ===========================================================
SET GameFolder=D:\Games\Steam\SteamApps\common\Fallout 4

REM Variables
REM ===========================================================
SET ProcessEXE=%GameFolder%\Tools\Archive2\Archive2.exe
SET ProcessInputFile=%GameFolder%\Data\Fallout4 - Interface.ba2
SET ProcessOutputFolder=%GameFolder%\Mods\FO4 Interface\Commands\Output\Extracted
SET ProcessCommandExtract=-e="%ProcessOutputFolder%"

REM Commands
REM ===========================================================
CALL "%ProcessEXE%" "%ProcessInputFile%" %ProcessCommandExtract%

ECHO The batch script extraction has finished.
PAUSE
ECHO.
ECHO.
ECHO.