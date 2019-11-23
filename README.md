# Hampi Image

Version 20191123

Author: Steve Magnuson, AG7GN

## Related Information

[Adjusting Audio Levels](https://github.com/AG7GN/images/blob/master/README-adjust_audio_levels.md)

[Configuring and Using  Auto-HotSpot](https://github.com/AG7GN/images/blob/master/README-auto_hotspot.md)

[Operating your Hampi "Headless"](https://github.com/AG7GN/images/blob/master/README-Using_VNC_to_Operate_Remotely.md)


## Prerequisites

- Raspberry Pi 3B, 3B+ or 4 (NOTE: I have only tested this image with 3B and 3B+.)
- [Fe-Pi Audio Z Version 2 sound card](https://fe-pi.com/products/fe-pi-audio-z-v2)
- Budd Churchward's ([WB7FHC](http://wb7fhc.com/index.html)) excellent DigiLink (REV C or later) or [Nexus DR-X](http://wb7fhc.com/intro.html) board
- 16GB or greater MicroSD card
- OPTIONAL: Speakers attached to Pi's built-in audio jack if you want to monitor the radio's TX and/or RX on the Pi's speakers
- Familiarity with the Pi's Terminal application, basic LINUX commands and the use of `sudo`

This image uses the default configuration for user __pi__:  pi's home directory is __/home/pi__ and user __pi__ has passwordless __sudo__ privileges.  The desktop automatically starts without requiring a password for user __pi__.

The default password for user __pi__ is __changeme__.

## Features

- Uses the latest Debian 10 (Buster) Raspberry Pi OS

- Fldigi, Flmsg, Flamp, Flarq are installed and minimally configured to use PulseAudio and 1 or 2 radios.  You must set your call sign and name, among other things, in the Fldigi and Flmsg settings.
- Flrig is installed and configured for use with 1 or 2 radios, but it is not visible on the __Hamradio__ menu by default.  See the __Editing the Main Menu__ section for information on customizing the menu.
- Direwolf is installed and configured for use with PulseAudio with 1 or 2 radios.
- You'll see __Configure RMS Gateway__ in the __Hamradio__ menu.  __Most users should ignore this menu item.__ This is only needed if you want this Pi to operate as an [RMS Gateway](https://www.winlink.org/tags/gateway).  

	__*Note that operating an RMS Gateway requires that you obtain a "Sysop" account at winlink.org.*__ There are [other requirements](https://www.winlink.org/content/join_gateway_sysop_team_sysop_guidelines) as well .  If you operate the Pi as an RMS Gateway, I strongly recommend that you don't use the Pi for any other purpose.
- There are menu items to toggle on and off TX and RX audio monitoring.  This only works if you have speakers connected to your Pi's built-in audio jack or your HDMI monitor has speakers.
- Recognizes and enables a DS3231 Real Time Clock module, if installed.
- A script is installed and enabled to restart or shutdown the Pi if the DigiLink button is pressed (DigiLink Rev __DS__ or [Nexus DR-X](http://wb7fhc.com/intro.html) boards only).  
	- If the button is pressed for 2 <= *t* < 5 seconds then released, the Pi will reboot.  
	- If the button is pressed for *t* >= 5 seconds then released, the Pi will shutdown.  			  
	- Note that the GPIO jumper on the DigiLink board must be installed in the '26' position for this to work.  If you want to use GPIO 13 or 6 instead (by moving the DigiLink GPIO jumper), you can edit the `/usr/local/bin/shutdown_button.py` file and set the `use_button` variable to 13 or 6 respectively.  The [Nexus DR-X](http://wb7fhc.com/intro.html) board is hard wired to GPIO 26 for this purpose - it cannot be changed.
- Watchdog service is enabled.  If the Pi locks up, it *should* automatically reboot within 10 seconds.
- Includes a GUI to make it easier to install and update various ham applications.
- Supports user scripting based on the lever positions of the piano switch on the [Nexus DR-X](http://wb7fhc.com/intro.html) board.  A sample user script is in `/home/pi/pianoX.sh.example`.  Here's more information about [how it works](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#check-piano-script).

## New in This Version

- Latest OS and Raspberry Pi application updates installed.
- Numerous updates to [hampi-utilities](https://github.com/AG7GN/hampi-utilities/blob/master/README.md).
- Latest [Kenwood TM-D710G/TM-V71A](https://github.com/AG7GN/kenwood) radio control script installed.
- [CUPS](https://en.wikipedia.org/wiki/CUPS) is installed and a menu item added to __Raspberry > Preferences__ to manage printers.
- Default password for user __pi__ is set to __changeme__.  *Please change this password!*  Instructions are under __First Time Boot Instructions__ below.

## Bugs

Probably.  WATCH THIS SPACE.  I will post bug information and workarounds here.

## Installation

1. Assemble the DigiLink or [Nexus DR-X](http://wb7fhc.com/intro.html) board and install it and the Fe-Pi audio board onto the Pi.
1. [Download the image](https://drive.google.com/open?id=1qemN3vxEZijSvZfUqSC45oj-ISXEHQvz) (3.7 GB) from my Google Drive.  Click the __Download__ button when prompted with the "Whoops! There was a problem with the preview." window.
1. Burn the image to your SD card by following the ["Writing an image to the SD card"](https://www.raspberrypi.org/documentation/installation/installing-images/)  instructions.  Since you've already downloaded the image in the previous step, ignore the "Download the image" section on that web page.
1. Insert the MicroSD card into the Pi and power it on.
1. You'll need a keyboard/video/mouse (KVM) attached for the first boot.

## First Time Boot Instructions

__*PLEASE* DO THESE STEPS before seeking help!  The downloaded image is compressed to save download time.  You must expand the file system (step 4 below) if you want to install any additional software!__

1. You'll need a keyboard/video/mouse (KVM) attached for the first boot.
1. You'll notice the first time you start the Pi with this image that it immediately reboots within a few seconds of the desktop appearing.  This is expected behavior and is caused by a script that runs on first boot that resets the VNC and SSH client and server keys among other things.  This happens only at the first boot-up.
1. Connect your Pi's ethernet port to your home network or use the Pi's wifi to connect to your home network.  For WiFi:
	- Click on the network icon (just to the left of the speaker icon) on the Pi's top menu bar.  
	- Select your WiFi network from the list (NOTE: it make take a minute or 3 for the WiFi networks your Pi can see to appear in that list) and follow the instructions on the screen.
1. Once the desktop appears, open a Terminal window and run this command:

		sudo raspi-config
		
	- Select __7 Advanced Options__ from the menu.
	- Select __A1 Expand Filesystem__.
	- Press __Enter__ at the "Root partition has been resized" screen.
	- Press the __TAB__ key to select __Finish__, then press __ENTER__.
	- Select __Yes__ to reboot.
1. Once the desktop appears, click __Raspberry > Preferences > Raspberry Pi Configuration__, then click __Change Password__ to set your password.  Click __OK__, and __OK__ again.  
1. If the outside edge of the desktop appears cut off on your monitor or your desktop doesn't fully fill your monitor's screen, enable or disable __Overscan__ as needed to fix the problem.  
1. Change the Hostname of your Pi as desired.  It's a good idea to include your call sign in the hostname to make it unique.  Example: __hampi-ag7gn__.  By convention, hostnames are lower case, but there's no harm in using capital letters.  You can use any name, but the only non-alphanumeric character allowed is a dash (-).
1. Click __OK__.
1. Click __Yes__ if prompted to reboot.
1. When the desktop appears, run the Updater: Click __Raspberry > Hamradio > Update Pi and Ham Apps__, then re-run __Raspberry > Hamradio > Update Pi and Ham Apps__ if prompted to do so.  Check __Raspbian ODS and Apps__ and click __OK__.  Reboot if prompted.

## Update OS and Update/Install Ham Applications

1. Click __Raspberry > Hamradio > Update Pi and Ham Apps__.  Check the applications you want to update or install and click __OK__.  Some installations take a very long time.  Don't install an application unless you understand what the application is for.  __*Installing an application does not configure it*__. Consult the documentation for that application for configuration instructions.

	You can double-click on the app name to obtain information about that app.  This will open the Chromium browser.

1. As you already know from the [First Time Boot Instructions](#first-time-boot-instructions), checking the __Raspbian OS and Apps__ item in the GUI will check for and install OS updates.  This is equivalent to running the following commands in a Terminal:

		sudo apt-get update
		sudo apt-get upgrade -y

	I recommend checking for updates for __Raspbian OS and Apps__ about once a week.

## (Optional) Customize the Main Menu

__WARNING:__ There is a long time bug in the Main Menu Editor that resets the menu settings to default when you click the __Cancel__ button.  So, *NEVER* click the __Cancel__ button!  Even if you made no changes, click __OK__ instead.

FYI: If you make changes to a particular menu item, a new desktop file will be created in `/home/pi/.local/share/applications` and that file will be used to populate the menu even if there is a `.desktop` file in the default location `/usr/local/share/applications` with the same name. 

1. Click __Raspberry > Preferences > Main Menu Editor__.  
1. Select __Hamradio__ in the left pane.
1. Check or uncheck the applications listed in the center pane as desired.
1. Click the __Up__ or __Down__ buttons to move the selected item up or down in the menu list.  Add or remove separators in the menu list as desired.
1. Click __OK__ (*never* click __Cancel__!) when done.

## Customize the Fldigi Apps

1. In Fldgi: __Configure > UI > Operator__.  Note you have to do this for both the __Fldigi (Left Radio)__ *and* __Fldigi (Right Radio)__ menu items.
1. In Flmsg: __Config > Personal__ tab.  Note that you have to do this for both the __Flmsg (Left Radio)__ *and* __Flmsg (Right Radio)__ menu items.

## Direwolf Notes

User pi's home folder contains 2 Direwolf configuration files: `/home/pi/direwolf-left.conf` and `/home/pi/direwolf-right.conf`.  If you are going to use Direwolf as a KISS or AGW TNC with a Windows RMS Express client or Xastir, there's no need to change `MYCALL` in these files from the default `N0ONE-10`.  Those applications will supply your call sign to Direwolf via the KISS or AGW connection.  You can change `MYCALL` if you'd like, of course.

If you want to use this Pi as an APRS Digipeater and/or iGate, use the [`/usr/local/bin/tnc.sh`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#tnc-script) and associated [`/usr/local/bin/watchdog-tnc.sh`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#watchdog-tnc-script) scripts. 

`tnc.sh` also works with `pat` and `arim`, which you can install using the Updater: __Raspberry > Hamradio > Update Pi and Ham Apps__.  `tnc.sh` creates on on-the-fly direwolf configuration file depending on what mode you want to use.  It will also allocate a `pty` for `pat` (`pat` can't use KISS).  

The configuration files for `tnc.sh` are in [`/home/pi/tnc-left.conf`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#tnc-left-tnc-right-configuration-files) and [`/home/pi/tnc-right.conf`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#tnc-left-tnc-right-configuration-files).


## Annoyances

Things that aren't really bugs, but irritating nevertheless will be documented here.
