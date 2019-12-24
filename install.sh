#/bin/bash
clear

echo "Checking root" 
if ! [ $(id -u) = 0 ]; then
   echo "I am not root! Unable to start"
   exit 1
fi


loc=0
echo Installing Cinebox
while [[ "$loc" != "1" && "$loc" != "2" ]]
	do
		read -p "Local (1) or Remote (2) installation?:" loc
	done

read -p "Press [Enter] to start the installation"
dpkg -s ansible &> /dev/null  

if [ $? -eq 0 ]

	then
		echo "Ansible already installed"   $name

	else
				
		echo Installing Ansible
		sudo apt update -y
		sudo apt install software-properties-common -y
		sudo apt-add-repository --yes --update ppa:ansible/ansible
		sudo apt install ansible -y
		sudo apt install sshpass -y
		if [ $loc -eq '1' ]
		then 
			echo Configuring Ansible
			sudo echo -e "[local]\nlocalhost ansible_connection=local" | sudo tee /etc/ansible/hosts > /dev/null
		fi

fi

if [ $loc -eq '1' ] #local
	then
		echo Starting Ansible playbook
		sudo ansible-playbook "./ansible/site.yml"
fi
		
if [ $loc -eq '2' ] #remote
	then
		echo Starting Ansible playbook
		echo Application files will be placed in their respective directory. Custom scripts and data will be placed in the homedirectory of the SSH-user defined in HOSTS
		echo Opening Hosts setup...
		read -p "Press [Enter] to open Hosts file"
		nano ./ansible/hosts
		#sudo ansible all -m setup --tree /tmp/facts -k -K -i "./ansible/hosts" 
		sudo ansible-playbook -k -K -i "./ansible/hosts" ./ansible/site.yml 
        exit 0
fi
