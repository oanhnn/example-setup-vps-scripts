#!/bin/bash -ex

# load environment variables
if [[ -f .env ]]; then
 source .env
fi

# fixed enviroment variables
DEBIAN_FRONTEND=noninteractive
SSH_USER=${SSH_USER:-"oanhnn"}
ES_VERSION=${ES_VERSION:-"6.7.0"}

# Install JavaSDK
apt install openjdk-8-jdk

# Get Elastic Search package
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ES_VERSION}.deb
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ES_VERSION}.deb.sha512

# checksum
shasum -a 512 -c elasticsearch-oss-${ES_VERSION}.deb.sha512

# Install Elastic Search
dpkg -i elasticsearch-oss-${ES_VERSION}.deb
rm -f elasticsearch-oss-${ES_VERSION}.deb

# Configure Elastic Search
sed -i 's|#*cluster.name:.*|cluster.name: ES_01|g'   /etc/elasticsearch/elasticsearch.yml
sed -i 's|#*node.name:.*|node.name: ES_01_Node_01|g' /etc/elasticsearch/elasticsearch.yml
sed -i 's|#*network.host:.*|network.host: 0.0.0.0|g' /etc/elasticsearch/elasticsearch.yml
sed -i 's|#*http.port:.*|http.port: 9200|g'          /etc/elasticsearch/elasticsearch.yml

# Enable and start Elastic Search service
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

# Enable Firewall
ufw allow 9200
