#!/bin/bash
# Update and upgrade
sudo apt update
sudo apt upgrade -y

# Install all relevant packages
sudo apt install unzip nginx -y

# Download the NodeSource setup script for Node.js 20.x
# and  save it in the file nodesource_setup.sh
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh

# Run the NodeSource setup file with administrator privileges
sudo bash nodesource_setup.sh

# Install the relevant version of Node.js and pm2
sudo apt install nodejs -y
sudo npm install -g pm2

# Unzip and run the app only if the zip file exists
if [ -f nodejs20-sparta-tictactoe-v1.zip ]; then
    unzip -o nodejs20-sparta-tictactoe-v1.zip
    cd app
    npm install

    # Remove any existing tictactoe web-apps  process 
    # so re-runs don't create duplicates. If there are no 
    # existing processes, then carry on via || true.
    pm2 delete tictactoe || true

    # Start the app and call it tictactoe
    pm2 start index.js --name tictactoe
         
else
    echo "Cannot find zip file needed"
fi

