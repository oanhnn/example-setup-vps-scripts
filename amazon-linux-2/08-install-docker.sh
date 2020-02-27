#!/bin/bash -ex

yum update -y
yum install -y docker

systemctl start docker
systemctl enable docker

curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

usermod -a -G docker ec2-user
