#!/usr/bin/env bash

sudo curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
sudo echo -e "\n\n# NVM Source\nsource ~/.nvm/nvm.sh" >> ~/.bashrc
sudo source ~/.nvm/nvm.sh
sudo nvm install v8.11.1
sudo nvm alias default v8.11.1

sudo npm install pm2@latest -g
sudo pm2 completion install
sudo pm2 save
sudo pm2 startup ubuntu
