#!/bin/bash

# z must be placed in this directory to mirror installation via Homebrew on OSX,
# so that the fish shell wrapper for z works properly.
git clone https://github.com/rupa/z.git /usr/local/etc/profile.d/z
ln -s /usr/local/etc/profile.d/z/z.sh /usr/local/etc/profile.d/z.sh