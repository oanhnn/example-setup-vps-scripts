#!/bin/bash
set -ex

#### About
# This script for setup Ubuntu 18.04 / 20.04 on Linode Cloud

#### VPS
#<UDF name="VPS_HOSTNAME" label="Server Hostname" default="">
#<UDF name="VPS_TIMEZONE" label="Server Timezone" default="UTC">
#### SSH
#<UDF name="SSH_USER" label="SSH Username" default="oanhnn">
#<UDF name="SSH_AUTHORIZED_KEYS" label="The URL for download authorized keys" example="https://github.com/oanhnn.keys" default="">
#<UDF name="SSH_ALLOW_FROM" label="Where is access to server?" example="xxx.xxx.xxx.xxx/32 xxx.xxx.xxx.xxx/32" default="any">
#<UDF name="SSH_PORT" label="SSH Port" default="22">
#<UDF name="SSH_PASSWORD_LOGIN" label="Permit SSH Password Login?" oneOf="no,yes" default="no">
#<UDF name="SSH_ROOT_LOGIN" label="Permit Root SSH Login?" oneOf="no,yes" default="no">
#### Feature
#<UDF name="FEATURE_DOCKER" label="Install Docker?" oneOf="no,yes" default="no">
#<UDF name="FEATURE_HTTP" label="Open HTTP port?" oneOf="no,yes" default="no">
#<UDF name="FEATURE_HTTPS" label="Open HTTP port?" oneOf="no,yes" default="no">

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive
VPS_HOSTNAME=${VPS_HOSTNAME:-"ubuntu"}
VPS_TIMEZONE=${VPS_TIMEZONE:-"UTC"}
SSH_USER=${SSH_USER:-"oanhnn"}
SSH_AUTHORIZED_KEYS=${SSH_AUTHORIZED_KEYS:-"https://github.com/${SSH_USER}.keys"}
SSH_ALLOW_FROM=${SSH_ALLOW_FROM:-"any"}

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
for WHERE in $SSH_ALLOW_FROM
do
    ufw allow from $WHERE to any port 22
done
ufw --force enable

# add user
addgroup dev
adduser --disabled-password --gecos "" --ingroup dev $SSH_USER
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
echo "$SSH_USER ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/$SSH_USER

# Better ssh config
sed -i -e "s/.*AddressFamily .*/AddressFamily inet/" /etc/ssh/sshd_config
sed -i -e "s/.*LoginGraceTime .*/LoginGraceTime 1m/" /etc/ssh/sshd_config
sed -i -e "s/.*ClientAliveInterval .*/ClientAliveInterval 600/" /etc/ssh/sshd_config
sed -i -e "s/.*ClientAliveCountMax .*/ClientAliveCountMax 0/" /etc/ssh/sshd_config
if [ "$SSH_PASSWORD_LOGIN" = 'no' ] && [ "$SSH_AUTHORIZED_KEYS" != '' ]
then
    sed -i -e "s/.*PasswordAuthentication .*/PasswordAuthentication no/" /etc/ssh/sshd_config
fi
if [ "$SSH_ROOT_LOGIN" = 'no' ]
then
    sed -i -e "s/.*PermitRootLogin .*/PermitRootLogin no/" /etc/ssh/sshd_config

    # Allowed ssh users in /etc/ssh/sshd_config
    echo "AllowUsers $SSH_USER" >> /etc/ssh/sshd_config
fi
systemctl restart sshd

# setup docker
if [ "$FEATURE_DOCKER" = 'yes' ]
then
    curl -fsSL https://get.docker.com | bash -
    usermod -aG docker $SSH_USER
    systemctl start docker
    systemctl enable docker
    # get latest docker compose released tag
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    # Install docker-compose
    curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
fi

if [ "$FEATURE_HTTP" = 'yes' ]
then
    ufw allow http
fi
if [ "$FEATURE_HTTPS" = 'yes' ]
then
    ufw allow https
fi
