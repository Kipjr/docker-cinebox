#!/bin/sh
echo -----------------------------
echo -n "WAN IP: " && echo "$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo -n ""
curl "https://ipinfo.io"
echo -n ""
echo -n "LAN_0 IP: " && echo "$(ifconfig -a eth0 | grep -E 'inet|RX|TX')"
echo -n "LAN_1 IP: " && echo "$(ifconfig -a eth1 | grep -E 'inet|RX|TX')"
echo ----------------------------
arp -a
echo -----------------------------
netstat -r
echo ----------------------------
ping  -c 2 8.8.8.8 | tail -n 3
echo -----------------------------
ping  -c 2 192.168.1.1 | tail -n 3
echo -----------------------------
traceroute -4 -m 12 -q 1 8.8.8.8
echo -----------------------------
traceroute -4 -m 5 -q 1 192.168.1.1
echo -----------------------------
