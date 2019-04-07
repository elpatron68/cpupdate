# cpupdate - Portable Courseplay Update Package

![For Farming Simulator 19](https://img.shields.io/badge/Farming%20Simulator-19-FF7C00.svg)

## What does it do?
This package contains portable editions of Git and 7-Zip as well as a Batch script that
* checks Coursplay´s Github repository for the latest version,
* installs Courseplay (if it wasn´t formerly installed) to your FS17 mod folder,
* backups your current Courseplay in case of an update,
* updates your current Courseplay to the latest version from the Github repository.

## Who needs this?
Every Farming Simulator 2017 enthusiast should have a look at the famous mod [Courseplay](https://github.com/Courseplay/courseplay). If you are using Courseplay and want to be sure to always use the latest version, you should update your installation before playing, as there are frequent updates. This can be a quite complicated process if you want to be sure to have a backup of former versions.

## How to use?
1. [Download the latest version of `cpupdate_installer.exe`](https://github.com/elpatron68/cpupdate/releases).
2. Start the self-extracting installer archive 'cpupdate_installer.exe' and extract it to a folder of your choice. **Don´t use your `Program Files` folder because the script has to write some temporary files in it´s installation folder.**
3. Find `cpupdate_portable.bat` in the folder you extracted in the former step and send a link to your desktop.
4. Start `cpupdate_portable.bat` for an instant 1-click update.

![Sceenshot (fresh install)](https://github.com/elpatron68/cpupdate/blob/master/_screenshots/fresh_install.png)

(Fresh installation)

![Sceenshot (update)](https://github.com/elpatron68/cpupdate/blob/master/_screenshots/update.png)

(Update installation)

## How to restore an older version?
With every Courseplay update *cpupdate* creates a backup of your former version. You can find it under your *cpupdate* directory (see step 2. above) in the subfolder `.\cpbackup`. Just extract the content to `<your Farming Simulator mod folder>\ZZZ_Courseplay\`. `<your Farming Simulator mod folder>` is usually under your Documents folder - `my games` - `FarmingSimulator2017` - `mods`.

## How get rid of it?
Just delete the directory you extracted the installer to (see step 2. above). Attention! You will loose your backup files, too.

## Expert usage
If you have installed Git and 7-Zip on your computer, you can download only the script file `cpupdate_portable.bat`, open it in an text editor and set the path to Git and 7-Zip suiting your needs (Lines 45 - 46)

You can also set the default deployment mode from `ZIPFILE` to `DIRECTORY` if you like (Line 32 - 33).

In lines 39 - 40 you can toggle between "auto-close-behaviour" and "hit-a-key-before-closing-the-window-because-i-want-to-see-what-happened-mode".

## What´s fresh?
Version 1.6 (31.1.2019)
  * Farming Simulator version 2017 or 2019 (default) - edit `cpupdate_portable.bat` and find `set fsversion`
  
Version 1.4 (16.12.2016)
 * Bugfix: "Hit any key to close window"
 * Support for custom mod folder (from gamesettings.xml)
 * Colored text (Win10 only)
 
Version 1.1 (5.12.2016)
* Now capable of creating a zipped file in your mod directory

## Anything else?
If you like this, star it on [GitHub](https://github.com/elpatron68/cpupdate/)!
