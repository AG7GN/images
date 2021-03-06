## Setting the Real Time Clock (RTC)

Version: 20190827

Author: Steve Magnuson, AG7GN

# !!! IMPORTANT !!! This procedure is no longer necessary.  The DS3231 clock sets itself once the Pi is connected to the Internet and acquires time from Network Time Protocol (NTP) server.

## The following instructions are retained for reference only.

1. Connect your Pi to the Internet if it isn't already.  

1. Open a Terminal.  Run this command:

		timedatctl

	The output should look similar to this:
	
	Verify the time is correct. If you just connected to the Internet or just started your Pi it may take a minute or 2 for you Pi to acquire the time from the Internet time server.  __Network time on__ and __NTP synchronided__ should both be __yes__.  If the time is not correct, check your Internet connection.
	
1. Run this command:

		sudo hwclock -w 
	
	Then run this command:
	
		sudo hwclock -r 
		
	The output of this command is the time on your RTC (hwclock).  It should now show the current time.
	
1. Close the Terminal window.
	