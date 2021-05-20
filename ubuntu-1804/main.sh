#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive
VPS_HOSTNAME=${VPS_HOSTNAME:-"example-svr"}
VPS_TIMEZONE=${VPS_TIMEZONE:-"UTC"}
SSH_FROM_IP=${SSH_FROM_IP:-"any"}

# set hostname
hostnamectl set-hostname $VPS_HOSTNAME

# set locale
localectl set-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en"

# set timezone
timedatectl set-timezone $VPS_TIMEZONE

# update
apt update -y
apt upgrade -y
apt autoremove -y
apt install -y apt-transport-https git wget curl gcc g++ gnupg-agent make ca-certificates software-properties-common

# firewall
ufw default deny incoming
ufw default allow outgoing
# only allow ssh from some IPs
ufw allow from $SSH_FROM_IP to any port 22 proto tcp
ufw enable
