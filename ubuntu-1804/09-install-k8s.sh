#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive
SSH_USER=${SSH_USER:-"oanhnn"}
