#!/bin/bash

#Setup MariaDB & create a user
sudo apt -y install mariadb-server mariadb-client
#Create db and user
sudo mysql -e "CREATE DATABASE IF NOT EXISTS  ${mysqlDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS phpmyadmin /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysqlUserSQLRow=$(sudo mysql -e "SELECT user,host FROM mysql.user WHERE user = '${mysqlUser}' AND host = 'localhost';")
if [ -z "$mysqlUserSQLRow" ]; then
    sudo mysql -e "CREATE USER ${mysqlUser}@localhost IDENTIFIED BY '${mysqlPassword}';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON ${mysqlDB}.* TO '${mysqlUser}'@'localhost';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO '${mysqlUser}'@'localhost';"
    sudo mysql -e "FLUSH PRIVILEGES;"
else
    sudo mysql -e "ALTER USER '${mysqlUser}'@'localhost' IDENTIFIED BY '${mysqlPassword}'";
fi

echo "Starting mysql ..."
sudo service mysql restart
