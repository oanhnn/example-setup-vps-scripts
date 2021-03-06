#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# install Redis
apt install -y redis

systemctl enable redis-server
systemctl start redis-server

# firewall
ufw allow 6379
