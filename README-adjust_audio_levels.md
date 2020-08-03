## Adjust the Audio Levels

Version: 20200803

Author: Steve Magnuson, AG7GN

These settings are designed to get you somewhat close to the right audio levels.  Some adjustment will be necessary as every radio is different, and different ham radio applications have different audio level requirements.  

1. Click __Raspberry > Accessories > Terminal__ to open a Terminal window. Run this command:

		alsamixer

1. Press __F6__ and select __Fe-Pi Audio__ from the list.  
1. Press __F5__ to view both Playback and Capture settings. Move the left and right arrow keys to highlight the setting you wish to change.
1. Some controls are in stereo.  The up and down arrows change the levels of both left (for the left radio) and right (for the right radio) channels.
      
	Pressing __Q__ or __E__ increases the just the left or right channel (radio) level respectively. 
	
	Pressing __Z__ or __C__ decreases the just the left or right channel (radio) level respectively.

	For the Fe-Pi, these levels are good starting points, but you'll likely have to adjust them for your radio(s):

	Headphone: _00_   
	Headphone Mux: _DAC_   
	Headphone Playback ZC: _00_  
	PCM: _89_ (left), _89_ (right)    
	Lineout: _100_ (left), _100_ (right)   
	Mic: _0_   
	Mic: _0_  
	Capture: _13_ (left), _13_ (right)  
	Capture Attenuate Switch: _00_  
	Capture Mux: _LINE_IN_   

	Leave the remaining settings as they are.  

	Using the above settings as a baseline, these are the settings you'll want to tweak further while running Fldigi and/or direwolf: 

	__Capture__ (for audio coming from the radio into the Pi - radio RX)  
	__PCM__ (for audio coming from the Pi to the radio - radio TX)

	W6AF has published a [guide to setting FM audio levels](https://w6af.com/local-radio-activity/digital-modes/setting-up-sound-levels-for-fm-digital-operation/) using Fldigi that seems to work well.  
IMPORTANT: W6AF's instructions assume that you have the Fldigi waterfall settings set to default values, which are:
	- Upper signal level (db): 0 
	- Signal range (db): 60
	- Tx level attenuator (db): -3

	These 3 settings are at the bottom of the Fldigi window.

	Once you're happy with your audio settings, press __Esc__ to exit alsamixer.  

1. Save Audio Settings (usually not required)
	
	These audio settings should save automatically, but for good measure you can store them again by running:

		sudo alsactl store

	If you want to save different audio level settings for different scenarios, 
you can run this command to save the settings (choose your own file name/location):

		sudo alsactl --file ~/mysoundsettings1.state store

	...and this command to restore those settings:

		sudo alsactl --file ~/mysoundsettings1.state restore
	
	


