#!/bin/bash

apt -y install nginx

sudo sed -i "s/www-data/$user $group/" /etc/nginx/nginx.conf
sudo sed -i "/# gzip_vary/c\ \tgzip_vary on;" /etc/nginx/nginx.conf
sudo sed -i "/# gzip_types/c\ \tgzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml+rss text\/javascript;" /etc/nginx/nginx.conf

echo "Starting nginx ..."
sudo service nginx restart
