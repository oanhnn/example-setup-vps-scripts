#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive
SSH_USER=${SSH_USER:-"oanhnn"}
SSH_AUTHORIZED_KEYS=${SSH_AUTHORIZED_KEYS:-"https://github.com/${SSH_USER}.keys"}

# install NGINX
amazon-linux-extras install -y nginx1.12
yum install -y nginx
systemctl enable nginx
systemctl start nginx

# create webroot
mkdir -p /var/www/html
usermod -a -G apache $SSH_USER
chown -R $SSH_USER:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
