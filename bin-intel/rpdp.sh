#!/bin/bash



# EDIT THE LINE BELOW TO MATCH THE NAME OF YOUR PIDP-10, (adding .local)
pidpremote="pidp10.local"
# EDIT THE LINE BELOW TO MATCH THE NAME OF YOUR PIDP-10, (adding .local)
piuser="pi"
# ----------------------------------------------------------------------


echo "remote connection to $pidpremote"

if [ $# -eq 0 ]; then
    echo "ssh into $pidpremote."
    echo " This will fail if the PDP-10 simulation is not running, or the user name on the PiDP-10 is not pi"
    ssh -t $piuser@pidp10.local 'pdp'

else
	case $1 in
		con)
			nohup /opt/pidp10/bin-intel/sty -e telnet $pidpremote 1025 > /dev/null 2>&1 &
			;;
		telcon)
			nohup lxterminal --command="telnet $pidpremote 1025" > /dev/null 2>&1 &
			;;
		vt52)
			nohup /opt/pidp10/bin-intel/vt52 -B telnet $pidpremote 10018 > /dev/null 2>&1 &
			;;
		vt05)
			nohup /opt/pidp10/bin-intel/vt05 -B telnet $pidpremote 10018 > /dev/null 2>&1 &
			;;
		tvcon)
			nohup /opt/pidp10/bin-intel/tvcon -2BS $pidpremote > /dev/null 2>&1 &
			;;
		imlac)
            echo "ITS tip: don't forget to enter :tctyp oimlac after logging in"
			cd /opt/pidp10/bin-intel
			nohup /opt/pidp10/bin-intel/imlac /opt/pidp10/bin-intel/imlac.simh > /dev/null 2>&1 &
			;;
		tek)
			nohup /opt/pidp10/bin-intel/tek4010 -b9600 telnet $pidpremote 10017 > /dev/null 2>&1 &
			;;
		dp3300)
			nohup /opt/pidp10/bin-intel/dp3300 -a -B telnet $pidpremote 10020 > /dev/null 2>&1 &	
			;;
		*)
			echo rpdp for remote PiDP-10. Options are: 
			echo  [con telcon vt52 vt05 tvcon imlac tek dp3300 ]
			echo when run without options, 
			echo  pdp brings you into simh - Ctrl-A d to leave
			;;
	esac
fi

