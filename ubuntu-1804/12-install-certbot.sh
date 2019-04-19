#!/bin/bash -ex

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

#apt install -y software-properties-common
add-apt-repository ppa:certbot/certbot -y

apt update -y
apt install -y certbot
