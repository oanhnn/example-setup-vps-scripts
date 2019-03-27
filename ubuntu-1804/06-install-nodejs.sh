#!/bin/bash -ex

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# install NodeJS
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install -y nodejs
