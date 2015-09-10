#!/bin/bash
set -xe

# Handle puppet master ip argument
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
    hostOS=$(head -n 1 /etc/redhat-release)
fi
echo "HostOS Flavor: $hostOS"

#take "hostOS" and match it up to OS and assign tasks
perform_install_for_os()
{
case $hostOS in
    "Amazon Linux AMI 2014.09" | "Amazon Linux AMI 2015.03")
        $sudo yum install -y puppet3
        $sudo chkconfig puppet on
        post_install_steps
    ;;
    "Ubuntu"*)
        $sudo apt-get update -y && $sudo apt-get install -y puppet
        post_install_steps
    ;;
    "CentOS release 7"* | "CentOS Linux release 7"*)
        rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
        $sudo yum install -y puppet
        $sudo chkconfig puppet on
        post_install_steps
    ;;
    "CentOS release 6"* | "CentOS Linux release 6"*)
        rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
        $sudo yum install -y puppet
        $sudo chkconfig puppet on
        post_install_steps
    ;;
    "CentOS release 5"* | "CentOS Linux release 5"*)
        rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-5.noarch.rpm
        $sudo yum install -y puppet
        $sudo chkconfig puppet on
        post_install_steps
    ;;
    *)
esac
}

# Post install steps to configure puppet
post_install_steps()
{
    echo "[agent]" | $sudo tee --append /etc/puppet/puppet.conf
    echo "server = $puppet_master_ip" | $sudo tee --append /etc/puppet/puppet.conf
    echo "[main]" | $sudo tee --append /etc/puppet/puppet.conf
    echo "runinterval = 30" | $sudo tee --append /etc/puppet/puppet.conf
    echo "# Host config for Puppet Master" | $sudo tee --append /etc/hosts 2> /dev/null && \
    echo "$puppet_master_ip puppet" | $sudo tee --append /etc/hosts
    $sudo puppet agent --enable
    $sudo service puppet start
    $sudo puppet agent --test
}

perform_install_for_os
