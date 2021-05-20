#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# install MySQL server 5.7.x
yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm

yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community

yum install -y mysql-community-server

systemctl enable mysqld
systemctl start mysqld
