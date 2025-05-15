#!/bin/bash

#this is a script to display the current hostname, ip address used to reach the internet from our pc and gateway ip

#Find and display current hostname with a label
echo -n "Hostname: "
hostname
#Find and display the IP Address with a label
echo -n "IP Address: "
ip r s default | awk '{print $9}'
#FInd and display the Gateway IP with a label
echo -n "Gateway IP: "
ip r s default | awk '{print $3}'

