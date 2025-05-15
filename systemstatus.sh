#!/bin/bash

#This is a script to script to display the current cpu activity level, free memory, and free disk space. 
#For this script you can use commands such as uptime, free, and df.


#Find and display CPU activity level
echo -n "Load Average: "
uptime | awk -F'load average: ' '{print $2}'
#Find and display the systems Free Memory
echo -n "Free Memory: "
free -h | awk '/^Mem:/ {print $4}'
#Find and display the systems Free Disk Space where name starts with /dev
echo -n "Free Disk Space: "
df -h | awk '$1 == "/dev/sda2" {print $4}'

