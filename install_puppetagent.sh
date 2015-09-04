#!/bin/bash
set -xe
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

# Install Puppet
if [[ "$hostOS" =~ "Ubuntu" ]]; then
    $sudo apt-get update -y && $sudo apt-get install -y puppet
    $sudo sed -i 's/START=no/START=yes/' /etc/default/puppet
else
    $sudo yum install -y puppet
    $sudo chkconfig puppet on
fi
echo "[agent]" | $sudo tee --append /etc/puppet/puppet.conf
echo "server = $puppet_master_ip" | $sudo tee --append /etc/puppet/puppet.conf
echo "# Host config for Puppet Master" | $sudo tee --append /etc/hosts 2> /dev/null && \
echo "$puppet_master_ip puppet" | $sudo tee --append /etc/hosts
$sudo puppet agent --enable
$sudo service puppet restart
$sudo puppet agent --test
