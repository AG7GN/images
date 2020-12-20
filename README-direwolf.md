# Notes on Customizing Direwolf

Version 20201220

Some hams want to operate Direwolf in ways that the GUIs in the Nexus image won't accommodate. These notes are for you.

## Prepare Raspbian Window Manager

1. Open the __File Manager__ (file folders icon in the top left of menu bar)

1.	Click __Edit > Preferences__. Select __General__.

1. Check the __Don't ask options on launch executable file__ box.

1. Click __Close__, the close the __File Manager__

## Create direwolf configuration file

- If you already have a configuration file set up to use the appropriate left/right radio with the Fe-Pi sound card and GPIO PTT for the Nexus image, put that file in your home folder and write down it's name. For these instructions, we'll assume it's called `mydirewolf.conf`, but you can name your configuration file anything you want.

- If you don't already have a configuration file set up to use the appropriate left/right radio with the Fe-Pi sound card and the GPIO PTT for the Nexus image:
	- Copy the template file into your home folder. For these instructions, we'll assume it's called `mydirewolf.conf`, but you can name your configuration file anything you want.

			cp /usr/local/src/nexus/nexus-utilities/direwolf.conf.sample $HOME/mydirewolf.conf

	- Edit `$HOME/mydirewolf.conf` as necessary for your application.

## Desktop Template

1. Copy the custom direwolf desktop template to your home folder

	- We're calling it `direwolf-custom.desktop` for these instructions, but you can call it whatever you want.

			cp /usr/local/src/nexus/nexus-utilities/direwolf.desktop.sample $HOME/.local/share/applications/direwolf-custom.desktop
	
1. Determine what Direwolf command line options you want to use

	- Open a Terminal and run:
	
			direwolf -h
		
		to see what command line options are available. __The only one required is `-c file`, which tells Direwolf what configuration file to use__. Complete documentation can be found in /usr/local/share/doc/direwolf or [online](https://github.com/wb2osz/direwolf/tree/master/doc).
		
1. Modify your custom direwolf desktop item to suit

	- Open `$HOME/.local/share/applications/direwolf-custom.desktop` in a text editor. The file looks like this:
	
			[Desktop Entry]
			Name=Direwolf (Custom)
			Comment=APRS Soundcard TNC
			Exec=lxterminal -t "My Custom Direwolf" -e "direwolf -c $HOME/mydirewolf.conf"
			Icon=direwolf_icon.png
			StartupNotify=true
			Terminal=false
			Type=Application
			Categories=HamRadio
			Keywords=Ham Radio;APRS;Soundcard TNC;KISS;AGWPE;AX.25

		`Name` is how it will be listed in the Hamradio menu. Change as desired.
	
		`Comment` is the tooltip that will appear when you hover your mouse over the entry in the Hamradio menu.
	
		`Exec` is what will actually execute when you click in the item in the Hamradio menu. 
		- The `-t "My Custom Direwolf"` is an `lxterminal` argument that sets what will appear in the top of the direwolf screen. Change as desired.
		- The `-e "direwolf -c $HOME/mydirewolf.conf"` is how direwolf will be run. 
			
			If you want to add direwolf arguments, insert them after `direwolf` and before `-c`. 
			
			If your direwolf configuration file has a different name or location, change `$HOME/mydirewolf.conf` as desired.
	
	- When you've finished your edits, save the file and close your editor.
	
1. Test it

	Click __Raspberry > Hamradio__ and look for your new menu item.  
	
	- If it's there, click it to run it.
	
	- If it's not there, then run __Raspberry > Preferences > Main Menu Editor__, then click __Hamradio__ in the left column, and scroll down to the bottom of the 2nd column. Your menu item should be there and probably not checked and greyed-out. Check it, then use the __Move Up__ and __Move Down__ buttons to move it to your desired location in the menu. Click __OK__ when done.

		__WARNING! *NEVER*__ click __Cancel__ in the Main Menu Editor! It will reset ALL menu settings to default values! Always click __OK__ even if you've made no changes.

## Launch from piano script

1. If you want to launch your new menu entry via a piano script at boot time, add this line to your piano script:
	
		xdg-open $HOME/.local/share/applications/direwolf-custom.desktop
	
	adjusting the name of the desktop file as needed.


	

