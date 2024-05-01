![image](https://user-images.githubusercontent.com/7725197/209851202-7e9bab6d-1ec1-4161-99de-54106cb87166.png)

# RPDP: Remote terminal simulators for the PiDP-10

Terminal simulators for remote access to a PiDP-10.  
Convert a laptop, desktop or second Raspberry Pi into a Knight TV or DEC VT-52 terminal for your PiDP-10.  
<br>
Supports:
- Linux X86_64 (Ubuntu)
- Windows 11 with WSL subsystem (Ubuntu)
- Raspberry Pi (Bookworm 64 bit)
<br>
Included terminal simulators:
- Knight TV
- DEC VT-52
- Datapoint 3300
- Tektronix 4010
- Imlac
<br><br>

![image](https://github.com/obsolescence/rpdp/assets/7725197/db915e52-a471-4657-ab89-e9865446fb9c)

  
# Installation:

`cd /opt`  
`sudo git clone https://github.com/obsolescence/rpdp`  
`/opt/rpdp/install/install-rpdp.sh`  
`
<br>
- the install script will ask you for the hostname of your PiDP-10 (pidp10, for example) and the user name on the Pi (pi, for example).
- it will modify pdp.sh and imlac.simh, and as this is an early alpha version - in case of trouble, just check those two files


# Use:

Just like the `pdp` command on the PiDP-10 itself, so just type `rpdp vt52` for a VT-52 terminal connection, etc.

## Terminals:
- `rpdp tvcon` -- Knight TV terminal
- `rpdp vt52` -- DEC VT-52 terminal
- `rpdp dp3300` -- Datapoint 3300 terminal
- `rpdp imlac` -- Imlac terminal/minicomputer
- `rpdp tek` -- Tektronix 4010 storage tube graphics terminal
<br>
Don't forget to press F11 for full-screen mode!

## Teletypes:
- `rpdp con` -- Noisy & Slow Teletype console
- `rpdp telcon` -- Quiet & Fast Teletype console
<br>
Don't forget, if you want to switch Teletypes in mid-flight, leave the first Teletype properly (Ctrl-[, quit) or the line will not be free for the new one.

<br>
  
# Warning...

Note: very early beta version, and this version particularly *depends on your system using the apt package manager* (Ubuntu, Debian). 
<br>Edit install-rpdp.sh to use any other package manager.
<br>
So far, only tested on Ubuntu 22.04. Let me know of any problems on other systems.
There's been confirmation that the incuded binaries work on Windows 11 with WSL subsystem (Ubuntu). The bin/pdp.sh has not been tested on Windows yet though. Feedback requested!
<br>
The install script assumes /usr/local/bin is an existing directory, in your PATH. Otherwise, the command 'pdp' will not be found; in that case try '/opt/rpdp/bin/rpdp.sh ?' to see if that works.
