#!/bin/bash
# Update and upgrade
sudo apt update
sudo apt upgrade -y

# Install all relevant packages
sudo apt install unzip nginx git -y

# Download the NodeSource setup script for Node.js 20.x
# and  save it in the file nodesource_setup.sh
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh

# Run the NodeSource setup file with administrator privileges
sudo bash nodesource_setup.sh

# Install the relevant version of Node.js and pm2
sudo apt install nodejs -y
sudo npm install -g pm2

# Fresh clone each run so re-runs are safe
cd ~
rm -rf tictactoe-deploy
git clone https://github.com/Adnan-SpartaGlobal/tictactoe-deploy.git
cd tictactoe-deploy

# Unzip and run the app only if the zip file exists
if [ -f nodejs20-sparta-tictactoe-v1.zip ]; then
    unzip -o nodejs20-sparta-tictactoe-v1.zip
    cd app

    # Connect the app to the database. Replace <DB_PUBLIC_IP> with the DB instance's IP.
    # Must be set before npm install (which seeds the db from code trainer set up) and before pm2 start.
    DB_PUBLIC_IP="3.248.203.167"
    export MONGODB_URI="mongodb://${DB_PUBLIC_IP}:27017/tic-tac-toe"

    npm install

    # Remove any existing tictactoe web-apps  process 
    # so re-runs don't create duplicates. If there are no 
    # existing processes, then carry on via || true.
    pm2 delete tictactoe || true

    # Start the app and call it tictactoe
    pm2 start index.js --name tictactoe

    pm2 startup systemd -u root --hp /root
    pm2 save

    # Reverse proxy: replace nginx's file-serving line with a proxy to the app.
    # On re-runs the line is already gone, so sed changes nothing.
    sudo sed -i 's|try_files \$uri \$uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default

    # Check the config is valid, and only reload nginx if it is
    sudo nginx -t && sudo systemctl reload nginx         

else
    echo "Cannot find zip file needed"
fi
