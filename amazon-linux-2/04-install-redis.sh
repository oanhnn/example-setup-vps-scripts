#!/bin/bash -ex

# install Redis
amazon-linux-extras install -y redis4.0
yum install -y redis
systemctl enable redis
systemctl start redis
