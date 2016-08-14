@ECHO off

REM Variables
REM ===========================================================
SET WindowTitle="Extract Interface BA2"
SET EXE="D:\Games\Steam\SteamApps\common\Fallout 4\Tools\Archive2\Archive2.exe"
SET ArchiveFile="D:\Games\Steam\SteamApps\common\Fallout 4\Data\Fallout4 - Interface.ba2"
SET ExtractCommand="-extract=D:\Games\Steam\SteamApps\common\Fallout 4\Mods\FO4 Interface\Commands\Output\Extracted"

REM Commands
REM ===========================================================
START %WindowTitle% %EXE% %ArchiveFile% %ExtractCommand%

PAUSE