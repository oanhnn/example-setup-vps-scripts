#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive
SSH_USER=${SSH_USER:-"oanhnn"}
SSH_AUTHORIZED_KEYS=${SSH_AUTHORIZED_KEYS:-"https://github.com/${SSH_USER}.keys"}

# add user
addgroup dev
adduser --disabled-password --ingroup dev $SSH_USER
usermod -aG sudo $SSH_USER
usermod -aG www-data $SSH_USER

# setup ssh
mkdir -p /home/$SSH_USER/.ssh
wget -q -O /home/$SSH_USER/.ssh/authorized_keys $SSH_AUTHORIZED_KEYS
chown -R $SSH_USER:dev /home/$SSH_USER/.ssh
chmod 755 /home/$SSH_USER/.ssh
find /home/$SSH_USER/.ssh -type d -exec chmod 755 {} \;
find /home/$SSH_USER/.ssh -type f -exec chmod 600 {} \;

# sudo passless
echo "$SSH_USER = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/$SSH_USER
