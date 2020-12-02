#!/bin/bash

#Setup MariaDB & create a user
apt install mariadb-server mariadb-client

#Create db and user
sudo mysql -e "CREATE DATABASE ${mysqlDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
sudo mysql -e "CREATE USER ${user}@localhost IDENTIFIED BY '${mysqlPassword}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${mysqlDB}.* TO '${user}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Starting mysql ..."
sudo service mysql restart