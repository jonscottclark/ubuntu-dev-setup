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

# Update packages
apt-non-interactive update
apt-non-interactive upgrade

# Add remote git hosts to known_hosts
ssh-keyscan -H github.com > /dev/null 2>&1 >> ~/.ssh/known_hosts
ssh-keyscan -H bitbucket.org > /dev/null 2>&1 >> ~/.ssh/known_hosts