server_box      = "ubuntu/trusty64"
server_hostname = "local.dev"
server_ip       = "192.168.32.101"
server_memory   = "512" # Mb
server_maxcpu   = "50" # %

Vagrant.configure("2") do |config|
  # Resolve "stdin: is not a tty" errors
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.ssh.insert_key = false

  # Basic configuration
  config.vm.box = "#{server_box}"
  config.vm.hostname = "#{server_hostname}"
  config.vm.network :private_network, ip: "#{server_ip}"

  # Configure synced folder (host machine, guest VM)
  config.vm.synced_folder "/var/www", "/var/www"
  # Disable the default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Move our base file to temporary directory on the guest VM
  config.vm.provision "file", source: "provision-functions.sh", destination: "/tmp/provision-functions.sh"

  # Set up the environment
  config.vm.provision :shell, :path => "env-setup.sh"

  # Install git and some utilities
  config.vm.provision :shell do |s|
    s.path = "install-package.sh"
    s.args = "git git-flow htop tree unzip wget"
  end

  # Install Node.js via nvm
  config.vm.provision :shell, :path => "install-nvm.sh", :privileged => false

  # Install Apache
  config.vm.provision :shell, :path => "install-apache.sh"

  # Install PHP
  config.vm.provision :shell, :path => "install-php.sh"

  # Install Composer
  config.vm.provision :shell, :path => "install-composer.sh"

  # Install MySQL
  config.vm.provision :shell, :path => "install-mysql.sh"

  # Virtualbox-specific settings
  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.name = "#{server_hostname}"
    vb.customize [
      "modifyvm", :id,
      "--cpuexecutioncap", "#{server_maxcpu}",
      "--memory", "#{server_memory}",
    ]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

end
