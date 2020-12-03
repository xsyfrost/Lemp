#!/bin/bash

#Setup MariaDB & create a user
sudo apt -y install mariadb-server mariadb-client
#Create db and user
sudo mysql -e "CREATE DATABASE IF NOT EXISTS  ${mysqlDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysqlUserSQLRow=$(sudo mysql -e "SELECT user,host FROM mysql.user WHERE user = '${user}' AND host = 'localhost';")
if [ -z "$mysqlUserSQLRow" ]; then
    sudo mysql -e "CREATE USER ${user}@localhost IDENTIFIED BY '${mysqlPassword}';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON ${mysqlDB}.* TO '${user}'@'localhost';"
    sudo mysql -e "FLUSH PRIVILEGES;"
else
    sudo mysql -e "ALTER USER '${user}'@'localhost' IDENTIFIED BY '${mysqlPassword}'";
fi

echo "Starting mysql ..."
sudo service mysql restart
