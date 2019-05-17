#!/bin/bash

# Install necessary services
sudo apt-get -y update
sudo apt-get -y install ruby
sudo apt-get -y install wget
sudo apt-get -y install nginx
sudo service nginx start
sudo apt -y install awscli

# Put Twitch logo on Nginx home page
cd /var/www/html/
sudo aws s3 cp s3://twitchlogo/Twitch_logo.jpg .
sudo sed -i '14 a <img src="TwitchLogo.png" alt="Twitch.tv Logo">' index.nginx-debian.html

# Change access log path to /var/log/essence
sudo mkdir /var/log/essence
sudo chmod 766 /var/log/essence
cd /etc/nginx/
sudo curl -O https://raw.githubusercontent.com/eboayue/terraform-aws/master/nginx.conf

#Create essence user and group
sudo useradd -m essence
sudo groupadd essence
sudo usermod -g essence essence

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

