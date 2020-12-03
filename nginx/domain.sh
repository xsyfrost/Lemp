#!/bin/bash

if [ "$domainSetup" = true ] ; then
      if [ -n "$domain" ] ; then
          if [ ! -f "/etc/nginx/sites-available/$domain.conf" ]; then
                certbotSuccess=false
                certbot certonly --non-interactive --agree-tos -m ${email} --nginx -d ${domain} && certbotSuccess=true
                #Replace elements in conf file
                if [ "$certbotSuccess" = true ] ; then

                    certbotSuccess=false
                    certbot certonly --non-interactive --agree-tos -m ${email} --nginx -d $(echo "www.$domain") && certbotSuccess=true
                    if [ "$certbotSuccess" = true ] ; then
                        sed "s|{domain}|$domain|g; s|{domainDir}|$domainDir|g; s|{phpVersion}|$phpVersion|g"  ./nginx/template_cakephp.conf > "/etc/nginx/sites-available/$domain.conf"
                        #Création du lien symbolique
                        ln -s "/etc/nginx/sites-available/$domain.conf" "/etc/nginx/sites-enabled/$domain.conf"
                        mkdir -p "/etc/nginx/ssl/$domain/"
                        mkdir -p "/etc/nginx/ssl/www.$domain/"
                        openssl rand 48 > "/etc/nginx/ssl/$domain/ticket.key"
                        openssl rand 48 > "/etc/nginx/ssl/www.$domain/ticket.key"
                        openssl dhparam -out "/etc/nginx/ssl/$domain/dhparam4.pem" 2048
                        openssl dhparam -out "/etc/nginx/ssl/www.$domain/dhparam4.pem" 2048
                    fi
                fi
          fi
      fi
fi
