#!/bin/bash
cd /tmp 
curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
mv *adarr*.tar.gz Radarr.tar.gz
chmod 0770 Radarr.tar.gz
sleep 5
exit 0
