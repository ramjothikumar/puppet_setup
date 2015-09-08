#!/bin/bash

puppet_master_ip="$1"
if [ "$puppet_master_ip" == "" ]; then
    echo "Usage: install_puppetagent.sh <puppet_master_ip>"
    echo "Puppet Master IP Address not Provided. Exiting"
    exit 0
fi
echo "Puppet Master IP: $puppet_master_ip"

# Determine if the script is being run by root or not
user=$(whoami)
if [ "$user" == "root" ]; then
    sudo=""
else
    sudo="sudo"
fi

# Determine hostOS
hostOS=$(cat /etc/*-release | grep PRETTY_NAME | grep -o '".*"' | sed 's/"//g' | sed -e 's/([^()]*)//g' | sed -e 's/[[:space:]]*$//')
if [ -f /etc/redhat-release ]; then
    hostOS=$(head -c 16 /etc/redhat-release)
fi
echo "HostOS Flavor: $hostOS"

# Install puppet master/server
if [[ "$hostOS" =~ "Ubuntu" ]]; then
    $sudo apt-get install -y puppetmaster
else
    if [[ "$hostOS" =~ "Amazon Linux" ]]; then
        $sudo yum install -y puppet3-server
    else 
        $sudo yum install -y puppet-server
    fi
    $sudo chkconfig puppetmaster on
fi
$sudo service puppetmaster start
