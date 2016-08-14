@ECHO off
ECHO The batch script will reverse the entire interface from archive.
ECHO Press Ctrl-C to terminate batch script at any time.
ECHO.

ECHO Extraction
ECHO ===========================================================
CALL Vanilla_Extraction.bat

ECHO Decompilation
ECHO ===========================================================
CALL Vanilla_Decompilation.bat

ECHO Documentation
ECHO ===========================================================
CALL Vanilla_Documentation.bat

ECHO Publishing
ECHO ===========================================================
REM CALL Flash_Publish.jsfl

PAUSE
EXIT