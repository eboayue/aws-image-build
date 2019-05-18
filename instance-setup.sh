#!/bin/bash

# Install necessary services
sudo apt-get -y update
sudo apt-get -y install ruby
sudo apt-get -y install wget
sudo apt -y install awscli

# Install and run puppet client
wget https://apt.puppet.com/puppet6-release-xenial.deb
sudo dpkg -i puppet6-release-xenial.deb
sudo apt-get update
sudo apt-get install puppet-agent
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
wget https://raw.githubusercontent.com/eboayue/aws-image-build/master/puppet/main.pp
sudo /opt/puppetlabs/bin/puppet apply main.pp

# Put Twitch logo on Nginx home page
cd /var/www/html/
sudo aws s3 cp s3://twitchlogo/Twitch_logo.jpg .
sudo sed -i '14 a <img src="TwitchLogo.png" alt="Twitch.tv Logo">' index.nginx-debian.html

# Change access log path to /var/log/essence
sudo mkdir /var/log/essence
sudo chmod 766 /var/log/essence
cd /etc/nginx/
sudo curl -O https://raw.githubusercontent.com/eboayue/terraform-aws/master/nginx.conf

# Backup sudoers file and edit the backup
sudo cp /etc/sudoers /tmp/sudoers.bak
sudo chmod 0777 /tmp/sudoers.bak
echo '%essence    ALL=(ALL) NOPASSWD: ALL' >> /tmp/sudoers.bak
sudo chmod 0440 /tmp/sudoers.bak

# Check syntax
sudo visudo -cf /tmp/sudoers.bak
if [ $? -eq 0 ]; then
  # Replace sudoers file with the new one if syntax is good
  sudo cp /tmp/sudoers.bak /etc/sudoers
else
  echo "Could not modify /etc/sudoers file"
fi

