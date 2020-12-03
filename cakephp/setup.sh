#!/bin/bash

if [ -d "${cakephpDir}" ]; then
    random=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8 ; echo '')
    mv ${cakephpDir} $(echo "$cakephpDir_$random")
fi
mkdir -p ${cakephpDir}
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
sudo composer create-project --no-interaction --prefer-dist cakephp/app:~${cakephpVersion} ${cakephpDir}
if [ -n "$cakephpModules" ]; then
    currentPath=$(pwd)
    cd ${cakephpDir} && sudo composer --no-interaction require ${cakephpModules} && cd ${currentPath}
fi
