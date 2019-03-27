#!/bin/bash -ex

# customable enviroment variables
HOSTNAME=emaple-svr

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive

# set hostname
hostnamectl set-hostname ${HOSTNAME}

# set locale
localectl set-locale LANG=en_US.UTF-8 LANGUAGE="en_US:en"

# set timezone
timedatectl set-timezone Asia/Ho_Chi_Minh

# update
apt update -y
apt upgrade -y
apt autoremove -y
apt install -y git wget curl gcc g++ make

# firewall
ufw allow ssh
#ufw enable
