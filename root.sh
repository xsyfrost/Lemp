#!/bin/bash
user="web"
group="web"
password="Unmotdepasse"
phpV="7.4"
cakephpV="4.0"
composerModules="gumlet/php-image-resize chrisjean/php-ico"

#Etape numéro 1 installation du satelite
sudo apt update
sudo apt upgrade

sudo apt -y install apt-transport-https lsb-release ca-certificates curl
sudo curl -sSL -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
sudo apt update

phpVFull="php$phpV"
sudo apt install htop vim wget nginx mariadb-server mariadb-client apt-transport-https lsb-release ca-certificates fail2ban curl software-properties-common unzip webp jpegoptim optipng $(echo "$phpVFull-fpm") $(echo "$phpVFull-mysql") $(echo "$phpVFull-curl") $(echo "$phpVFull-gd") $(echo "$phpVFull-intl") $(echo "$phpVFull-imap") $(echo "$phpVFull-pspell") $(echo "$phpVFull-sqlite3") $(echo "$phpVFull-tidy") $(echo "$phpVFull-xmlrpc") $(echo "$phpVFull-xsl") $(echo "$phpVFull-xml") $(echo "$phpVFull-mbstring") $(echo "$phpVFull-zip") $(echo "$phpVFull-curl") $(echo "$phpVFull-dev") php-pear php-imagick imagemagick php-imagick build-essential libmcrypt-dev libreadline-dev certbot python-certbot-nginx


#Composer
sudo cd /home
mkdir /home/web/
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
sudo composer create-project --prefer-dist cakephp/app:~$(echo "$cakephpV") /home/web/
sudo cd /home/web/ && composer require $(echo "$composerModules")

#Creation du user
sudo groupadd $(echo "$group")
sudo useradd -G $(echo "$group") -d /home/web/ $(echo "$user") ; echo "$user:$password" | chpasswd


#Update des parametres de php
sudo pecl channel-update pecl.php.net
sudo pecl install mcrypt-1.0.3

## Configuration des modules PHP
sudo sed -i "s/;extension=curl/extension=curl/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=gd2/extension=gd2/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=gettext/extension=gettext/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=intl/extension=intl/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=mbstring/extension=mbstring/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=exif/extension=exif/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=mysqli/extension=mysqli/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=pdo_mysql/extension=pdo_mysql/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=pdo_sqli/extension=pdo_sqli/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=soap/extension=soap/" /etc/php/$(echo "$phpV")/fpm/php.ini
sudo sed -i "s/;extension=sqlite3/extension=sqlite3\nextension=mcrypt.so/" /etc/php/$(echo "$phpV")/fpm/php.ini

##Configuration du user pour php
sudo sed -i "s/user = www-data/user = $user/" /etc/php/$(echo "$phpV")/fpm/pool.d/www.conf
sudo sed -i "s/group = www-data/group = $group/" /etc/php/$(echo "$phpV")/fpm/pool.d/www.conf
sudo sed -i "s/listen.owner = www-data/listen.owner = $user/" /etc/php/$(echo "$phpV")/fpm/pool.d/www.conf
sudo sed -i "s/listen.group = www-data/listen.group = $group/" /etc/php/$(echo "$phpV")/fpm/pool.d/www.conf
sudo chown $(echo "$user:group") /run/php/$(echo "$phpVFull-fpm").sock

##Configuration du user pour nginx
sudo sed -i "s/www-data/$user $group/" /etc/nginx/nginx.conf


##Start des services
echo "Starting Fail2ban ..."
service fail2ban start

echo "Starting PHP ..."
service $(echo "$phpVFull-fpm") start

echo "Starting Nginx ..."
service nginx start

echo "Starting Mysql ..."
service mysql start


