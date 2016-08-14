@ECHO off
ECHO Setting batch variables..
ECHO.
REM Project Locations
REM ===========================================================
SET falloutDirectory=D:\Games\Steam\SteamApps\common\Fallout 4\
SET projectDirectory=E:\Lab\Bethesda\FO4\Scrivener07\FO4_Interface\
SET defaultPEX=Data\Scripts\
SET defaultPSC=Data\Scripts\Source\User\
SET defaultSWF=Data\Interface
SET defaultFLA=Data\Interface\Source
REM Project Files
REM ===========================================================
SET stp00=Data\FO4_Interface.sublime-project
SET bat01=Data\FO4_Interface.bat
SET doc01=Data\FO4_Interface.txt
SET swf01=Data\Interface\fonts_en.swf
SET swf02=Data\Interface\fonts_console.swf
SET swf03=Data\Interface\FontConfig.txt
REM Copy Files
REM ===========================================================
ECHO Copying mod files from the game directory to the project directory..
ECHO From Fallout %falloutDirectory%
ECHO To Projects %projectDirectory%
ECHO.
ECHO.
REM ===========================================================
ECHO f | xcopy /f /y "%falloutDirectory%%stp00%" "%projectDirectory%%stp00%"
ECHO f | xcopy /f /y "%falloutDirectory%%bat01%" "%projectDirectory%%bat01%"
ECHO f | xcopy /f /y "%falloutDirectory%%doc01%" "%projectDirectory%%doc01%"
ECHO f | xcopy /f /y "%falloutDirectory%%swf01%" "%projectDirectory%%swf01%"
ECHO f | xcopy /f /y "%falloutDirectory%%swf02%" "%projectDirectory%%swf02%"
ECHO f | xcopy /f /y "%falloutDirectory%%swf03%" "%projectDirectory%%swf03%"
ECHO.
ECHO.
xcopy /s /i /y "%falloutDirectory%%defaultFLA%" "%projectDirectory%%defaultFLA%"
ECHO.
ECHO.
ECHO Batch is finished.
PAUSE
