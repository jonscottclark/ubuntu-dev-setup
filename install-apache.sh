#!/bin/bash

. /tmp/provision-functions.sh

# Get packages
apt-non-interactive install apache2 apache2-utils libapache2-mod-php5

# Stop the service
service apache2 stop

# Enable modules
a2enmod rewrite
a2enmod php5

# Turn on AllowOverride
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Restart the service
service apache2 start