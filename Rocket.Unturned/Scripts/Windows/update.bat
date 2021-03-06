@ECHO OFF 
REM This script updates a Unturned 3 server on Windows machines
REM To quickstart, just create a new folder and place the contents of the Rocket.Unturned download into it. Then run MyFirstRocketServer.bat
REM Syntax: update.bat <unturned directory> <steam directory>
REM Author: fr34kyn01535

SET UNTURNEDHOME=%~dp0
SET STEAMCMDHOME=%~dp0..\SteamCMD\


IF NOT EXIST %STEAMCMDHOME% (
	ECHO Installing SteamCMD into Steam directory
	MKDIR "%STEAMCMDHOME%"
	bitsadmin.exe /transfer "Downloading SteamCMD" https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip "%~dp0SteamCMD.zip"
	CALL :unzip "%~dp0" "%~dp0SteamCMD.zip"
	DEL SteamCMD.zip
	MOVE steamcmd.exe %STEAMCMDHOME%
)

%STEAMCMDHOME%steamcmd.exe +login unturnedrocksupdate force_update +force_install_dir ..\Unturned +app_update 304930 validate +exit

bitsadmin.exe /transfer "Downloading Rocket.Unturned" "https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip" "%~dp0Rocket.zip"
CALL :unzip "%~dp0" "%~dp0Rocket.zip"
DEL Rocket.zip
pause

exit /b

:unzip <destination> <archive>
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%
