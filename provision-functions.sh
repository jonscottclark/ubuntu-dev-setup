#!/bin/bash

# Functionality here is © Stan Angeloff

[ -n "${SUDO-x}" ] && SUDO='sudo'

### Packages

# Perform a non-interactive `apt-get` command.
apt-non-interactive() {
  $SUDO DEBIAN_FRONTEND=noninteractive apt-get -f -y -qq --no-install-recommends "$@"
}

### PHP

# Update a PHP setting value in all instances of 'php.ini'.
php-settings-update() {
  local args
  local settings_name
  local php_ini
  local php_extra
  args=( "$@" )
  PREVIOUS_IFS="$IFS"
  IFS='='
  args="${args[*]}"
  IFS="$PREVIOUS_IFS"
  settings_name="$( echo "$args" | system-escape )"
  for php_ini in $( $SUDO find /etc -type f -iname 'php*.ini' ); do
    php_extra="$( dirname "$php_ini" )/conf.d"
    $SUDO mkdir -p "$php_extra"
    echo "$args" | $SUDO tee "$php_extra/0-$settings_name.ini" >/dev/null
  done
}

# Escape and normalize a string so it can be used safely in file names, etc.
system-escape() {
  local glue
  glue=${1:--}
  while read arg; do
    echo "${arg,,}" | sed -e 's#[^[:alnum:]]\+#'"$glue"'#g' -e 's#^'"$glue"'\+\|'"$glue"'\+$##g'
  done
}

### Nameservers

# Drop all local 10.0.x.x nameservers in 'resolv.conf'.
nameservers-local-purge() {
  $SUDO sed -e 's#nameserver\s*10\.0\..*$##g' -i '/etc/resolv.conf' > /dev/null 2>&1
}

# Set up an IP as a DNS name server if not already present in 'resolv.conf'.
nameservers-append() {
  grep "$1" '/etc/resolv.conf' > /dev/null 2>&1 || \
    ( echo "nameserver $1" | $SUDO tee -a '/etc/resolv.conf' > /dev/null 2>&1 )
}