#!/bin/bash -ex

ES_VERSION="6.7.0"

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

# Enable and start Elastic Search service
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

# Enable Firewall
ufw allow 9200
