#!/bin/bash

phpModules=("curl" "gd2" "gettext" "intl" "mbstring" "exif" "mysqli" "pdo_mysql" "soap" "sqlite3")
for t in ${phpModules[@]}; do
  echo "$t"
done

phpVersion="7.4"
echo ${phpVersion}

echo "$(date +'%Y/%m/%d %H:%M:%S')FTP & Web user\nUsername:Hello\nPassword:Boy\n\nMysql & Phpmyadmin user\nUsername:Howareyou\nPassword:great" >> ./server_informations.txt