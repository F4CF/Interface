@ECHO off
ECHO Press Ctrl-C to terminate batch script at any time.
ECHO.

REM Extraction
REM ===========================================================
ECHO The batch script will extract the vanilla interface archive now.
PAUSE
CALL Vanilla_Extraction.bat
ECHO Extraction has finished.
ECHO.
ECHO.
ECHO.

REM Decompilation
REM ===========================================================
ECHO The batch script will decompile the vanilla interface now.
PAUSE
CALL Vanilla_Decompilation.bat
ECHO Decompilation has finished.
ECHO.
ECHO.
ECHO.

REM Documentation
REM ===========================================================
ECHO The batch script will document the decompiled AS3 classes now.
PAUSE
CALL Vanilla_Documentation.bat
ECHO Documentation has finished.
ECHO.
ECHO.
ECHO.

PAUSE
EXIT
