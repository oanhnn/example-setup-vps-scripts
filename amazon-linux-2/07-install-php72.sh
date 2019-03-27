#!/bin/bash -ex

# install PHP7.2
amazon-linux-extras install -y php7.2
yum install -y php-bcmath php-cli php-fpm php-gd php-intl php-json php-mbstring php-mysqlnd php-opcache php-pdo php-pecl-zip php-xml

sed -i 's|;*expose_php=.*|expose_php=0|g' /etc/php.ini
sed -i 's|;*memory_limit = 128M|memory_limit = 512M|g' /etc/php.ini
sed -i 's|;*post_max_size = 8M|post_max_size = 50M|g' /etc/php.ini
sed -i 's|;*upload_max_filesize = 2M|upload_max_filesize = 10M|g' /etc/php.ini
sed -i 's|;*max_file_uploads = 20|max_file_uploads = 20|g' /etc/php.ini
sed -i 's|;*opcache.memory_consumption=128|opcache.memory_consumption=256|g' /etc/php.d/10-opcache.ini
sed -i 's|;*opcache.interned_strings_buffer=8|opcache.interned_strings_buffer=16|g' /etc/php.d/10-opcache.ini
sed -i 's|;*opcache.max_accelerated_files=4000|opcache.max_accelerated_files=10000|g' /etc/php.d/10-opcache.ini
sed -i 's|;*opcache.max_wasted_percentage=5|opcache.max_wasted_percentage=10|g' /etc/php.d/10-opcache.ini
sed -i 's|;*opcache.validate_timestamps=1|opcache.validate_timestamps=1|g' /etc/php.d/10-opcache.ini
sed -i 's|;*opcache.revalidate_freq=2|opcache.revalidate_freq=60|g' /etc/php.d/10-opcache.ini
sed -i 's|;*opcache.fast_shutdown=0|opcache.fast_shutdown=0|g' /etc/php.d/10-opcache.ini

# install Composer
if [[ "$HOME" == "" ]]; then
    export COMPOSER_HOME=/root
fi
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --quiet --install-dir=/usr/local/bin/ --filename=composer
rm -f composer-setup.php

# install some PECL packages
yum install -y php-devel php-pear ImageMagick-devel ImageMagick
pecl channel-update pecl.php.net
pecl install imagick redis xdebug
echo 'extension=imagick.so' > /etc/php.d/20-imagick.ini
echo 'extension=redis.so' > /etc/php.d/20-redis.ini
yum remove -y php-devel php-pear ImageMagick-devel
systemctl start php-fpm
systemctl enable php-fpm
