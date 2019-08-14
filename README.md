# HOWTO Install the DigiLink+Pulse+FePi+RTC Raspberry Pi Image

Version: 20190810D

Author: Steve Magnuson, AG7GN

## Prerequisites

- Raspberry Pi 3B, 3B+ or 4 (NOTE: I have only tested this image with 3B and 3B+.)
- [Fe-Pi Audio Z Version 2 sound card](https://fe-pi.com/products/fe-pi-audio-z-v2)
- Budd Churchward's (WB7FHC) excellent DigiLink board (REV C or later) or equivalent GPIO controlled PTT interface that uses GPIO 12 for the left radio and GPIO 23 for the right radio
- 16GB or greater MicroSD card
- OPTIONAL: Speakers attached to Pi's built-in audio jack if you want to monitor the radio's TX and/or RX on the Pi's speakers
- Familiarity with the Pi's Terminal application, basic LINUX commands and the use of `sudo`

This image uses the default configuration for user __pi__:  pi's home directory is __/home/pi__ and user __pi__ has passwordless __sudo__ privileges.  The desktop automatically starts without requiring a password for user __pi__.

## Notes

- Uses the latest Debian 10 (Buster) Raspberry Pi OS
- Fldigi, Flmsg, Flamp, Flarq are installed and minimally configured to use PulseAudio and 1 or 2 radios.  You must set your call sign and name, among other things, in the Fldigi and Flmsg settings.
- Flrig is installed and configured for use with 1 or 2 radios, but it is not visible on the __Hamradio__ menu by default.  See the __Editing the Main Menu__ section for information on customizing the menu.
- Direwolf is installed and configured for use with PulseAudio with 1 or 2 radios.
- RMS Gateway software is installed but unconfigured and disabled.  RMS Gateway allows the Pi to be used as a Winlink gateway (requires special Sysop account from winlink.org).
- There are items to toggle on and off TX and RX audio monitoring.  This only works if you have speakers connected to your Pi's built-in audio jack or your HDMI monitor has speakers.
- Recognizes and enables a DS3231 Real Time Clock module, if installed.
- A script is installed and enabled to restart or shutdown the Pi if the DigiLink button is pressed (DigiLink Rev __DS__ boards only).  If the button is pressed for 2 <= *t* < 5 seconds then released, the Pi will reboot.  If the button is pressed for *t* >= 5 seconds then released, the Pi will shutdown.  Note that the GPIO jumper on the DigiLink board must be installed in the '26' position for this to work.  If you want to use GPIO 13 or 6 instead (by moving the DigiLink GPIO jumper), you can edit the `/usr/local/bin/shutdown_button.py` file and set the `use_button` variable to 13 or 6 respectively.
- Watchdog service is enabled.  If the Pi locks up, it should automatically reboot within 10 seconds.
- Includes GUI to make it easier to install and update various ham applications.

## Bugs

### FSQ Monitor window too big for screen

- Those of you who are using video monitors with resolutions less than 1920x1080 might notice that if you open the FSQ monitor window while running Fldigi, the FSQ monitor window is bigger than your monitor's screen, with both the top title bar and the window bottom extending beyond the boundary of the monitor's screen.  

#### The Fix:  

- Click anywhere inside the FSQ monitor window, then press __Alt+Space__ (__Alt__ and __Space bar__ keys at the same time). 
- Click __Move__ from the menu.  Note that the mouse pointer changes to two double-ended arrows, one on top of the other.
- Move (*don't click, just move*) your mouse down (or use the keyboard arrow keys) until the FSQ Monitor window title bar appears.
- Click your mouse or press __Enter__ to exit "move mode".  
- Move your mouse pointer to the top of the FSQ monitor window title bar.  You should see your mouse cursor change from a pointer to double arrow.
- Click and drag down to shrink the window to the desired size.  
- Click and drag *inside* the title bar to locate the window as desired.
- Click __Close__ in the FSQ Monitor window so Fldigi will remember the new window size the next time it opens.  

### __Update Pi and Ham Apps__ doesn't work for Xastir, WSJT-X and Chirp

- The script to install/update various ham applications does not work for Xastir, WSJT-X and Chirp.  This is because the latest versions of those programs have additional dependencies (additional applications or libraries) that the older versions of those programs didn't require.

#### The Fix:

- Make sure your Pi can access the Internet.
- Open a Terminal (click the 4th icon from the left on the top menu bar - the icon is black with '__>___' inside) and run these commands:
	
		cd ~
		git clone https://github.com/AG7GN/hamapps  
		sudo cp hamapps/*.sh /usr/local/bin
	
	This will install a new (fixed) version of the script that updates the ham applications on your Pi , and also adds the ability to easily "update the update script" by including it as an application in __Update Pi and Ham Apps__ in the __Hamradio__ menu.


## Changes

- OS and Raspberry Pi application updates.
- Added screensaver app.  By default, the screensaver is disabled.  To adjust, go to __Raspberry > Preferences > Screensaver__.
- Added GUI to install/remove/manage Auto-HotSpot. See __Raspberry > Preferences > Manage Auto-HotSpot__.
- Updated __tnc.sh__ script.
- Updated __initialize-pi.sh__ script.
- Updated __Fldigi__, __Flmsg__ and __Flrig__.
- Updated __iptables__ firewall rules.
- Updated __710.sh__ script (provides command line radio control for Kenwood TM-V71A and TM-D710G radios).

## Installation

1. Assemble the DigiLink board and install it and the Fe-Pi audio board onto the Pi.
1. [Download the image](https://drive.google.com/open?id=1EXXoKU0tRB-_dRrn3ndHDmkyGUySOOsI) (~2 GB) from my Google Drive.  Click the __Download__ button when prompted with the "Whoops! There was a problem with the preview." window.
1. Burn the image to your SD card by following the ["Writing an image to the SD card"](https://www.raspberrypi.org/documentation/installation/installing-images/)  instructions.  Since you've already downloaded the image in the previous step, ignore the "Download the image" section on that web page.
1. Insert the MicroSD card into the Pi and power it on.

## First Time Boot-up Instructions

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
1. Once the desktop appears, click __Raspberry > Hamradio > Update Pi and Ham Apps__ and check __Raspbian OS and Apps__, then click OK.  This will download and install the latest OS updates.  Reboot if prompted to do so.

	Alternatively, you can open a Terminal window and run these commands:

		sudo apt-get update
		sudo apt-get upgrade -y
		
	Close the terminal window when the commands finish running (type `exit` and press __ENTER__).
	
	Both methods are equivalent.
	
1. Click __Raspberry > Preferences > Raspberry Pi Configuration__, then click __Change Password__ to set your password.  Click __OK__, and __OK__ again.
1. Change the Hostname of your Pi as desired.  It's a good idea to include your call sign in the hostname to make it unique.  Example: __hampi-ag7gn__.  By convention, hostnames are lower case.
1. If the outside edge of the desktop appears cut off on your monitor, Enable __Overscan__.
1. Click __OK__.
1. Click __Yes__ if prompted to reboot.
1. Click __Raspberry > Hamradio__ to access the ham applications.

## Update OS and Update/Install Ham Applications

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
1. In Flmsg: __Config > Personal__ tab.  Note that you have to do this for both the __Flmsg (Left Radio)__ *and* __Flmsg (Right Radio)__ menu items.

