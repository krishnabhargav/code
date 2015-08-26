# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.provision "shell",  path: "bootstrap_user.sh", privileged: false
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end
  config.vm.network "forwarded_port", host_ip:"127.0.0.1", guest:15432, host:15432
  config.vm.network "forwarded_port", host_ip:"127.0.0.1", guest:1113, host:11130
  config.vm.network "forwarded_port", host_ip:"127.0.0.1", guest:2113, host:21130
end

