#!/bin/bash
# 3a: MongoDB 7.0 deployment script (run on the DB instance, Ubuntu 22.04 "jammy")

sudo apt update

# gnupg handles the signing key, curl downloads it
sudo apt install gnupg curl -y

# Download MongoDB's signing key and save it in the format apt expects
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg --batch --yes -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Tell apt where the MongoDB repo is
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update -y

# Install MongoDB 7.0.22 (noninteractive so nothing waits for a keypress)
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
   mongodb-org=7.0.22 \
   mongodb-org-database=7.0.22 \
   mongodb-org-server=7.0.22 \
   mongodb-mongosh \
   mongodb-org-shell=7.0.22 \
   mongodb-org-mongos=7.0.22 \
   mongodb-org-tools=7.0.22 \
   mongodb-org-database-tools-extra=7.0.22

# Config change: bindIp from 127.0.0.1 to 0.0.0.0 (the same edit as nano, done with sed)
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# Start now and on every boot
sudo systemctl start mongod
sudo systemctl enable mongod
