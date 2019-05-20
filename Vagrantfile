# Bertrand Szoghy
# last modified: 2019-05-20
# several vms will be started by this Vagrantfile, forming a small virtual network, in order to use Ansible

$script = <<SCRIPT
set -x
/vagrant/setup.sh

SCRIPT

Vagrant.configure("2") do |config|
   
  config.vm.define "web" do |web|
    web.vm.box="nrel/CentOS-6.5-x86_64"
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.33.20"
    web.vm.network "forwarded_port", guest: 80, host: 8080
  end

  config.vm.define "db" do |db|
    db.vm.box = "nrel/CentOS-6.5-x86_64"
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.33.30"
  end
  
  # Ansible master vm must be declared here, i.e. last in the list, because otherwise the bash script 
  # will execute completely before vagrant can move on to starting the next vm and SSH keys would not
  # happen in the script.
  # https://app.vagrantup.com/centos/boxes/7
  config.vm.define "ans" do |ans|
    ans.vm.box = "centos/7"
	ans.vm.box_version = "1901.01"
    ans.vm.provider "virtualbox"
	ans.vm.provision "shell", privileged: false, inline: $script
    ans.vm.hostname = "ans"
    ans.vm.network "private_network", ip: "192.168.33.10"
  end
    
end
