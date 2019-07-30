# HOWTO Install the DigiLink+Pulse+FePi+RTC Raspberry Pi Image

Version: 20190718B

Author: Steve Magnuson, AG7GN

## Prerequisites

- Raspberry Pi 3B, 3B+ or 4 (NOTE: I have only tested this image with 3B and 3B+.)
- [Fe-Pi Audio Z Version 2 sound card](https://fe-pi.com/products/fe-pi-audio-z-v2)
- Budd Churchward's (WB7FHC) excellent DigiLink board (REV C or later) or equivalent GPIO controlled PTT interface that uses GPIO 12 for the left radio and GPIO 23 for the right radio
- 16GB or greater MicroSD card
- OPTIONAL: Speakers attached to Pi's built-in audio jack if you want to monitor the radio's TX and/or RX on the Pi's speakers
- Familiarity with the Pi's Terminal application, basic LINUX commands and the use of `sudo`

This image uses the default configuration for user __pi__:  pi's home directory is __/home/pi__ and user __pi__ has passwordless __sudo__ privileges.  The desktop automatically starts without requiring a password for user __pi__.

## Changes and Notes

- Uses the latest Debian 10 (Buster) Raspberry Pi OS
- Fldigi, Flmsg, Flamp, Flarq are installed and minimally configured to use PulseAudio and 1 or 2 radios.  You must set your call sign and name, among other things, in the Fldigi and Flmsg settings.
- Flrig is installed and configured for use with 1 or 2 radios, but it is not visible on the __Hamradio__ menu by default.  See the __Editing the Main Menu__ section for information on customizing the menu.
- Direwolf is installed and configured for use with PulseAudio with 1 or 2 radios.
- RMS Gateway software is installed but unconfigured and disabled.  RMS Gateway allows the Pi to be used as a Winlink gateway (requires special Sysop account from winlink.org)
- Added menu items to toggle on and off TX and RX audio monitoring.  This only works if you have speakers connected to your Pi's built-in audio jack or your HDMI monitor has speakers.
- Added a menu item and GUI to make it easier to install and update various ham applications.
- Recognizes and enables a DS3231 Real Time Clock module, if installed.
- Installed and enabled a script to restart or shutdown the Pi if the DigiLink button is pressed (Rev __DS__ boards only).  If the button is pressed for 2 <= *t* < 5 seconds then released, the Pi will reboot.  If the button is pressed for *t* >= 5 seconds then released, the Pi will shutdown.  Note that the GPIO jumper on the DigiLink board must be installed in the '26' position for this to work.  If you want to use GPIO 13 or 6 instead (by moving the DigiLink GPIO jumper), you can edit the `/usr/local/bin/shutdown_button.py` file and set the `use_button` variable to 13 or 6 respectively.
- Adjusted PulseAudio configuration to take advantage of PulseAudio running as a [systemd/User](https://wiki.archlinux.org/index.php/Systemd/User) service now (a new feature in Raspbian Buster).  For those interested in the details, the new way to stop or restart PulseAudio is to run the following in the Terminal (note that `sudo` is not used with these commands):

		systemctl --user stop pulseaudio
		systemctl --user restart pulseaudio
		
	As a typical user, you should not have to use these commands.
- Watchdog service is enabled.  If the Pi locks up, it should automatically reboot within 10 seconds.
- The __initialize-pi.sh__ script does a more complete job in removing various Fldigi suite personalizations.

## Installation

1. Assemble the DigiLink board and install it and the Fe-Pi audio board onto the Pi.
1. [Download the image](https://drive.google.com/open?id=1GSJn-cxl9z5Pm35Qp75qqbQATwEAuBj5) from my Google Drive.  Click the __Download__ button when prompted with the "Whoops! There was a problem with the preview." window.
1. Burn the image to your SD card by following the ["Writing an image to the SD card"](https://www.raspberrypi.org/documentation/installation/installing-images/)  instructions.  Since you've already downloaded the image in the previous step, ignore the "Download the image" section on that web page.
1. Insert the MicroSD card into the Pi and power it on.

## First Time Boot-up Instructions

1. You'll notice the first time you start the Pi with this image that it immediately reboots within a few seconds of the desktop appearing.  This is normal behavior and is caused by a script that runs on first boot that resets the VNC and SSH client and server keys among other things.  This happens only at the first boot-up.
1. Once the desktop appears, open a Terminal window and run this command:

		sudo raspi-config
		
	- Select __7 Advanced Options__ from the menu.
	- Select __A1 Expand Filesystem__.
	- Press __Enter__ at the "Root partition has been resized" screen.
	- Press the __TAB__ key to select __Finish__, then press __ENTER__.
	- Select __Yes__ to reboot.
1. Once the desktop appears, click __Raspberry > Hamradio > Update Pi and Ham Apps__ and check __Raspbian OS and Apps__, then click OK.  This will download and install the latest OS updates.  Reboot if prompted to do so.

	Alternatively, you can open a Terminal window and run these commands:

		sudo apt-get update
		sudo apt-get upgrade -y
		
	Close the terminal window when the commands finish running (type `exit` and press __ENTER__).
	
	Both methods are equivalent.
	
1. Click __Raspberry > Preferences > Raspberry Pi Configuration__, then click __Change Password__ to set your password.  Click __OK__, and __OK__ again.
1. Change the Hostname of your Pi as desired.
1. If the outside edge of the desktop appears cut off on your monitor, Enable __Overscan__.
1. Click __OK__.
1. Click __Yes__ if prompted to reboot.
1. Click __Raspberry > Hamradio__ to access the ham applications.

## Update and Install Ham Applications

1. Click __Raspberry > Hamradio > Update Pi and Ham Apps__.  Check the applications you want to update or install and click __OK__.  Some installations take a very long time.  Don't install an application unless you understand what the application is for.  __*Installing an application does not configure it. Consult the documentation for that application for configuration instructions*__.
1. As you already know from the First Time Boot-up Instructions, checking the __Raspbian OS and Apps__ item in the GUI will check for and install OS updates.  This is equivalent to running the following commands in a Terminal:

		sudo apt-get update
		sudo apt-get upgrade -y

	I recommend checking for updates for __Raspbian OS and Apps__ once a week.

## (Optional) Customize the Main Menu

__WARNING:__ There is a long time bug in the Main Menu Editor that resets the menu settings to default when you click the __Cancel__ button.  So, *NEVER* click the __Cancel__ button!  Even if you made no changes, click __OK__ instead.

1. Click __Raspberry > Preferences > Main Menu Editor__.  
1. Select __Hamradio__ in the left pane.
1. Check or uncheck the applications listed in the center pane as desired.
1. Click the __Up__ or __Down__ buttons to move the selected item up or down in the menu list.  Add or remove separators in the menu list as desired.
1. Note that the __Configure RMS Gateway__ item is not checked and so does not appear in the menu.  If you decide to use this Pi as an RMS Gateway, check this item to enable the configuration GUI for the RMS Gateway.  Note that operating an RMS Gateway requires that you obtain a "Sysop" account at winlink.org.  There are other requirements as well.  If you operate the Pi as an RMS Gateway, I strongly recommend that you don't use the Pi for any other purpose.
1. Click __OK__ (*never* click __Cancel__!) when done.

## Customize the Fldigi Apps

1. In Fldgi: __Configure > UI > Operator__.  Note you have to do this for both the __Fldigi (Left Radio)__ *and* __Fldigi (Right Radio)__ menu items.
1. In Flmsg: __Config > Personal__ tab.  Note that you have to do this for both the __Flmsg (Left Radio)__ *and* __Fldigi (Right Radio)__ menu items.

## Adjust the Audio Levels

These settings are designed to get you somewhat close to the right audio levels.  Some adjustment will be necessary as every radio is different, and different ham radio applications have different audio level requirements.  

__IMPORTANT__: While in the __Audio Device Settings__ app, __*DO NOT*__ click the __Make Default__ button!  That makes the Fe-Pi your default audio interface, which you do not want to do.
1. Click __Raspberry > Preferences > Audio Device Settings__.  
1. Select __Fe-Pi Audio__ from __Sound card:__ the drop-down.  
1. Select the __Playback__ tab and adjust __Lineout__ to 100% (all the way to the top).  Adjust the PCM so it's about 80% of the way to the top.  Note that you can click the button with the chain links so you can independently adjust the left channel (left radio) and right channel (right radio) TX levels.
1. Click the __Switches__ tab and check the __Capture Attenuate Switch (-6dB)__.
1. Click the __Capture__ tab.  Adjust the __Capture__ setting so it's about 10% of the way up from the bottom.  Again, click the button with the chain links so you can independently adjust the left channel (left radio) and right channel (right radio) RX levels.
1. Click __OK__ when done.  

	Alternatively, all of these audio settings can be done in a Terminal window as well.  Open a terminal and run:

		alsamixer
		
	Select __Fe-Pi__ as the sound interface and press __F5__ to show both the Capture and Playback settings.
1. There are PulseAudio controls under __Raspberry > Sound & Video__.  I recommend leaving those settings as-is unless you are very familiar with configuring PulseAudio.

W6AF has published a [guide to setting FM audio levels](https://w6af.com/local-radio-activity/digital-modes/setting-up-sound-levels-for-fm-digital-operation/) that seems to work well.  
IMPORTANT: W6AF's instructions assume that you have the Fldigi waterfall settings set to default values, which are:
- Upper signal level (db): 0 
- Signal range (db): 60
- Tx level attenuator (db): -3

The above 3 settings are at the bottom of the Fldigi window.

