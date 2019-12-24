#/bin/bash
clear
echo "Manual push cinebox directory from local to remote (i.e. webserver to downloadserver)"
read -p "Press [Enter] to start "

read -p "Target IP:" ip
read -p "Target username:" u
echo 
echo create cinebox.tar
tar -cf cinebox.tar ../cinebox
echo
echo Transfer cinebox.tar to remote machine
scp cinebox.tar $u@$ip:/home/$u
echo
echo Extract cinebox.tar and remove cinebox.tar
ssh $u@$ip 'tar -xf ./cinebox.tar && rm cinebox.tar'
rm cinebox.tar
apt-get install screen ansible -y
screen -dmS cinebox "ansible-playbook -i "localhost," /home/$u/cinebox/ansible/site.yml"
