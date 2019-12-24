#!/bin/bash --
# Author: @DirtyCajunRice
# Edited by Kipjr
# 2019-12-24 removed interactivity / whiptail / IP-lookup / remove startup
# Check if ran by root
if [[ $UID -ne 0 ]]; then
    echo 'Script must be run as root'
    exit 1
fi

# Check for distro; continue if debian/ubuntu || exit
if [[ $(cat /etc/issue) =~ Debian ]]; then
    distro=debian
elif [[ $(cat /etc/issue) =~ Ubuntu ]]; then
    distro=ubuntu
else
    echo "This script will only work on Debian and Ubuntu Distros, but you are using $(cat /etc/issue)"
    exit 1
fi

# Check to see what SickChill Dependencies are missing
packages=$(dpkg -l unrar-free git-core openssl libssl-dev python2.7 2>1 | grep "no packages" | \
           awk '{ print $6 }' | tr '\n' ' ')
if [[ ${packages} ]]; then
# //Removed due to non-interactivity
# Show Whiptail and install required files
    {
    i=1
    while read -r line; do
        i=$(( $i + 1 ))
        echo ${i}
    done < <(apt-get update && apt-get install ${packages} -y)
    } | echo "Installing $packages"
fi
# Check to see if all prior packages were installed successfully. if not exit 1

if [[ $(dpkg -l unrar-free git-core openssl libssl-dev python2.7 2>&1 | grep "no packages" | \
        awk '{print $6 }') ]]; then
    echo "Package Installation Failed. \nThese Packages have failed:\n $(dpkg -l unrar-free git-core openssl libssl-dev python2.7 2>&1 | grep "no packages" | awk '{print $6 }') \nPlease resolve these issues and restart the install script" 
exit 1
fi

# Check to see if sickchill exists; If not make user/group
if [[ ! "$(getent group sickchill)" ]]; then
	echo "Adding SickChill Group"
    	addgroup --system sickchill
fi
if [[ ! "$(getent passwd sickchill)" ]]; then
	echo "Adding SickChill User"
	adduser --disabled-password --system --home /var/lib/sickchill --gecos "SickChill" --ingroup sickchill sickchill
fi

# Check to see if /opt/sickchill exists. If it does ask if they want to overwrite it. if they do not exit 1
# if they do, remove the whole directory and recreate
if [[ ! -d /opt/sickchill ]]; then
	echo "Creating New SickChill Folder"
	mkdir /opt/sickchill && chown sickchill:sickchill /opt/sickchill
	echo "Git Cloning In Progress"
	su -c "cd /opt && git clone -q https://github.com/SickChill/SickChill.git /opt/sickchill" -s /bin/bash sickchill
else
		echo "Removing Old SickChill Folder And Creating New SickChill Folder"
        	rm -rf /opt/sickchill && mkdir /opt/sickchill && chown sickchill:sickchill /opt/sickchill
		echo "Git Cloning In Progress"
        	su -c "cd /opt && git clone -q https://github.com/SickChill/SickChill.git /opt/sickchill" -s /bin/bash sickchill
fi

# Depending on Distro, Cp the service script, then change the owner/group and change the permissions. Finally
# start the service
if [[ ${distro} = ubuntu ]]; then
    if [[ $(/sbin/init --version 2> /dev/null) =~ upstart ]]; then
    	echo "Copying Startup Script To Upstart"
        cp /opt/sickchill/runscripts/init.upstart /etc/init/sickchill.conf
	chown root:root /etc/init/sickchill.conf && chmod 0644 /etc/init/sickchill.conf


    elif [[ $(systemctl) =~ -\.mount ]]; then
    	echo "Copying Startup Script To systemd"
        cp /opt/sickchill/runscripts/init.systemd /etc/systemd/system/sickchill.service
        chown root:root /etc/systemd/system/sickchill.service && chmod 0644 /etc/systemd/system/sickchill.service
	echo "Enabling SickChill"
        systemctl -q enable sickchill
    else
    	echo "Copying Startup Script To init"
        cp /opt/sickchill/runscripts/init.ubuntu /etc/init.d/sickchill
        chown root:root /etc/init.d/sickchill && chmod 0644 /etc/init.d/sickchill
	echo "Enabling SickChill"
        update-rc.d sickchill defaults
    fi
elif [[ ${distro} = debian ]]; then
    if [[ $(systemctl) =~ -\.mount ]]; then
    	echo "Copying Startup Script To systemd"
        cp /opt/sickchill/runscripts/init.systemd /etc/systemd/system/sickchill.service
        chown root:root /etc/systemd/system/sickchill.service && chmod 0644 /etc/systemd/system/sickchill.service
	echo "Enabling SickChill"
        systemctl -q enable sickchill
    else
    	echo "Copying Startup Script To init"
        cp /opt/sickchill/runscripts/init.debian /etc/init.d/sickchill
        chown root:root /etc/init.d/sickchill && chmod 0755 /etc/init.d/sickchill
	echo "Enabling SickChill"
        update-rc.d sickchill defaults
    fi
fi

echo "done"