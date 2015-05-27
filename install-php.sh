#!/bin/bash

. /tmp/provision-functions.sh

# Get packages
apt-non-interactive install php5-fpm php5-mysql php5-cli php5-mcrypt php5-gd php5-curl

# Make sure php5-fpm is running as a Unix socket
sed -i "s/listen = .*/listen = \/var\/run\/php5-fpm.sock/" /etc/php5/fpm/pool.d/www.conf > /dev/null 2>&1