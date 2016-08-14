@ECHO off
CD /D "D:\Games\Steam\SteamApps\common\Fallout 4\Mods\FO4 Interface\Commands\Output\Decompiled"

REM Commands
REM ===========================================================
FOR /D %%F in (*) do (
	ECHO Documenting the %%F.txt
	Tree /A %%F > %%F\%%F.txt
)

PAUSE