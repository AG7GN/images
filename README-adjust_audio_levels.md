## Adjust the Audio Levels

Version: 20191214

Author: Steve Magnuson, AG7GN

These settings are designed to get you somewhat close to the right audio levels.  Some adjustment will be necessary as every radio is different, and different ham radio applications have different audio level requirements.  

__IMPORTANT__: While in the __Audio Device Settings__ app, __*DO NOT*__ click the __Make Default__ button!  That makes the Fe-Pi your default audio interface, which you do not want to do.
1. Click __Raspberry > Hamradio > Audio Device Settings__.  
1. Select __Fe-Pi Audio__ from __Sound card:__ the drop-down.  
1. Select the __Playback__ tab and adjust __Lineout__ to 100% (all the way to the top).  Adjust the PCM so it's about 80% of the way to the top.  Note that you can click the button with the __chain links__ so you can independently adjust the left channel (left radio) and right channel (right radio) TX levels.
1. Click the __Switches__ tab and check the __Capture Attenuate Switch (-6dB)__.
1. Click the __Capture__ tab.  Adjust the __Capture__ setting so no more than 10% of the way up from the bottom.  Again, click the button with the __chain links__ so you can independently adjust the left channel (left radio) and right channel (right radio) RX levels.
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


