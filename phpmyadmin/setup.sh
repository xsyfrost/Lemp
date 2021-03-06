#!/bin/bash


if [ -d "${phpmyadminDir}" ]; then
    random=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8 ; echo '')
    mv ${phpmyadminDir} $(echo "$phpmyadminDir_$random")
fi
sudo mkdir -p ${phpmyadminDir}
#Download latest version of phpmyadmin download & unzip it

sudo wget https://files.phpmyadmin.net/phpMyAdmin/${phpmyadminVersion}/phpMyAdmin-${phpmyadminVersion}-all-languages.zip -O phpMyAdmin-${phpmyadminVersion}-all-languages.zip && unzip -o phpMyAdmin-${phpmyadminVersion}-all-languages.zip -d ${phpmyadminDir} && mv -f /home/phpmyadmin/phpMyAdmin-${phpmyadminVersion}-all-languages/* ${phpmyadminDir}

#Setup mcrypt for phpmyadmin
sudo pecl channel-update pecl.php.net
sudo printf "\n" | sudo pecl install mcrypt-$(echo "$phpmyadminMcrypt")
sudo sed -i "s/;extension=xsl/;extension=xsl\nextension=mcrypt.so/" /etc/php/$(echo "$phpVersion")/fpm/php.ini

#Move config file and generate blowfish secret
sudo mv ${phpmyadminDir}/config.sample.inc.php ${phpmyadminDir}/config.inc.php
blowfish_secret=$(openssl rand -base64 32)
sudo sed -i "/blowfish_secret/c\ \$cfg['blowfish_secret'] = '$blowfish_secret';" ${phpmyadminDir}/config.inc.php

sudo chown -R $(echo "$user:$group") ${phpmyadminDir}

sudo mysql -e "CONNECT phpmyadmin; SOURCE ${phpmyadminDir}/sql/create_tables.sql;"

#Next step creation of https certification let's encrypt
if [ "$phpmyadminSetupDomain" = true ] ; then
      if [ -n "$phpmyadminDomain" ] ; then
          if [ ! -f "/etc/nginx/sites-available/$phpmyadminDomain.conf" ]; then
                certbotSuccess=false
                certbot certonly --non-interactive --agree-tos -m ${email} --nginx -d ${phpmyadminDomain} && certbotSuccess=true
                #Replace elements in conf file
                if [ "$certbotSuccess" = true ] ; then
                    sudo sed "s|{phpmyadminDomain}|$phpmyadminDomain|g; s|{phpmyadminIP}|$phpmyadminIP|g; s|{phpVersion}|$phpVersion|g; s|{phpmyadminDir}|$phpmyadminDir|g" ./phpmyadmin/template.conf > "/etc/nginx/sites-available/$phpmyadminDomain.conf"
                    #Création du lien symbolique
                    sudo ln -s "/etc/nginx/sites-available/$phpmyadminDomain.conf" "/etc/nginx/sites-enabled/$phpmyadminDomain.conf"
                    sudo mkdir -p "/etc/nginx/ssl/$phpmyadminDomain/"
                    sudo openssl rand 48 > "/etc/nginx/ssl/$phpmyadminDomain/ticket.key"
                    sudo openssl dhparam -out "/etc/nginx/ssl/$phpmyadminDomain/dhparam4.pem" 2048
                fi
          fi
      fi
fi
