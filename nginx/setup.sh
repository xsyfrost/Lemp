#!/bin/bash

apt install nginx

sudo sed -i "s/www-data/$user $group/" /etc/nginx/nginx.conf

echo "Starting nginx ..."
sudo service nginx restart