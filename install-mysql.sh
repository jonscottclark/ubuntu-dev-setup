#!/bin/bash

. /tmp/provision-functions.sh

# Stop the service whilst we do some work
service apache2 stop

# Set a default password for root user
echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections

# Ignore any post install questions
export DEBIAN_FRONTEND=noninteractive

# Get packages
apt-non-interactive install mysql-server mysql-client libapache2-mod-auth-mysql

# Allow remote connecitons.
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf > /dev/null 2>&1
sed -i 's/key_buffer/key_buffer_size/g' /etc/mysql/my.cnf > /dev/null 2>&1

# Install system tables
mysql_install_db

# Flush privileges
mysql -uroot -p root -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;' > /dev/null 2>&1

# Restart MySQL
service mysql restart

# Start Apache (it was stopped in mysql-pre.sh)
service apache2 start