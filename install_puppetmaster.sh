#!/usr/bin/bash

# Determine if the script is being run by root or not
user=$(whoami)
if [ "$user" == "root" ]; then 
    sudo=""
else
    sudo="sudo"
fi
$sudo hostname puppetserver
$sudo yum install -y puppet-server
$sudo chkconfig puppetmaster on
$sudo service puppetmaster start
