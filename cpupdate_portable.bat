@echo off
rem This script updates the mod "Courseplay" for Farming Simulator 17
rem Copy this file to a folder of your choice and run in from time to time.
rem
rem Backups will be stored as ZIP files in a subfolder .\cpbackup
rem
rem =============================================================================
rem                     I M P O R T A N T  N O T I C E
rem =============================================================================
rem Git for Windows and 7-Zip have to be installed and reside in your PATH!
rem Otherwise, adjust 'set gitexe=' and 'set zipexe' to your needs.
rem
rem For help with setting a program to your path, have a look @ http://www.computerhope.com/issues/ch000549.htm
rem
rem Have fun!
rem
rem (c) 2016 M. Busche, elpatron@mailbox.org
rem You could replace these with the full path to the files if they don´t reside in your PATH
set gitexe=".\cmd\git.exe"
set zipexe=".\App\7-Zip\7z.exe"

rem setlocal EnableDelayedExpansion
Setlocal
echo Courseplay Beta Updatescript
echo (c) 2016 elpatron@mailbox.org
echo .
rem git.exe startable?
echo Checking for Git...
%gitexe% --version > NUL
if not errorlevel == 1 set gitok="-1"
rem 7-Zip startable?
echo Checking for 7-Zip...
%zipexe% >NUL
if errorlevel == 9009 goto zipok="-1"
if "%gitok%"=="-1" goto gitzipfehler
if "%zipok%"=="-1" goto gitzipfehler

echo Git and 7-Zip are ok, lets move on...
echo.

rem Write a VBS file for getting Courseplay version
> "%temp%\getversion.vbs" (
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

rem Setting `Documents` folder
for /f "skip=2 tokens=2*" %%A in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do set "UserDocs=%%B"
rem Setting Courseplay mod folder
set destination=%UserDocs%\my games\FarmingSimulator2017\mods\ZZZ_courseplay
echo Your Courseplay mod folder is: %destination%
rem Backup-Ordner
set "curpath=%cd%"
set backup=%curpath%\cpbackup
echo Your backup folder ist %backup%

rem Get current Courseplay version with vbs script
if exist "%destination%\moddesc.xml" (
	del /q "%temp%\cpversion.txt" > NUL
	cscript "%temp%\getversion.vbs" "%destination%\modDesc.xml" //Nologo >"%temp%\cpversion.txt"
	set /p version=<"%temp%\cpversion.txt"
	echo Your currently installed Version is: %version%
	del "%temp%\cpversion.txt" > NUL
	set freshinstall="no"
	) else (
	set freshinstall="yes"
	set version="0"
)

rem Delete old checkout
echo Deleting temporary folder...
rd /s/q .\courseplay 2> NUL
rem Git clone
echo Cloning Courseplay repository from Github...
%gitexe% clone --depth=1 -q https://github.com/Courseplay/courseplay.git
rem Get new Courseplay version
cscript "%temp%\getversion.vbs" ".\courseplay\modDesc.xml" //Nologo >"%temp%\cpversion.txt"
set /p newversion=<"%temp%\cpversion.txt"
echo Version from Github: %newversion%
del "%temp%\cpversion.txt" > NUL

rem Do we have an update?
if "%newversion%"=="%version%" (
	echo No update found, exiting.
	rd /s/q .\courseplay 2> NUL
	goto ende
	) else (
	echo We have found an update.
)

rem Backup current version
if %freshinstall%=="no" (
	echo Creating a backup of your current Courseplay...
	mkdir %backup% 2> NUL
	%zipexe% a -r "%backup%\courseplay_backup-%version%.zip" "%destination%\*" >NUL 2>&1
	echo If you consider any problems, check your backup file: "%backup%\courseplay_backup-%version%.zip"
	) else (
	echo No former version found - this seems to be a fresh install. Creating new mod directory for Courseplay...
	md "%destination%" > NUL
)

rem Copy clone to mod folder
echo Copying the update to your mod folder...
xcopy  /S /E /H /Y /C /Q ".\courseplay\*.*" "%destination%\" >NUL
rem  Couseplay Git checkout wieder löschen
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
del "%temp%\getversion.vbs" >NUL
echo.
echo Thanks for using me.