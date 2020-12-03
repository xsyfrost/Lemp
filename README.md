Setup a Lemp server with Nginx / Mysql / php (7.4+) 
It has been splitted in modules to be as scalable as possible
It has for now cakephp / phpmyadmin and geoip (maxmind) modules


It has been written for debian 9+ ubuntu 20.04+ server

SETUP
Download zip file
```sh
wget https://github.com/xsyfrost/Lemp/archive/main.zip
sudo apt install unzip
unzip main.zip
chmod +x Lemp-main/*
cd Lemp-main

#Or in one line
wget https://github.com/xsyfrost/Lemp/archive/main.zip && unzip main.zip && chmod -R +x Lemp-main && cd Lemp-main

```
EDIT Configure file

Set the modules you would like to install 
```sh
vim default.conf

mysqlSetup=true #Mysql (MariaDB)
phpSetup=true #Php (7.4+)
nginxSetup=true #Nginx
domainSetup=true #Certbot with a fully https certificated domaine www + non www and the nginx template configuration (for cakePhp but should work for all the main PHP frameworks). Keep in mind that you should configure your dns first (www, non www) to point to your server
phpmyadminSetup=true #Phpsetup, if the phpmyadminDomain is provided it also create the certificate with certbot and the nginx configuration
cakephpSetup=true #Create a cakephp repository
geoipSetup=true #Setup maxmind Geoip. If the credential are provided (AccountID, LicenseKey) it should also update de configuration file
```
EXECUTE THE script
```sh
./setup.sh
```
