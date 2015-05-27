#!/bin/bash

# Run this if you're not using Vagrant (i.e. you're setting up a brand new VPS)

. ./provision-functions.sh

. ./env-setup.sh

. ./install-package.sh git git-flow htop tree unzip wget

. ./install-nvm.sh

. ./install-apache.sh

. ./install-php.sh

. ./install-composer.sh

. ./install-mysql.sh