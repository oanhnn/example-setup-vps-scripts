#!/bin/bash -ex

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# install mariadb server 5.7.x
apt install -y mysql-server
systemctl enable mysql
systemctl start mysql
