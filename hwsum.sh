#!/bin/bash

#This is a script to create a hardware summary of my computer.

#Show operating system name with version

echo -n "Your Operating system: "
inxi -S | grep "Distro:" | awk '{print $6, $7}'

#Show Cpu info
echo -n "CPU Name & Model: "
inxi -C | grep 'model:' | awk -F'model: ' '{print $2}'

#Show system RAM

echo -n "System RAM :"
inxi -m  | grep 'System RAM: ' | awk -F 'System RAM: ' '{print $2}'


#STORAGE SUMMARY

echo -n "Disk Drive Storage: "
inxi -D | grep 'Local Storage: ' | awk -F 'Local Storage: ' '{print $2}'
