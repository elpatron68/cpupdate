# cpupdate - Portable Courseplay Update Package

## What does it do?
This package contains portable editions of Git and 7-Zip as well as a Batch script that
* checks Coursplay´s Github repository for the latest version,
* installs Courseplay (if it wasn´t formerly installed) to your FS17 mod folder,
* backups your current Courseplay mod folder in case of an update,
* updates your current Courseplay mod folder to the latest version from the Github repository.

## Who needs this?
Every Farming Simulator 17 enthusiast should have a look at the famous mod [Courseplay](https://github.com/Courseplay/courseplay). If you are using Courseplay and want to be sure to always use the latest version, you should update your installation before playing, as there are frequent updates. This can be a quite complicated process if you want to be sure to have a backup of former versions.

## How to use?
1. [Download the latest version of cpupdate](https://github.com/elpatron68/cpupdate/releases).
2. Start the self-extracting installer archive 'cpupdate_installer.exe' and extract it to a folder of your choice. **Don´t use your `Program Files` folder because the script has to write some temporary files in it´s installation folder.**
3. Find `cpupdate_portable.bat` in the folder you extracted in the former step and send a link to your desktop.
4. Start `cpupdate_portable.bat` for an instant 1-click update.

![Sceenshot (fresh install)](https://github.com/elpatron68/cpupdate/blob/master/_screenshots/fresh_install.png)
![Sceenshot (update)](https://github.com/elpatron68/cpupdate/blob/master/_screenshots/update.png)

## Expert usage
If you have installed Git and 7-Zip on your computer, you can download only the script file `cpupdate_portable.bat`, open it in an editor and set the path to Git and 7-Zip suiting your needs (Lines 19 - 20)
