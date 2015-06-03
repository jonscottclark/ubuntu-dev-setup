#!/bin/bash

. /tmp/provision-functions.sh

# Set locale
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8 > /dev/null 2>&1
dpkg-reconfigure locales > /dev/null 2>&1

# Purge local nameservers and add Google DNS
nameservers-local-purge
nameservers-append '8.8.8.8'
nameservers-append '8.8.4.4'

# Set up a swapfile to alleviate low memory errors
fallocate -l 2G /swapfile && chmod 0600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap sw 0 0' >> /etc/fstab
echo vm.swappiness = 10 >> /etc/sysctl.conf && echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.conf && sysctl -p

# Update packages
apt-non-interactive update
apt-non-interactive upgrade

# Add remote git hosts to known_hosts
ssh-keyscan -H github.com > /dev/null 2>&1 >> ~/.ssh/known_hosts
ssh-keyscan -H bitbucket.org > /dev/null 2>&1 >> ~/.ssh/known_hosts