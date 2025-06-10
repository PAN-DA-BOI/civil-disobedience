#!/bin/sh
echo "Installing"
apt update
apt upgrade

#get display working
echo "Installing display drivers"


#remove desktop envi
echo "removing desktop enviroment"


#get python up and working
echo "Installing python"
apt install -y python3 python3-pip
pip3 install PyQt5


# Open up SSH on port 2220
echo "Installing OpenSSH"
apt install openssh-server -y
sed -i 's/#Port 22/Port 2220/' /etc/ssh/sshd_config
systemctl restart sshd

