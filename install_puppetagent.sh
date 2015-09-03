#!/usr/bin/bash

puppet_master_ip="$1"

# Determine if the script is being run by root or not
user=$(whoami)
if [ "$user" == "root" ]; then 
    sudo=""
else
    sudo="sudo"
fi

$sudo yum install -y puppet
$sudo chkconfig puppet on
$sudo echo "$puppet_master_ip puppet" >> /etc/hosts
$sudo service puppet start
$sudo puppet agent --test
