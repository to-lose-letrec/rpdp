![image](https://user-images.githubusercontent.com/7725197/209851202-7e9bab6d-1ec1-4161-99de-54106cb87166.png)

# RPDP: Remote terminal simulators for the PiDP-10

Terminal simulators for remote access to a PiDP-10.  
Convert a laptop, desktop or second Raspberry Pi into a Knight TV or DEC VT-52 terminal for your PiDP-10.  
<br>
Supports:
- Linux X86_64 (Ubuntu)
- NixOS (with flake.nix)
- Mac OS X (with flake.nix)
- Windows 11 with WSL subsystem (Ubuntu)
- Raspberry Pi (Bookworm 64 bit)
<br><br>
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

Note: very early beta version. This version is usable on Debian-based GNU/Linux distributions (using apt), or a system running Nix with Flakes enabled. The flake.nix has been tested on NixOS 24.11 and an M3 MacBook Pro running macOS 15 Sequoia, though there is no reason to suppose that a Windows system with WSL2 could not also work.

## Install scripts
Edit install-rpdp.sh to use any other package manager.
<br><br>
So far, only tested on Ubuntu 22.04. Let me know of any problems on other systems.
There's been confirmation that the included binaries work on Windows 11 with WSL subsystem (Ubuntu). The bin/pdp.sh has not been tested on Windows yet though. Feedback requested!
<br><br>
The install script assumes /usr/local/bin is an existing directory, in your PATH. Otherwise, the command 'pdp' will not be found; in that case try '/opt/rpdp/bin/rpdp.sh ?' to see if that works.

## flake.nix
The "easy button" is to simply run `nix shell` in the root of the repo after setting `pidpremote` and `piuser` in 
flake.nix. However, you can also use `nix profile install`. From there, all the commands work exactly as described above in the Terminals section.
<br><br>
The flake.nix file is designed for maximum flexibility, and individual build targets can be built and tested.

### Differences from the apt version
Rather than using `lxterminal` for `telcon`, `xterm` is used. The latter is more likely to be installed by default on some systems, and is sure to be installed on Mac OS X if `XQuartz` is used (this is also the recommended configuration there).
<br><br>
Also, the `sty33` program compiles and runs as expected, but the font is up to you to install. The author recommends using `home-manager` for managing individual user configurations, but simply copying it to `$HOME/.local/share/fonts` or `$HOME/.fonts` and running `fc-cache -v -f` is all that is strictly necessary.
<br><br>
`supdup` is also included in this version.
