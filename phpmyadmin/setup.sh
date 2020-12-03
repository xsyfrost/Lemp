#!/bin/bash

if [ -d "${phpmyadminDir}" ]; then
    random=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8 ; echo '')
    mv ${phpmyadminDir} $(echo "$phpmyadminDir_$random")
fi
sudo mkdir -p ${phpmyadminDir}
#Download latest version of phpmyadmin download & unzip it

sudo wget https://files.phpmyadmin.net/phpMyAdmin/${phpMyAdminVersion}/phpMyAdmin-${phpMyAdminVersion}-all-languages.zip -O phpMyAdmin-${phpMyAdminVersion}-all-languages.zip && unzip -o phpMyAdmin-${phpMyAdminVersion}-all-languages.zip -d ${phpmyadminDir} && mv -f /home/phpmyadmin/phpMyAdmin-${phpMyAdminVersion}-all-languages/* ${phpmyadminDir}

#Setup mcrypt for phpmyadmin
sudo pecl channel-update pecl.php.net
sudo pecl install mcrypt-$(echo "$phpmyadminMcrypt")
sudo sed -i "s/;extension=xsl/;extension=xsl\nextension=mcrypt.so/" /etc/php/$(echo "$phpVersion")/fpm/php.ini

#Move config file and generate blowfish secret
sudo mv ${phpmyadminDir}/config.sample.inc.php ${phpmyadminDir}/config.inc.php
blowfish_secret=$(openssl rand -base64 32)
sudo sed -i "s/\$cfg['blowfish_secret'] = ''/\$cfg['blowfish_secret'] = '$blowfish_secret'/" ${phpmyadminDir}/config.inc.php
sudo chown -R $(echo "$user:$group") ${phpmyadminDir}

#Next step creation of https certification let's encrypt
if [ "$phpmyadminSetupDomain" = true ] ; then
      if [ -n "$phpmyadminDomain" ] ; then
          if [ ! -f "/etc/nginx/sites-available/$phpmyadminDomain.conf" ]; then
                certbotSuccess=false
                certbot certonly --nginx -d ${phpmyadminDomain} && certbotSuccess=true
                #Replace elements in conf file
                if [ "$certbotSuccess" = true ] ; then
                    sed "s/{phpmyadminDomain}/$phpmyadminDomain/g; s/{phpmyadminIP}/$phpmyadminIP/g; s/{phpVersion}/$phpVersion/g; s/{phpmyadminDir}/$phpmyadminDir/g"  ./phpmyadmin/template.conf > "/etc/nginx/sites-available/$phpmyadminDomain.conf"
                    #Création du lien symbolique
                    ln -s "/etc/nginx/sites-available/$phpmyadminDomain.conf" "/etc/nginx/sites-enabled/$phpmyadminDomain.conf"
                    mkdir -p "/etc/nginx/ssl/$phpmyadminDomain/"
                    openssl rand 48 > "/etc/nginx/ssl/$phpmyadminDomain/ticket.key"
                    openssl dhparam -out "/etc/nginx/ssl/$phpmyadminDomain/dhparam4.pem" 2048
                fi
          fi
      fi
fi
