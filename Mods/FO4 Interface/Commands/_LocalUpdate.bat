@ECHO off
REM Locations
REM ===========================================================
SET FalloutDirectory=D:\Games\Steam\SteamApps\common\Fallout 4\
SET RepositoryDirectory=E:\Lab\Bethesda\FO4\FO4_Interface\
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
ECHO From Fallout %FalloutDirectory%
ECHO To Repository %RepositoryDirectory%
ECHO ===========================================================
xcopy /s /i /y "%FalloutDirectory%%ModDirectory%" "%RepositoryDirectory%%ModDirectory%"
ECHO.
xcopy /s /i /y "%FalloutDirectory%%FlashDirectory%" "%RepositoryDirectory%%FlashDirectory%"
ECHO.
ECHO f | xcopy /f /y "%FalloutDirectory%%SWF01%" "%RepositoryDirectory%%SWF01%"
ECHO f | xcopy /f /y "%FalloutDirectory%%SWF02%" "%RepositoryDirectory%%SWF02%"
ECHO f | xcopy /f /y "%FalloutDirectory%%SWF03%" "%RepositoryDirectory%%SWF03%"
ECHO.
ECHO Batch is finished.
PAUSE
