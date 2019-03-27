#!/bin/bash -ex

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# install PHP
apt install -y php7.2-bcmath php7.2-cli php7.2-fpm php7.2-gd php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-zip php7.2-xml php7.2-redis php7.2-imagick

sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.2/fpm/php.ini
sed -i 's|;*expose_php=.*|expose_php=0|g' /etc/php/7.2/fpm/php.ini
#sed -i 's|;*memory_limit = 128M|memory_limit = 512M|g' /etc/php/7.2/fpm/php.ini
sed -i 's|;*post_max_size = 8M|post_max_size = 50M|g' /etc/php/7.2/fpm/php.ini
sed -i 's|;*upload_max_filesize = 2M|upload_max_filesize = 10M|g' /etc/php/7.2/fpm/php.ini
sed -i 's|;*max_file_uploads = 20|max_file_uploads = 20|g' /etc/php/7.2/fpm/php.ini

systemctl enable php7.2-fpm
systemctl start php7.2-fpm

# install Composer
if [[ "$HOME" == "" ]]; then
    export COMPOSER_HOME=/root
fi
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --quiet --install-dir=/usr/local/bin/ --filename=composer
rm -f composer-setup.php
