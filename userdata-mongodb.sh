#!/bin/bash
# 3c: User data version of the DB script (runs as root on first boot, so no sudo needed)

apt update
apt install gnupg curl -y

curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   gpg --batch --yes -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list

apt update -y

DEBIAN_FRONTEND=noninteractive apt-get install -y \
   mongodb-org=7.0.22 \
   mongodb-org-database=7.0.22 \
   mongodb-org-server=7.0.22 \
   mongodb-mongosh \
   mongodb-org-shell=7.0.22 \
   mongodb-org-mongos=7.0.22 \
   mongodb-org-tools=7.0.22 \
   mongodb-org-database-tools-extra=7.0.22

# Config change: allow connections from other machines
sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

systemctl start mongod
systemctl enable mongod
