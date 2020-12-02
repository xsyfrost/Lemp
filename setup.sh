#!/bin/bash

#Include configuration file
source ./default.conf

echo "Upgrade server ..."
sudo apt update
sudo apt upgrade

echo "Setup basic packages & sury packages ..."
sudo apt -y install apt-transport-https lsb-release ca-certificates curl htop vim wget fail2ban software-properties-common unzip
sudo curl -sSL -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
sudo apt update

echo "Setup images components ...."
sudo apt install webp jpegoptim optipng imagemagick build-essential libmcrypt-dev libreadline-dev

echo "Setup certbot components ...."
sudo apt install snap
sudo snap install core
sudo snap refresh core
sudo snap install certbot --classic
sudo ln -s /snap/bin/certbot /usr/bin/certbot
#certbot python-certbot-nginx

if [ -z "$password" ]; then
    password=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 18 ; echo '')
fi
if [ -z "$mysqlPassword" ]; then
    mysqlPassword=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 18 ; echo '')
fi

#Creation of cakephp dir before user home because of empty folder troubles
if [ "$cakephpSetup" = true ] ; then
    source ./cakephp/setup.sh
fi

echo "Create Linux user ...."
sudo groupadd ${group}
sudo useradd -G ${group} -d /home/web/ ${user} ; echo "$user:$password" | chpasswd

if [ "$cakephpSetup" = true ] ; then
  sudo chown -R $(echo "$user:$group") ${cakephpDir}
fi

#Save username & password in file in case it has not been provided
sudo echo -e "#### $(date +'%Y/%m/%d %H:%M:%S') ####\nFTP & Web user\nUsername:$user\nPassword:$password\n\nMysql & Phpmyadmin user\nUsername:$mysqlUser\nPassword:$mysqlPassword" >> /home/server_informations.txt


if [ "$nginxSetup" = true ] ; then
    source ./nginx/setup.sh
fi
if [ "$mysqlSetup" = true ] ; then
    source ./mysql/setup.sh
fi
if [ "$phpSetup" = true ] ; then
    source ./php/setup.sh
fi
if [ "$phpmyadminSetup" = true ] ; then
    source ./phpmyadmin/setup.sh
fi
if [ "$geoipSetup" = true ] ; then
    source ./geoip/setup.sh
fi

sudo echo "#####################################################"
sudo echo "#################  WARNING  #########################"
sudo echo "#####################################################"
sudo echo "#####################################################"
sudo echo "Accounts (username & password) are stored in: /home/server_informations.txt"
sudo echo "Please consider deleting them once stored on a safe place"
sudo echo "#####################################################"
sudo echo "#################   WEB (FTP)  ######################"
sudo echo "Username:$user"
sudo echo "Password:$password"
sudo echo "###################   MYSQL  ########################"
sudo echo "Username:$mysqlUser"
sudo echo "Password:$mysqlPassword"
sudo echo "#####################################################"
