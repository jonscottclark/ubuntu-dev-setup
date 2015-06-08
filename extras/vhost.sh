#!/bin/bash

# Assign vars to arguments
action=$1
hostname=$2
docRoot=$3

# Set default parameters
owner=$(whoami)
email="webmaster@localhost"
userDir="/var/www/"

# Take care of missing arguments
if [ "$action" != 'create' ] && [ "$action" != 'delete' ]; then
  echo "=> MISSING ARG: You must specify an action ('create' or 'delete') as the first argument. Exiting..."
  exit 1;
fi

while [ "$hostname" == "" ]; do
  read -p "=> MISSING ARG: No hostname provided. Enter a hostname: " hostname
done

conf="/etc/apache2/sites-available/$hostname.conf"

# If no document root provided, just use the hostname
if [ "$docRoot" == "" ]; then
  docRoot=$userDir$hostname
fi

# If root dir starts with '/', don't use /var/www as default starting point
if [[ "$docRoot" =~ ^/ ]]; then
  userDir=''
fi

# Ensure we're privileged
if [ "$owner" != 'root' ]; then
  echo "=> ERROR: Must run $0 as root. Use sudo. Exiting..."
  exit 1;
fi

# Ok, let's create a new virtual host and enable it.
if [ "$action" == 'create' ]; then
  # check if hostname already exists
  if [ -f $conf ]; then
    echo "=> ERROR: This hostname already exists. Exiting..."
    exit;
  fi

  # check if directory exists or not
  if ! [ -d $docRoot ]; then
    # create the directory
    mkdir $docRoot
    # write test file in the new hostname dir
    if ! echo "<?php echo phpinfo(); ?>" > $docRoot/phpinfo.php
    then
      echo "=> ERROR: Not able to write phpinfo.php to $userDir/$docRoot/. Please check permissions!"
      exit;
    else
      echo "=> OK: Created $docRoot/phpinfo.php to verify/test"
    fi
  fi

  # create virtual host rules file
  if ! echo "
<VirtualHost *:80>
  ServerAdmin $email
  ServerName $hostname
  ServerAlias $hostname
  DocumentRoot $docRoot
  <Directory />
    AllowOverride All
  </Directory>
  <Directory $docRoot>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride all
    Require all granted
  </Directory>
  ErrorLog /var/log/apache2/$hostname-error.log
  LogLevel error
  CustomLog /var/log/apache2/$hostname-access.log combined
</VirtualHost>" > $conf
  then
    echo "=> ERROR: Can't create $hostname.conf"
    exit;
  fi

  # Add hostname in /etc/hosts
  if ! echo "127.0.0.1  $hostname" >> /etc/hosts; then
    echo "=> ERROR: Not able to write to /etc/hosts"
    exit;
  else
    echo "=> OK: Host added to /etc/hosts file"
  fi

  #chown -R $owner:$owner $docRoot

  # enable website
  a2ensite $hostname > /dev/null 2>&1

  # restart Apache
  echo "=> RESTARTING APACHE SERVICE..."
  service apache2 reload

  # show the finished message
  echo "=> OK: Virtual host created!"
  echo "       URL: http://$hostname"
  echo "       Document Root: $docRoot"
  exit;
fi

if [ "$action" == 'delete' ]; then
  # check whether hostname already exists
  if ! [ -f $conf ]; then
    echo "=> ERROR: Can't remove. This hostname does not exist."
    exit;
  else
    # Delete hostname in /etc/hosts
    newhost=${hostname//./\\.}
    sed -i "/$newhost/d" /etc/hosts

    # disable website
    a2dissite $hostname > /dev/null 2>&1

    # restart Apache
    echo "=> RESTARTING APACHE SERVICE..."
    service apache2 reload

    # Delete virtual host config
    rm -f $conf
  fi

  # check if directory exists or not
  if [ -d $docRoot ]; then
    read -p "=> CONFIRM: Delete virtual host's document root directory? (y/n): " deldir

    if [ "$deldir" == 'y' -o "$deldir" == 'Y' ]; then
      # Delete the directory
      rm -rf $docRoot
      echo "=> OK: Directory deleted"
    else
      echo "=> OK: Host directory left alone."
    fi
  else
    echo "=> OK: Host directory not found. Exiting..."
  fi

  echo "=> REMOVED: $hostname"
  exit 0;
fi
