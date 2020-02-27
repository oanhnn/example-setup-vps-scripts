#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# install NodeJS
curl -sL https://rpm.nodesource.com/setup_12.x | bash -
yum install -y nodejs
