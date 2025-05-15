#!/bin/bash

#This is a script to update the software
#Shouldnt ask the user any questions, other than a password
#it will use commands like sudo, apt

#Update the local list of available software

sudo apt update

#upgrade any out of date data packages

sudo apt-get -qq upgrade


