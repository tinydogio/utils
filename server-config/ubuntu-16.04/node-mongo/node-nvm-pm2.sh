#!/usr/bin/env bash

sudo curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
sudo echo -e "\n\n# NVM Source\nsource ~/.nvm/nvm.sh" >> ~/.bashrc
sudo source ~/.nvm/nvm.sh
sudo nvm install v4.4.7
sudo nvm alias default v4.4.7

sudo npm install pm2@latest -g
sudo pm2 completion install
