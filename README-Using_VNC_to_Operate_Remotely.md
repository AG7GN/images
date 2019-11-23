## (Optional) Using VNC Connect to operate your Pi remotely

Version: 20191123

Author: Steve Magnuson, AG7GN

The Pi comes installed with __VNC Server__ software that allows it to be accessed from anywhere over your local network or the Internet.  This requires installing __VNC Viewer__ software on another computer.  This also allows your Pi to operate "headless" - without a keyboard video monitor and mouse (KVM) attached.  If you want to enable this functionality, follow these instructions.

### Configuration

__Your Pi must be connected to the Internet.__

__You must have a Keyboard/Monitor/Mouse (KVM) attached to the Pi for the configuration steps below.__

1. On your PC or Mac or ..., (in other words, the computer/tablet from
which you want to remotely access your Pi) download and install [VNC Viewer software](https://www.realvnc.com/en/connect/download/viewer/).  Your device running __VNC Viewer__ is called the __client__.  Note on that web page that you can download __VNC Viewer__ for tablets and Chromebook computers, too.

1. On your client (PC/Mac/etc) browser go to [VNC Connect for Raspberry Pi](https://www.realvnc.com/en/raspberrypi/).

1. Scroll down to the __Sign up for a free RealVNC account__ section, enter your email
address and click NEXT.  Follow the instructions to complete your account setup.

1. On your Pi, click the VNC icon located on the menu bar in the upper right corner of the Pi's desktop.

1. Click the __3 horizontal lines__ icon in the upper right of the VNC Server window.  Select __Licensing...__.

1. Check __Sign in to your RealVNC account__, click __Next__.  Sign in with the RealVNC credentials you created earlier.  Click __Next__.

1. Select your team from the dropdown.  Click __Next__.

1. Select __Direct and cloud connectivity__.  Click __Next__.  Click __Apply__.

1. Check the __Do not display this message again__ box on the __Granted permissions...__ window.  Click __Close__.  Click __Done__.

1. Close the VNC Server window by clicking the __X__ in the upper right corner.

### Connecting to your Pi using VNC Connect from anywhere (cloud brokered connection)

1. On your client, start __VNC Viewer__ and log in, if prompted, using your VNC Connect account credentials.  You should see your team on the left and your Pi on the right.  __Double-click__ the computer icon representing your Pi and log in.  If you're prompted for username and password at this point, the username is __pi__ and the password is whatever you changed your Pi's password to when you installed the image.  *This is NOT your VNC account password!* You can run VNC from anywhere (doesn't have to be from home) and connect to your Pi's desktop.

1. The __VNC Viewer__ controls are in a pop-down menu at the top of the viewer window.  Hover your mouse in the top center of the window just below the title bar and a graphical menu will drop down.  You can resize or close the viewer or open a chat session among other things.  Chat is used in situations where 2 or more viewers are connected to the Pi at the same time - you can open a chat session that all viewers can participate in.  There's also a file transfer feature that allows you to move files between your Pi and your client.  See the VNC Viewer [documentation](https://www.realvnc.com/en/connect/docs/index.html) for more information.

1. You can go to [RealVNC's website](https://manage.realvnc.com/en/), log in
and manage your team's computers from there.  You can have up to 5 computers (they don't all have to be Pis) and 2 other VNC Connect users as part of your team with the free VNC account.

	Now as long as your Pi is connected to the Internet, you can operate it from any Internet connected device running __VNC Viewer__ software.  This is called a "cloud brokered" connection: Your Pi sets up and maintains a connection with a server at [Real VNC](https://www.realvnc.com/en/connect/).  When you use __VNC Viewer__ on your client, it also creates a connection to [Real VNC](https://www.realvnc.com/en/connect/), and Real VNC "connects" your client to your Pi "in the cloud".

### Connecting to your Pi directly (locally)

The previous section, __Connecting to your Pi using VNC Connect from anywhere__, describes a method that will work from anywhere, including the case where your client running __VNC Viewer__ is on the same network as your Pi.

However, for the situation where the Pi and your client are on the same local area network (both devices are on your home network, for example), there's another way to connect that may be slightly faster.  This connection goes directly from your client to your Pi - there's no connection via the "cloud".

1. Open __VNC Viewer__ on your PC/Mac/tablet.

1. In the field at the top of the __VNC Viewer__ window, type the hostname of your Pi, which you should have set when you booted your Pi for the first time.  (If you haven't changed the default hostname, __hampi__, please change it: __Raspberry > Preferences >Raspberry Pi configuration__.  Changing the hostname will require a reboot).

	For example, my Pi's hostname is hampi-ag7gn, so I'd enter `hampi-ag7gn` in the field.
	If you are running __VNC Viewer__ on a Mac or Linux, you would enter the hostname followed by `.local`.  Example: `hampi-ag7gn.local`, then press __ENTER__.
	
	Alternatively, you can enter your Pi's IP address in this field.  You can find your Pi's IP address on the Pi's desktop by hovering your mouse over the network icon (just to the left of the speaker icon) on the Pi's menu bar.  It'll display something like this:
	
		wlan0: Configured 192.168.1.123/24
	In that case, you'd enter `192.168.1.123` into your client __VNC viewer's__ field.
	
1. Log in with username __Pi__ and whatever you set your Pi password to.  *This is NOT your VNC account password!*.

### Customization

1. Screen resolution
	- You may find that apps you run on your Pi are "too big to fit" into your VNC viewer window.  I've found the way to fix this is to set the resolution of your Pi.  You can do this while VNC'd into your Pi.
	- Click __Raspberry > Preferences > Raspberry Pi Configuration__.  Click __Set Resolution__.  
	
		I select the highest resolution (__DMT mode 82 1920x1080 60Hz 16:9__).  The VNC Viewer software on your PC will scale it as necessary, but you may have to experiment with the Pi resolution settings to get something that works for you.  After you change the resolution, you must reboot the Pi. 
	
	

	
	

