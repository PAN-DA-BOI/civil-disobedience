#!/bin/sh
echo "Installing"
sudo apt update
sudo apt upgrade

#get display working
echo "Installing display drivers"


#remove desktop envi
echo "removing desktop enviroment"


#get python up and working
echo "Installing python"
sudo apt install -y python3 python3-pip
pip3 install PyQt5


# Open up SSH on port 2220
echo "Installing OpenSSH"
sudo apt install openssh-server -y
sudo sed -i 's/#Port 22/Port 2220/' /etc/ssh/sshd_config
sudo systemctl restart ssh
