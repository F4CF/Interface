@ECHO off
ECHO The batch script will update the repository.
PAUSE
ECHO.

REM TODO Parameters
REM ===========================================================
SET GameFolder=D:\Games\Steam\SteamApps\common\Fallout 4
SET RepositoryDirectory=E:\Lab\Bethesda\FO4\FO4_Interface

REM Folders
REM ===========================================================
SET ModDirectory=Mods\FO4 Interface
SET FlashDirectory=Data\Interface\Source

REM Files
REM ===========================================================
SET SWF01=Data\Interface\fonts_en.swf
SET SWF02=Data\Interface\fonts_console.swf
SET SWF03=Data\Interface\FontConfig.txt

ECHO Copying Files
ECHO ===========================================================
ECHO Copying mod files from the game directory to the repository directory..
ECHO From Fallout %GameFolder%
ECHO To Repository %RepositoryDirectory%
ECHO ===========================================================
xcopy /s /i /y "%GameFolder%\%ModDirectory%" "%RepositoryDirectory%\%ModDirectory%"
ECHO.
xcopy /s /i /y "%GameFolder%\%FlashDirectory%" "%RepositoryDirectory%\%FlashDirectory%"
ECHO.
ECHO f | xcopy /f /y "%GameFolder%\%SWF01%" "%RepositoryDirectory%\%SWF01%"
ECHO f | xcopy /f /y "%GameFolder%\%SWF02%" "%RepositoryDirectory%\%SWF02%"
ECHO f | xcopy /f /y "%GameFolder%\%SWF03%" "%RepositoryDirectory%\%SWF03%"
ECHO.

ECHO The batch script update repository has finished.
PAUSE
ECHO.
ECHO.
ECHO.
