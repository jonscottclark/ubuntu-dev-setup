# Ubuntu Server Setup w/ Shell Provisioning

This repository includes provisioning scripts to set up a fresh web development environment running [Ubuntu 14.04](http://www.ubuntu.com/server).

A `Vagrantfile` is included for provisioning a local virtual machine (VM) with [Vagrant](https://vagrantup.com) and [Virtualbox](https://www.virtualbox.org)

An `init.sh` file is included to set up a brand new virtual private server (VPS).

*Note: It's possible to use Vagrant to spin up a virtual machine through providers like Digital Ocean and Amazon Web Services (AWS). However, support for provisioning to the myriad of VPS providers is beyond the scope of this repo. To achieve that, you'll need to install [the appropriate Vagrant plugin](http://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#providers) for your provider and do a little legwork. Sorry.*

---

### Motivation

The need for a local VM for development and a remote VPS for production with the same configuration starting point; no dependency on provisioning or automation utilities like [Chef](https://chef.io) or [Puppet](http://puppetlabs.com).

### Prerequisites for a Vagrant VM (OSX only)

- [Vagrant](https://vagrantup.com/downloads.html)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- Ubuntu 14.04 `.box` file: `vagrant box add ubuntu/trusty64`

### Principles

- All Vagrant-specific provisioning should happen in the `Vagrantfile`.
- Advanced bash scripting knowledge shouldn't be assumed for this repo to be usable and understandable.
- Extra provisioning steps should be easy to add to your fork, and unwanted steps should be easy to remove.
- Inline documentation should be provided wherever possible to convey what's going on.

---

### What's Included

- [Apache](http://httpd.apache.org)
  - `mod_rewrite` enabled
- [PHP](http://php.net)
  - w/ [Composer](https://getcomposer.org) installed globally
- [MySQL](https://www.mysql.com)
- [Node.js](https://nodejs.org) 0.10.x (via [nvm](https://github.com/creationix/nvm))
- Other Packages:
  - [git](https://git-scm.com)
  - [git-flow](https://github.com/nvie/gitflow)
  - [htop](http://hisham.hm/htop)
  - [tree](http://mama.indstate.edu/users/ice/tree)
  - unzip
  - [wget](http://www.gnu.org/software/wget)

### After You're Up and Running

Some steps you might need to take after provisioning:

- **Run `mysql_secure_installation` and change the root password for MySQL**
- [Generate an SSH key pair](https://help.github.com/articles/generating-ssh-keys/)
- Change your default shell
- Install your personal [dotfiles](https://dotfiles.github.io)
- Install support for other languages (Go, Ruby, Python, etc.)
- Install your favourite editor (vim, Emacs, etc.)
- Set up Apache virtual hosts
- Tweak `php.ini` to your liking

---

### Contributing

Can you think of anything else that should be included? Anything that most people need to do on a production server after provisioning a new VPS? Does something seem confusing or unnecessary? Please let me know in the [issue tracker](https://github.com/jonscottclark/ubuntu-dev-setup/issues).

### Credits

This repo borrowed heavily from some existing configurations and shell scripts developed by others: see [CREDITS.txt](https://github.com/jonscottclark/ubuntu-dev-setup/blob/master/CREDITS.txt) for acknowledgements.

### Licenses

[MIT License](http://jonscottclark.mit-license.org/) © Jon Scott Clark

[MIT License](http://vitorbritto.mit-license.org) © Vitor Britto

[MIT License](https://github.com/StanAngeloff/vagrant-shell-scripts/blob/master/LICENSE.md) © Stan Angeloff