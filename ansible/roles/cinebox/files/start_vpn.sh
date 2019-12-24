#!/bin/bash
#this file will start screen and vpn
if ! [ $1 ]; then
	sleepy="60s"
else
	sleepy=$1
fi
echo "Going to sleep for $sleepy"
/bin/sleep $sleepy

echo "Checking root" 
if ! [ $(id -u) = 0 ]; then
   echo "I am not root! Unable to start"
   exit 1
fi

if ! [ -d "/usr/local/lib/python3.6/dist-packages/openpyn" ]; then
	echo "Openpyn not installed"
	exit 1
fi

if ! [ -d " /etc/transmission-daemon" ]; then
	echo "Transmission not installed"
	exit 1
fi

echo "Create screen and start vpn.sh"
/usr/bin/screen -dmS vpn /home/USERNAME/cinebox/vpn.sh

oldip=$(cat /etc/transmission-daemon/settings.json | grep '10.8.' | cut -d '"' -f4)

while :
	do
		newip=$(/sbin/ifconfig | grep 'inet 10.8.' | cut -d: -f2 | awk '{ print $1}' )
		#echo $newip
		if ! [ -z $newip ]; then 
			echo "VPN activated. Port 22,80,9091-9094 are local and open"
                        break
		else
			echo "tun0 not initialized. Waiting for 10s."
			/bin/sleep 10
		fi	
done



echo "this local VPN  IP $oldip will be changed to the new local VPN IP  $newip in settings.json"

echo "Transmission will stop, if already started. But I hope for you it didn't start before VPN."
service transmission-daemon stop
echo "Changing the local VPN IP in transmission-daemon/settings.json"
sed -i -e "s/$oldip/$newip/g" /etc/transmission-daemon/settings.json
echo "Start Transmission, Couchpotato, Sickchill and webserver"
service transmission-daemon start
service couchpotato start
service sickchill start
service radarr start
