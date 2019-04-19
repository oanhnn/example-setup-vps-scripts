#!/bin/bash -ex

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

#apt install -y software-properties-common
add-apt-repository ppa:vbernat/haproxy-1.9 -y

apt update -y
apt install -y haproxy

systemctl start haproxy
systemctl enable haproxy

ufw allow 80
ufw allow 443
