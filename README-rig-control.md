# Rig Control Hacks

Version 20200804

Author: Steve Magnuson, AG7GN

## Hack #1: Using FLrig when your application doesn't support using FLrig for rig control or PTT

### Scenario

- You have rig that can be controlled via FLrig
- You have an application that does not support FLRig, but does support rigctl/rigctld (part of Hamlib).
- You want to use FLrig for rig control and/or PTT.
- You are using the Nexus DR-X image.

### Solution

1. Instuctions differ for FLrig (Left Radio) and FLrig (Right Radio). 

	- FLrig (left radio) listens on the default FLrig port of `12345` by default. So, simply start FLRig (left radio) and then skip to the next step.

	- FLrig (right radio) will listen on `12346` and requires an extra step to make it work: 
	
		__For FLrig (right radio) *ONLY*__, you need to use `redir` to forward traffic to the default Flrig port `12345` to the FLrig (right radio)'s listener of `12346`. It's possible that `redir` is not installed, so install it. Open a Terminal and run

			sudo apt update
			sudo apt -y install redir

		then, run the following commmand. This will appear to just "hang" - that's normal. Press Ctrl-C to quit.
		
			redir --laddr=127.0.0.1 --lport=12345 --caddr=127.0.0.1 --cport=12346

		NOTE: You *CANNOT* be running FLrig (left radio) when you do this!
		
1.	Start the rigctl daemon using the "FLrig rig" (rig #4) either in a Terminal or using the Nexus DR-X Hamlib Rig Control GUI:

		rigctld -m 4
		
	This will create a TCP connection to `localhost:12345`, where `12345` is the default listener port for FLrig (or FLRig via `socat` if you're using FLrig (right radio)). 
	
1. Set up your app to use rigctl's "network" rig:

		rigctl -m 2 -r localhost:4532
	
	This will tell your app to communicate with rigctld at `localhost:4532`, the default port.
	In Direwolf, for example, it would look like this in direwolf.conf (Direwolf only supports PTT):
	
		PTT RIG 2 localhost:4532
		
1. Test your application's rig control and/or PTT.