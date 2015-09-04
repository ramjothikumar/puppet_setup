#!/usr/bin/bash

puppet_master_ip="$1"

# Determine if the script is being run by root or not
user=$(whoami)
if [ "$user" == "root" ]; then 
    sudo=""
else
    sudo="sudo"
fi

# Determine hostOS
hostOS=$(cat /etc/*-release | grep PRETTY_NAME | grep -o '".*"' | sed 's/"//g' | sed -e 's/([^()]*)//g' | sed -e 's/[[:space:]]*$//')
if [ ! -f /etc/redhat-release ]; then
    hostOS=$(head -c 16 /etc/redhat-release)
fi

if [ "$hostOS" == *"Ubuntu"* ]; then
    $sudo apt-get update -y && apt-get install -y puppet

else
    $sudo yum install -y puppet
    $sudo chkconfig puppet on
fi
$sudo echo "$puppet_master_ip puppet" >> /etc/hosts
$sudo service puppet restart
$sudo puppet agent --enable
$sudo puppet agent --test
