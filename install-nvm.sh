#!/bin/bash

# Grab nvm, install manually, and check out the latest release.
git clone https://github.com/creationix/nvm.git ~/.nvm > /dev/null 2>&1 && cd ~/.nvm && git checkout -q `git describe --abbrev=0 --tags`

# Source nvm so we can access its CLI
. ~/.nvm/nvm.sh

# Install a stable version of Node.js
VERSION="0.10"
nvm install $VERSION > /dev/null 2>&1

# Set that version to the 'default' alias
nvm alias default $VERSION > /dev/null 2>&1