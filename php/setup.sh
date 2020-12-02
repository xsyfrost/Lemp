#!/bin/bash

phpVersionFull="php$phpVersion"
sudo apt install php-pear php-imagick $(echo "$phpVersionFull-fpm") $(echo "$phpVersionFull-mysql") $(echo "$phpVersionFull-curl") $(echo "$phpVersionFull-gd") $(echo "$phpVersionFull-intl") $(echo "$phpVersionFull-imap") $(echo "$phpVersionFull-pspell") $(echo "$phpVersionFull-sqlite3") $(echo "$phpVersionFull-tidy") $(echo "$phpVersionFull-xmlrpc") $(echo "$phpVersionFull-xsl") $(echo "$phpVersionFull-xml") $(echo "$phpVersionFull-mbstring") $(echo "$phpVersionFull-zip") $(echo "$phpVersionFull-curl") $(echo "$phpVersionFull-dev")

#Activation extension in php.ini
for t in ${phpModules[@]}; do
  sudo sed -i "s/;extension=$t/extension=$t/" /etc/php/${phpVersion}/fpm/php.ini
done

#User update for php
sudo sed -i "s/user = www-data/user = $user/" /etc/php/${phpVersion}/fpm/pool.d/www.conf
sudo sed -i "s/group = www-data/group = $group/" /etc/php/${phpVersion}/fpm/pool.d/www.conf
sudo sed -i "s/listen.owner = www-data/listen.owner = $user/" /etc/php/${phpVersion}/fpm/pool.d/www.conf
sudo sed -i "s/listen.group = www-data/listen.group = $group/" /etc/php/${phpVersion}/fpm/pool.d/www.conf

#rights on socket file /run/php
sudo chown $(echo "$user:$group") /run/php/$(echo "$phpVersionFull-fpm").sock

echo "Starting PHP ..."
service $(echo "$phpVersionFull-fpm") restart