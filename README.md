# Hampi Image

Version 20191214.5

Author: Steve Magnuson, AG7GN

&#x1F6D1;   __**IMPORTANT**__:  As of late January, 2020, a bug in the Linux kernel used in the production release of Raspbian causes the Fe-Pi sound card not to work.  You can use this Hampi image as is, but after you install it, please DO NOT udpate the Raspbian OS until this bug is fixed.  I'll update the documentation here when it's OK to update Raspbian. 

## Prerequisites

- Raspberry Pi 3B, 3B+ or 4B.  The 2GB version of the 4B is fine.
- [Fe-Pi Audio Z Version 2 sound card](https://fe-pi.com/products/fe-pi-audio-z-v2)
- Budd Churchward's ([WB7FHC](http://wb7fhc.com/index.html)) excellent DigiLink (REV C or later) or [Nexus DR-X](http://wb7fhc.com/intro.html) board
- 16GB or greater MicroSD card (a 16GB card is more than adequate)
- OPTIONAL: Speakers attached to Pi's built-in audio jack or an HDMI monitor with speakers if you want to monitor the radio's TX and/or RX

This image uses the default configuration for user __pi__:  
- User pi's home directory is __/home/pi__
- User __pi__ has passwordless __sudo__ privileges.  
- The desktop automatically starts without requiring a password for user __pi__.

The default password for user __pi__ is __changeme__.  __*PLEASE CHANGE THIS* as described below!__

## Features

- Uses the latest official Debian 10 (Buster) Raspberry Pi OS (aka "Raspbian")

- Fldigi, Flmsg, Flamp, Flarq are installed and minimally configured to use PulseAudio and 1 or 2 radios.  You must set your call sign and name, among other things, in the Fldigi and Flmsg settings.
- Flrig is installed and configured for use with 1 or 2 radios, but it is not visible on the __Hamradio__ menu by default.  See the [Customize the Main Menu](#customize-the-main-menu) section for information on customizing the menu.
- Direwolf is installed and configured for use with PulseAudio with 1 or 2 radios.
- You'll see __Configure RMS Gateway__ in the __Hamradio__ menu.  __Most users should ignore this menu item.__ This is only needed if you want this Pi to operate as an [RMS Gateway](https://www.winlink.org/tags/gateway).  

	__*Note that operating an RMS Gateway requires that you obtain a "Sysop" account at winlink.org.*__ There are [other requirements](https://www.winlink.org/content/join_gateway_sysop_team_sysop_guidelines) as well.  If you operate the Pi as an RMS Gateway, I strongly recommend that you don't use the Pi for any other purpose.
- There are menu items to toggle on and off TX and RX audio monitoring.  This only works if you have speakers connected to your Pi's built-in audio jack or your HDMI monitor has speakers.
- Recognizes and enables a DS3231 Real Time Clock module, if installed.
- A script is installed and enabled to restart or shutdown the Pi if the pushbutton on the board is pressed (DigiLink Rev __DS__ or [Nexus DR-X](http://wb7fhc.com/intro.html) boards only).  
	- If the button is pressed for 2 <= *t* < 5 seconds then released, the Pi will reboot.  
	- If the button is pressed for *t* >= 5 seconds then released, the Pi will shutdown. 
		- Note that newer versions of the Nexus DR-X have an LED that turns on when the button is pressed for 2 <= *t* < 5 and turns off again when the button continues to be pressed for *t* >= 5 to give you a visual cue as to when to release the button to reboot or shutdown.			  
		- Older "DigiLink" boards (prior to the [Nexus DR-X](http://wb7fhc.com/intro.html)) must have the GPIO jumper installed in the '26' position for this to work.  If you want to use GPIO 13 or 6 instead (by moving the DigiLink GPIO jumper), you can edit the `/usr/local/bin/shutdown_button.py` file and set the `use_button` variable to 13 or 6 respectively.  The [Nexus DR-X](http://wb7fhc.com/intro.html) board is hard wired to GPIO 26 for this purpose - it cannot be changed.
- Watchdog service is enabled.  If the Pi locks up, it *should* automatically reboot within 10 seconds.
- Includes a GUI called the "Updater" to make it easier to install and update various ham applications.
- Supports bootup user scripting based on the lever positions of the piano switch on the [Nexus DR-X](http://wb7fhc.com/intro.html) board.  A sample user script is in `/home/pi/pianoX.sh.example`.  Here's more information about [how it works](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#check-piano-script).

## New in This Version

- Latest OS and Raspberry Pi application updates installed.
- The `initialize-pi.sh` script now automatically expands the filesystem on first boot.
- Latest [Kenwood TM-D710G/TM-V71A](https://github.com/AG7GN/kenwood) radio control script installed.
- Trim scripts, which are used to keep various Fldigi/Flmsg/Flrig log files to a reasonable size, have all been modified to not execute if the fl* app is running.  These scripts are run automatically when you select Fldigi/Flmsg/Flrig from the __Hamradio__ menu.  They are executed just before starting the Fl* app when Fl* app is launched from the Hamradio menu.
- `tnc.sh` script has been updated to allow the user to specify the configuration file, overriding the default `$HOME/tnc.conf` file.
- Desktop background now shows Nexus DR-X Logo.
- Fixed a bug that made PulseAudio the default sound card whenever PulseAudio was updated.

## GPIO Pins

The Hampi image and the Nexus DR-X board use the following GPIO pins (BCM numbering):

| GPIO Pin (BCM) | Purpose |
| :---: | :---: |
| 12 | PTT Left Radio |
| 23 | PTT Right Radio |
| 26 | Shutdown Button |
| 24 | Shutdown Button LED |
| 25 | Piano switch position 1 |
| 13 | Piano switch position 2 |
| 6 | Piano switch position 3 |
| 5 | Piano switch position 4 |

## Installation

1. Assemble the DigiLink or [Nexus DR-X](http://wb7fhc.com/intro.html) board and install it and the Fe-Pi audio board onto the Pi.
1. The Hampi image is larger than the allowed file size on GitHub, so I store the image on a Google Drive.  The Hampi image is approximately 3.7 GB.  
	- [Access my Google Drive](https://drive.google.com/open?id=1qZRAePj7dGRNWPNw44RKKm8SvmTg81ru) 
	- Click the __Download__ button when prompted with the "Whoops! There was a problem with the preview." window.
1. Burn the image to your SD card by following these ["Writing an image to the SD card"](https://www.raspberrypi.org/documentation/installation/installing-images/)  instructions.  Since you've already downloaded the image in the previous step, ignore the "Download the image" section on that web page.
1. Insert the MicroSD card into the Pi and power it on.
1. The easiest way to get your Pi set up on first boot-up is to connect it to a keyboard/video/mouse (KVM).  However, there is an alternative way to access your new Pi without a KVM, even before you've configured it:  

	- By default, the [VNC server](https://github.com/AG7GN/images/blob/master/README-Using_VNC_to_Operate_Remotely.md) is enabled on the Pi.  If you plug your Pi into an ethernet port on your home network and [install the VNC Viewer application](https://www.realvnc.com/en/connect/download/viewer/) on another PC or Mac or Chromebook also on your home network, you can connect to and control your new Pi using VNC Viewer from that PC or Mac or Chromebook.  
	- Once the Pi has fully booted up, open VNC Viewer on your other computer and enter `hampi.local` into the address bar at the top of the VNC Viewer window, then press __Enter__.  Follow the instructions and login with Username __pi__ and the default password __changeme__.  
	
## First Time Boot Instructions

__*PLEASE* DO THESE STEPS before seeking help!__

1. You'll notice the first time you start the Pi with this image that it immediately reboots within a few seconds of the desktop appearing.  This is expected behavior and is caused by a script that runs on first boot that resets the VNC and SSH client and server keys among other things.  This happens only at the first boot-up.  Also, the first time bootup takes a bit longer than usual because the filesystem is expanded to the size of the microSD card.

1. Connect your Pi's ethernet port to your home network or use the Pi's wifi to connect to your home network.  For WiFi:
	- Click on the network icon (just to the left of the speaker icon) on the Pi's top menu bar.  
	- Select your WiFi network from the list (NOTE: it make take a minute or 3 for the WiFi networks your Pi can see to appear in that list) and follow the instructions on the screen.
	
1. Click __Raspberry > Preferences > Raspberry Pi Configuration__, then click __Change Password__ to set your password.  Click __OK__, and __OK__ again.  

1. If the outside edge of the desktop appears cut off on your monitor or your desktop doesn't fully fill your monitor's screen, enable or disable __Overscan__ as needed to fix the problem.  

1. Change the Hostname of your Pi as desired - don't leave it set to `hampi`.  It's a good idea to include your call sign in the hostname to make it unique.  Example: __hampi-ag7gn__.  By convention, hostnames are lower case, but there's no harm in using capital letters.  You can use any name, but the only non-alphanumeric character allowed is a dash (-).

1. Click __OK__.

1. Click __Yes__ if prompted to reboot.

1. When the desktop appears, run the Updater: Click __Raspberry > Hamradio > Update Pi and Ham Apps__, then, *only if prompted to do so*, re-run __Raspberry > Hamradio > Update Pi and Ham Apps__.  <s>Check __Raspbian OS and Apps__ and click __OK__.  Reboot if prompted.</s>

## <s>Update Raspbian OS and</s> Update/Install Ham Applications
&#x1F6D1;   __**IMPORTANT**__:  As of late January, 2020, a bug in the Linux kernel used in the production release of Raspbian causes the Fe-Pi sound card not to work.  DO NOT udpate the Raspbian OS until this is fixed.  I'll update the documentation here when it's OK to update Raspbian. 


1. Click __Raspberry > Hamradio > Update Pi and Ham Apps__ to run the Updater.  Check the application(s) you want to update or install and click __OK__.  Some installations take a very long time.  Don't install an application unless you understand what the application is for.  __*Installing an application does not configure it*__. Consult the documentation for that application for configuration instructions.

	You can double-click on the app name in the Updater to obtain information about that app.  This will open the Chromium browser and and take you to the website for that app.

1. <s>As you already know from the [First Time Boot Instructions](#first-time-boot-instructions), checking the __Raspbian OS and Apps__ item in the Updater will check for and install OS updates.  This is equivalent to running the following commands in a Terminal:

		sudo apt update
		sudo apt upgrade -y

	I recommend checking for updates for __Raspbian OS and Apps__ about once a week.</s>

## Customize the Main Menu

This is strictly __OPTIONAL__ - only if you want to change what appears on the menu or the menu layout.

__WARNING:__ There is a long time bug in the Main Menu Editor that resets the menu settings to default when you click the __Cancel__ button.  So, *NEVER* click the __Cancel__ button!  Even if you made no changes, click __OK__ instead.

FYI: If you make changes to a particular menu item, a new desktop file will be created in `/home/pi/.local/share/applications` and that file will be used to populate the menu even if there is a `.desktop` file with the same name in the default location `/usr/local/share/applications`. 

1. Click __Raspberry > Preferences > Main Menu Editor__.  

1. Select __Hamradio__ in the left pane.
1. Check or uncheck the applications listed in the center pane as desired.
1. Click the __Up__ or __Down__ buttons to move the selected item up or down in the menu list.  Add or remove separators in the menu list as desired.
1. Click __OK__ (*never* click __Cancel__!) when done.

## Customize the Fldigi Apps

1. In Fldgi: __Configure > UI > Operator__.  Note you have to do this for both the __Fldigi (Left Radio)__ *and* __Fldigi (Right Radio)__ menu items.

1. In Flmsg: __Config > Personal__ tab.  Note that you have to do this for both the __Flmsg (Left Radio)__ *and* __Flmsg (Right Radio)__ menu items.

## Direwolf Notes

User pi's home folder contains 2 Direwolf configuration files: `/home/pi/direwolf-left.conf` and `/home/pi/direwolf-right.conf`.  If you are going to use Direwolf as a KISS or AGW TNC with a Windows RMS Express client or Xastir, there's no need to change `MYCALL` in these files from the default `N0ONE-10`.  Those applications will supply your call sign to Direwolf via the KISS or AGW connection.  You can change `MYCALL` in these files if you'd like, of course.

If you want to use this Pi as an APRS Digipeater and/or iGate, use the [`/usr/local/bin/tnc.sh`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#tnc-script) and associated [`/usr/local/bin/watchdog-tnc.sh`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#watchdog-tnc-script) scripts. 

`tnc.sh` also works with `pat` and `arim`, which you can install using the Updater: __Raspberry > Hamradio > Update Pi and Ham Apps__.  `tnc.sh` creates on on-the-fly direwolf configuration file depending on what mode you want to use.  It will also allocate a `pty` for `pat` (`pat` can't use KISS).  

The configuration files for `tnc.sh` are in [`/home/pi/tnc-left.conf`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#tnc-left-tnc-right-configuration-files) and [`/home/pi/tnc-right.conf`](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#tnc-left-tnc-right-configuration-files).  You can also supply the name of a configuration file as an argument to `tnc.sh`.  See [the tnc.sh documentation](https://github.com/AG7GN/hampi-utilities/blob/master/README.md#tnc-script) for more information.

## Operating Your Pi "Headless" (without a keyboard, monitor or mouse)

This is __OPTIONAL__.  See [these instructions](https://github.com/AG7GN/images/blob/master/README-Using_VNC_to_Operate_Remotely.md).

## Bugs

Probably.  WATCH THIS SPACE.  I will post bug information and workarounds here.

### Fe-Pi Sound Card 

&#x1F6D1;   __**IMPORTANT**__:  As of late January, 2020, a bug in the Linux kernel used in the production release of Raspbian causes the Fe-Pi sound card not to work.  You can use this Hampi image as is, but after you install it, please DO NOT udpate the Raspbian OS until this bug is fixed.  I'll update the documentation here when it's OK to update Raspbian. 

### Fldigi Alert Sounds

Fldigi versions 4.1.08 and earlier have a bug that causes it to crash if any of the __Test__ buttons are clicked or if any alert sounds are enabled in the __Configure > Sound Card > Alerts tab__ and then triggered.  The bug is related to Hampi's using PulseAudio for the radio sound interface and seems to be limited to Raspberry Pi computers.  This has been fixed in version 4.1.09.  

## Annoyances

Things that aren't really bugs, but irritating nevertheless will be documented here.

## Related Information

[Adjusting Audio Levels](https://github.com/AG7GN/images/blob/master/README-adjust_audio_levels.md)

[Configuring and Using Auto-HotSpot on Hampi](https://github.com/AG7GN/images/blob/master/README-auto_hotspot.md)

[Operating Your Hampi "Headless"](https://github.com/AG7GN/images/blob/master/README-Using_VNC_to_Operate_Remotely.md)

