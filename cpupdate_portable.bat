@echo off
rem (c) 2016 M. Busche, elpatron@mailbox.org
rem
rem 
rem                                      _       _       
rem                                     | |     | |      
rem            ___ _ __  _   _ _ __   __| | __ _| |_ ___ 
rem           / __| '_ \| | | | '_ \ / _` |/ _` | __/ _ \
rem          | (__| |_) | |_| | |_) | (_| | (_| | ||  __/
rem           \___| .__/ \__,_| .__/ \__,_|\__,_|\__\___|
rem               | |         | |                        
rem               |_|         |_|                        
rem
rem 
rem This script installs or updates the mod "Courseplay" for Farming Simulator 17
rem Copy this file to a folder of your choice and run it from time to time.
rem
rem =============================================================================
rem                     I M P O R T A N T  N O T I C E
rem =============================================================================
rem Backups will be stored as ZIP files in the subfolder .\cpbackup
rem
rem Have a look at the settings described below!
rem
rem Have fun!
rem =============================================================================
rem Set deployment mode:
rem    * "ZIPFILE" creates a ZZZ_Courseplay.zip file in your mod directory
rem    * "DIRECTORY" copies the Courseplay as subdirectory to your mod directory
rem Both modes work fine, you have the choice.
rem
set deployment="ZIPFILE"
rem set deployment="DIRECTORY"
rem =============================================================================
rem If you want the command window to close after run: set autoclose="YES".
rem Otherwise you have to hit a keystroke after the run - which enables you
rem to see what happened.
rem
rem set autoclose="YES"
set autoclose="No"
rem =============================================================================
rem You should replace these with the full path to the files if you use this
rem script without the portable editions of Git and 7-Zip.
rem
set gitexe=".\cmd\git.exe"
set zipexe=".\App\7-Zip\7z.exe"
rem =============================================================================
rem End of user settings
setlocal enabledelayedexpansion
echo Courseplay Beta Updatescript v1.1
echo (c) 2016 elpatron@mailbox.org
echo .
rem git.exe startable?
echo Checking for Git...
%gitexe% --version > NUL
if not %errorlevel%==1 set gitok="-1"
rem 7-Zip startable?
echo Checking for 7-Zip...
%zipexe% >NUL
if %errorlevel%==9009 goto zipok="-1"
if "%gitok%"=="-1" goto gitzipfehler
if "%zipok%"=="-1" goto gitzipfehler

echo Git and 7-Zip are ok, lets move on...
echo.

rem Write a VBS file for getting Courseplay version from moddesc.xml
> "%TEMP%\getversion.vbs" (
echo.Dim oXml: Set oXml = CreateObject^("Microsoft.XMLDOM"^)
echo.oXml.Load WScript.Arguments.Item^(0^)
echo.Dim oDoc: Set oDoc = oXml.documentElement
echo.
echo.For Each node In oDoc.childNodes
echo.	If node.nodeName = "version" Then
echo.		WScript.Echo node.text
echo.	End If
echo.Next
echo.Set oXml = Nothing
)

:: Write a VBS file for getting modfolder from gameSettings.xml
> "%TEMP%\moddir.vbs" (
echo.Dim oXml: Set oXml = CreateObject^("Microsoft.XMLDOM"^)
echo.oXml.Load WScript.Arguments.Item^(0^)
echo.Dim oDoc: Set oDoc = oXml.documentElement
echo.
echo.For Each node In oDoc.childNodes
echo.	If ^(node.nodeName = "modsDirectoryOverride"^) And ^(node.getAttribute^("active"^) = "true"^) Then
echo.		WScript.Echo node.getAttribute^("directory"^)
echo.	End If
echo.Next
echo.Set oXml = Nothing
)

rem Setting `Documents` folder
for /f "skip=2 tokens=2*" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do set "UserDocs=%%B"

:: Setting Mod directory
SETLOCAL
for /f %%i in ('cscript .\moddir.vbs "%UserDocs%\My Games\FarmingSimulator2017\gameSettings.xml" //Nologo') do set moddir=%%i

rem Setting Courseplay mod folder or file
set _dest=%moddir%\ZZZ_courseplay
echo Deployment method is %deployment%.
if %deployment%=="DIRECTORY" (
	set destination=%_dest%
	) else (
	set destination=%_dest%.zip
)
echo Your destination is: %destination% 
	
rem Is this a fresh installation or an update?
if exist "%destination%" (
	set freshinstall="no"
	echo Previous version found, switching to update mode.
) else (
	set freshinstall="yes"
	echo No previous version found, switching to fresh install mode..
)

rem Backup directory
set "curpath=%cd%"
set backupdir=.\cpbackup
echo Your backup folder is: %curpath%\cpbackup

rem Extract moddesc.xml from ZIPFILE
if %deployment%=="ZIPFILE" (
	if %freshinstall%=="no" (
		echo Extracting 'moddesc.xml' for version detection...
		del /q "%TEMP%\moddesc.xml" > NUL
		%zipexe% e "%destination%" -o"%TEMP%" moddesc.xml -r -aoa > NUL 2>&1
	)
)

rem Get current Courseplay version with vbs script
if exist .\cpversion.txt (
	del /q .\cpversion.txt > NUL
)
rem ...from directory
if %deployment%=="DIRECTORY" (
	if %freshinstall%=="no" (
		cscript "%TEMP%\getversion.vbs" "%destination%\modDesc.xml" //Nologo >.\cpversion.txt
	)
)
rem from zip file
if %deployment%=="ZIPFILE" (
	if %freshinstall%=="no" (
		cscript "%TEMP%\getversion.vbs" "%TEMP%\moddesc.xml" //Nologo >.\cpversion.txt
	)
)

rem sleep 2 seconds
ping 127.0.0.1 -n 2 > nul

rem Read version from output file
if exist .\cpversion.txt (
	set /p version=<.\cpversion.txt
	del /q .\cpversion.txt" > NUL
	set freshinstall="no"
	) else (
	set freshinstall="yes"
	set version="0"
)
if not %version%=="0" (
	echo Your currently installed Version is: %version%
)

rem Delete old checkout
echo Deleting temporary folder...
rd /s/q .\courseplay 2> NUL

rem Git clone
echo Cloning Courseplay repository from Github...
%gitexe% clone --depth=1 -q https://github.com/Courseplay/courseplay.git

rem Get new Courseplay version
cscript "%TEMP%\getversion.vbs" ".\courseplay\modDesc.xml" //Nologo >.\cpversion.txt
set /p newversion=<.\cpversion.txt
echo Version from Github: %newversion%
if exist .\cpversion.txt (
	del /q .\cpversion.txt > NUL
)

rem Do we have an update?
if "%newversion%"=="%version%" (
	echo No update found, exiting.
	rd /s/q .\courseplay 2> NUL
	goto ende
	) else (
	echo We have found an update.
)

rem Backup current version
if %deployment%=="DIRECTORY" (
	set backupfile=%backupdir%\courseplay_backup-%version%.zip
) else (
	set backupfile=%backupdir%\ZZZ_courseplay_%version%.zip
)

if %freshinstall%=="no" (
	echo Creating a backup of your current Courseplay...
	mkdir %backupdir% 2> NUL
	if %deployment%=="DIRECTORY" (
		%zipexe% a -r "%backupfile%" "%destination%\*" >NUL 2>&1
	) else (	
		copy "%destination%" %backupfile% > NUL
	)
) else (
	echo No former version found - this seems to be a fresh install. Creating new mod directory for Courseplay...
	if %deployment%=="DIRECTORY" (
		md "%destination%" > NUL
	)
)

if not %backupfile%1==1 (
	echo If you consider any problems, check your backup file: "%backupfile%"
)

rem Copy cloned directory to mod folder
if %deployment%=="DIRECTORY" (
	echo Copying the update to your mod folder...
	xcopy  /S /E /H /Y /C /Q ".\courseplay\*.*" "%destination%\" >NUL
) else (
	echo Copying the updated Courseplay directory as ZIP file to your mod folder...
	%zipexe% a -r -tzip "%destination%" .\courseplay\* >NUL 2>&1
)

rem  Delete Git clone directory
echo Deleting temporary folder...
rd /s/q .\courseplay 2> NUL
echo Sucessfully updated from %version% to %newversion%.
	
goto ende

:gitzipfehler
if "%gitok%"=="-1" (
	echo Git for Windows has to be installed and reside in PATH!
	echo Download: https://git-scm.com/download/win
)
if "%zipok%"=="-1" (
	echo 7-Zip has to be installed and reside in PATH!
	echo Download: http://www.7-zip.org/download.html
)
goto ende

:ende
rem Cleanup
if exist "%TEMP%\getversion.vbs" (
	del /q "%TEMP%\getversion.vbs" >NUL
)
rem Goodbye
echo.
echo You should check for an update of cpupdate from time to time:
echo https://github.com/elpatron68/cpupdate/releases
echo .
echo Bye, and thanks for the fish.
if %autoclose%=="No" (
	echo ^(Any key to exit^)
	pause >NUL
)
