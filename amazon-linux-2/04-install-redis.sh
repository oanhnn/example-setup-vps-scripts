#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# install Redis
amazon-linux-extras install -y redis4.0

yum install -y redis

systemctl enable redis
systemctl start redis
