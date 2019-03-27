#!/bin/bash -ex

# install Redis
apt install -y redis
systemctl enable redis-server
systemctl start redis-server

# firewall
ufw allow 6379
