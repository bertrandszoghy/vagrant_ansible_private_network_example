#!/bin/bash

echo " "
echo "***"
echo "Installing extra repository" 
echo "***"
echo " "
sudo yum install -y epel-release
sudo yum repolist

echo " "
echo "***"
echo "Installing Ansible" 
echo "***"
echo " "
sudo yum install -y ansible
echo " "
echo "***"
echo "Display AAnsible version" 
echo "***"
echo " "
ansible --version

echo " "
echo "***"
echo "Installing Docker" 
echo "***"
echo " "
# https://linuxize.com/post/how-to-install-and-use-docker-on-centos-7/
sudo yum update
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 wget
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
echo " "
echo "***"
echo "Display Docker version" 
echo "***"
echo " "
docker -v
sudo usermod -aG docker $USER
echo " "
echo "***"
echo "Testing Docker" 
echo "***"
echo " "
sudo docker container run hello-world

echo " "
echo "***"
echo "Installing Docker-compose" 
echo "***"
echo " "
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo " "
echo "***"
echo "Display Docker-compose version" 
echo "***"
echo " "
docker-compose --version

echo " "
echo "***"
echo "Copy ansible work folder" 
echo "***"
echo " "
sudo cp -r /vagrant/ansible-work /home/vagrant/
sudo chown -R vagrant:vagrant /home/vagrant/ansible-work

echo " "
echo "***"
echo "First SSH connections between vms" 
echo "***"
echo " "
# avoid message Permission denied (publickey,gssapi-keyex,gssapi-with-mic)
sudo echo "PasswordAuthentication yes" >  /etc/ssh/sshd_config
sudo service sshd restart

# next command will store the keys
sudo ssh -tt -o "StrictHostKeyChecking no" vagrant@192.168.33.20
sudo ssh -tt -o "StrictHostKeyChecking no" vagrant@192.168.33.30

echo " "
echo "***"
echo "Run ansible playbook" 
echo "***"
echo " "
cd /home/vagrant/ansible-work/
sudo ansible-playbook web_db.yaml

echo " "
echo "***"
# 8080 must match the host port in the Vagrantfile for 192.168.33.20
echo "You can test the successful Ansiible deploy at http://localhost:8080" 
echo "***"
echo " "
