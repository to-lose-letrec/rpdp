#!/bin/bash


# EDIT THE LINE BELOW TO MATCH THE NAME OF YOUR PIDP-10, (adding .local)
pidpremote="pidp10c.local"
# EDIT THE LINE BELOW TO MATCH THE NAME OF YOUR PIDP-10, (adding .local)
piuser="pi"
# ---------------------------------------------------------------------- 


echo "remote connection to $pidpremote"

if [ $# -eq 0 ]; then
    echo "ssh into $pidpremote. Assumes the PDP-10 simulation is indeed running."
    echo "opening virtual screen terminal, Ctrl-A d to leave."
    ssh -t $piuser@$pidpremote 'pdp'

else
	case $1 in
		con)
			nohup /opt/rpdp/bin/sty -e telnet $pidpremote 1025 > /dev/null 2>&1 &
			;;
		telcon)
			nohup lxterminal --command="telnet $pidpremote 1025" > /dev/null 2>&1 &
			;;
		vt52)
			nohup /opt/rpdp/bin/vt52 -B telnet $pidpremote 10018 > /dev/null 2>&1 &
			;;
#		vt05)
#			nohup /opt/rpdp/bin/vt05 -B telnet $pidpremote 10018 > /dev/null 2>&1 &
#			;;
		tvcon)
			nohup /opt/rpdp/bin/tvcon -2BS $pidpremote > /dev/null 2>&1 &
			;;
		imlac)
            echo "ITS tip: don't forget to enter :tctyp oimlac after logging in"
			cd /opt/rpdp/bin
			nohup /opt/rpdp/bin/imlac /opt/rpdp/bin/imlac.simh > /dev/null 2>&1 &
			;;
		tek)
			nohup /opt/rpdp/bin/tek4010 -b9600 telnet $pidpremote 10017 > /dev/null 2>&1 &
			;;
		dp3300)
			nohup /opt/rpdp/bin/dp3300 -a -B telnet $pidpremote 10020 > /dev/null 2>&1 &	
			;;
		*)
			echo rpdp for remote PiDP-10. Options are: 
			echo  [con telcon vt52 tvcon imlac tek dp3300 ]
			echo when run without options, 
			echo  pdp brings you into simh - Ctrl-A d to leave
			echo
            echo edit rpdp.sh to change hostname and username 
            echo for your PiDP-10, or run install-rpdp script
            ;;
	esac
fi

