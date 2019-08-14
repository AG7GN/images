## (Optional) Enabling, configuring and disabling Auto-HotSpot

Version: 20190813

Author: Steve Magnuson, AG7GN

Auto-HotSpot is a feature that allows the Raspberry Pi to become a "HotSpot" (WiFi access point). This allows other computers, phones, and tablets to connect to and operate the Pi (using [VNC](https://www.raspberrypi.org/documentation/remote-access/vnc/)) over WiFi even if your Pi is not connected to the Internet or local network. This Auto-HotSpot uses the [script written by roboberry](http://www.raspberryconnect.com/network/item/330-raspberry-pi-auto-wifi-hotspot-switch-internet) for use on Raspbian Stretch or Buster.

When Auto-HotSpot is active, the Pi advertises a network name (Service Set IDentifier - SSID) and looks to other computers/tablets/phones like a WiFi access point.  You can set your Auto-HotSpot's SSID and the password using the __Manage Auto-HotSpot__ script at __Raspberry > Preferences > Manage Auto-HotSpot__.

## Operational Notes

1.  The Pi will create a HotSpot if __none__ of the configured WiFi networks (as defined in `/etc/wpa_supplicant/wpa_supplicant.conf`) are within range and Auto-HotSpot is installed and enabled.  Otherwise, your Pi will connect to your WiFi network like any other client.

1. Internet access is not required for Auto-HotSpot to work.  But, if the Pi's ethernet port is connected to a network that has Internet access, the Pi (if Auto-HotSpot is active) will be come a router and act as a HotSpot with Internet access to any WiFi client that connects to it.

1. When Auto-HotSpot is active, if you hover your mouse over the network icon in the menu bar in the upper right corner of the screen (just to the left of the speaker icon), you will see a status of "wlan0:STOPPED".  That means the Pi's WiFi interface is in hotspot mode.

1. When Auto-HotSpot is inactive or uninstalled, clicking on the network icon should show a list of available WiFi networks.  Select the desired network and provide the password.  Once connected, this network will automatically be added to the `/etc/wpa_supplicant/wpa_supplicant.conf` file.  If you install/enable Auto-HotSpot at this point, the HotSpot will not activate as long as your Pi can connect to this WiFi network.

- If you no longer want to use the WiFi network the Pi is currently connected to, click on the opposing arrows icon, then right-click on the checked network.  Click __OK__ when prompted "Do you want to disconnect from the Wi-Fi network...?".  This will remove this WiFi network from `/etc/wpa_supplicant/wpa_supplicant.conf`.  Remember that if you disconnect while operating the Pi remotely, you will "saw off the limb you're sitting on" and will be disconnected from the Pi.

## Configuration

1. You can remove, reinstall, or reconfigure Auto-HotSpot at any time by running the __Manage Auto-HotSpot__ script at __Raspberry > Preferences > Manage Auto-HotSpot__.  Follow the instructions provided by the script.

1. If 'Check WiFi' is enabled (that is, set to any value other than 'No') in the __Manage Auto-HotSpot__ configuration screen, a cron job will be installed in the user's crontab that will periodically check to see if any configured WiFi networks are in range and if so, it will automatically disable Auto-HotSpot and instead connect as a client to that network.  All users connected to your Pi's HotSpot will be disconnected if that happens.

	If you set 'Check WiFi' to 'No', you must reboot the Pi to change the state of the Auto-HotSpot.

1. Once it's installed, when you run __Manage Auto-HotSpot__ thereafter, you'll be presented with options to remove or reconfigure Auto-HotSpot.

1. For more details on how the HotSpot operates "under the hood" see the [original article](http://www.raspberryconnect.com/network/item/330-raspberry-pi-auto-wifi-hotspot-switch-internet) on which this is based.
