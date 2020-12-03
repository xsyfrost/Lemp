#!/bin/bash

read -p "Domain name (without www):" domain
phpmyadminDomain=$(echo "phpmyadmin.$domain")
phpmyadminIP=$(who am i|awk '{ print $5}'| tr -d '()')

sudo sed -i "/phpmyadminDomain=/c\phpmyadminDomain='$phpmyadminDomain'" ./default.conf
sudo sed -i "/domain=/c\domain='$domain'" ./default.conf
sudo sed -i "/phpmyadminIP=/c\phpmyadminIP='$phpmyadminIP'" ./default.conf
