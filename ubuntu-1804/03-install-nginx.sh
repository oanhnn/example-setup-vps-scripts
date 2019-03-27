#!/bin/bash -ex

# customable enviroment variables
GITLABUSER=oanhnn
SSHUSER=oanhnn

# install NGINX
apt install -y nginx
systemctl enable nginx
systemctl start nginx

# firewall
ufw allow http
ufw allow https

# www dir
mkdir -p /var/www/html
chown -R $SSHUSER:www-data /var/www
chmod 2775 /var/www
