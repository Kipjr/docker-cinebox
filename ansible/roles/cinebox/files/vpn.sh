#!/bin/bash
#this file will start vpn

#as root
openpyn --update
#as user
openpyn be -t 5 -f --p2p --allow 22 80 9091 9092 9093 9094
