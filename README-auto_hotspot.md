## (Optional) Remotely Access and Operate your Pi using VNC Connect

The Pi comes installed with VNC Server software that allows it to be accessed from anywhere over your local network or the Internet.  This requires installing __VNC Viewer__ software on another computer.  This also allows your Pi to operate "headless" - without a monitor, keyboard and mouse attached.  If you want to enable this functionality, follow these instructions.

Your Pi must be connected to the Internet.

1. On your PC or Mac or Chromebook or ..., (in other words, the computer from
which you want to remotely access your Pi) download and install [VNC Viewer software](https://www.realvnc.com/en/connect/download/viewer/).

1. On your PC/Mac/etc browser or on your Internet-connected Pi browser go to [VNC Connect for Raspberry Pi](https://www.realvnc.com/en/raspberrypi/).

1. Scroll down to the __Sign up for a free RealVNC account__ section, enter your email
address and click NEXT.  Follow the instructions to complete your account setup.

1. On your Pi, click the VNC icon located in the upper right corner of the Pi's
desktop.

1. Click the 3 horizontal lines icon in the upper right of the VNC Server
window.  Select __Licensing...__.

1. Check __Sign in to your RealVNC account__, click __Next__.  Sign in with the
RealVNC credentials you created earlier.  Click __Next__.

1. Select your team from the dropdown.  Click __Next__.

1. Select __Direct and cloud connectivity__.  Click __Next__.  Click __Apply__.

1. Check the __Do not display this message again__ box on the __Granted
permissions...__ window.  Click __Close__.  Click __Done__.

1. Close the VNC Server window by clicking the __X__ in the upper right corner.

1. On your PC/Mac/etc, start __VNC Viewer__ and log in.  You should see your
team on the left and your Pi on the right.  Double click the computer icon representing your Pi and log in.  If you're prompted for username and password at this point, the
username is __pi__ and the password is whatever you changed your Pi's password
to when you installed the image.  *It is NOT the VNC account password!*. You can
run VNC from anywhere (doesn't have to be from home) and connect to your Pi's desktop.

1. You can go to [RealVNC's website](https://manage.realvnc.com/en/), log in
and manage your team's computers from there.  You can have up to 5 computers (they don't all have to be Pis) and 2 other users as part of your team with the free VNC account.

