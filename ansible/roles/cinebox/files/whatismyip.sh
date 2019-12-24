#!/bin/bash
#this file will report IP to shared folder

ip() {
dig TXT +short o-o.myaddr.l.google.com @ns1.google.com 
}

timestamp() {
   date +"%Y-%m-%d %T"
}


echo $(timestamp)";" $(ip) >> /home/USERNAME/cinebox_files/_IP.csv
echo $(timestamp)";" $(ip)
