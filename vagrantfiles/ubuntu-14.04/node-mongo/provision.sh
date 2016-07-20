#!/usr/bin/env bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install -y build-essential checkinstall

sudo apt-get install -y mongodb-org

sudo echo "mongodb-org hold" | sudo dpkg --set-selections
sudo echo "mongodb-org-server hold" | sudo dpkg --set-selections
sudo echo "mongodb-org-shell hold" | sudo dpkg --set-selections
sudo echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
sudo echo "mongodb-org-tools hold" | sudo dpkg --set-selections

sudo ufw --force enable
sudo ufw allow 22
sudo ufw allow 3000
sudo ufw allow 3001
sudo ufw allow 3002
sudo ufw allow 3003
sudo ufw allow 3004
sudo ufw allow 3005
sudo ufw allow 3006
sudo ufw allow 3007
sudo ufw allow 3008
sudo ufw allow 3009
sudo ufw allow 27017

sudo sed 's/  bindIp: 127.0.0.1/#  bindIp: 127.0.0.1/g' -i /etc/mongod.conf

sudo service mongod restart

export HOME=/home/vagrant
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
echo "source ~/.nvm/nvm.sh" >> /home/vagrant/.bashrc
source /home/vagrant/.nvm/nvm.sh

nvm install 4.4.5
nvm alias default 4.4.5

npm install pm2 -g
