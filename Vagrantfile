require 'yaml'

data = YAML.load_file("config.yaml")

Vagrant.configure("2") do |config|
  # Resolve "stdin: is not a tty" errors
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Just use the private insecure key, not going to expose VM to public
  config.ssh.insert_key = false

  # Basic configuration
  config.vm.box = "#{data['box']['url']}"
  config.vm.box_url = "#{data['box']['url']}"
  config.vm.hostname = "#{data['hostname']}"
  config.vm.network :private_network, ip: "#{data['ip']}"

  # Configure synced folder (host machine, guest VM)
  data['synced_folder'].each do |i, folder|
    config.vm.synced_folder folder['source'], folder['target'], :owner => "#{folder['owner']}", :group => "#{folder['group']}", :mount_options => ["dmode=775", "fmode=664"]
  end

  # Disable the default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Move our base file to temporary directory on the guest VM
  config.vm.provision "file", source: "provision-functions.sh", destination: "/tmp/provision-functions.sh"

  # Set up the environment
  config.vm.provision :shell, :path => "env-setup.sh"

  # Add a swap file
  config.vm.provision :shell, :inline => "fallocate -l 2G /swapfile && chmod 0600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap sw 0 0' >> /etc/fstab"
  config.vm.provision :shell, :inline => "echo vm.swappiness = 10 >> /etc/sysctl.conf && echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.conf && sysctl -p"

  # Install git
  config.vm.provision :shell do |s|
    s.path = "install-package.sh"
    s.args = "git"
  end

  # Install other packages
  config.vm.provision :shell do |s|
    s.path = "install-package.sh"
    s.args = data['packages']
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
    vb.name = "#{data['hostname']}"

    vb.customize [ 'modifyvm', :id,
      '--memory', "#{data['specs']['memory']}",
      '--cpus', "#{data['specs']['cpus']}",
      '--cpuexecutioncap', "#{data['specs']['maxcpu']}"
    ]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

end
