#!/bin/bash -ex

# customable enviroment variables
SSHUSER=oanhnn

# install NGINX
amazon-linux-extras install -y nginx1.12
yum install -y nginx
systemctl enable nginx
systemctl start nginx

# create webroot
mkdir -p /var/www/html
usermod -a -G apache $SSHUSER
chown -R $SSHUSER:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
