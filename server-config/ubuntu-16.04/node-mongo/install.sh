#!/usr/bin/env bash

sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/updates-repos.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/build-essentials.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/graphics.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/mongo.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/letsencrypt.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/fail2ban.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/nginx.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/firewall.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/node-mongo/node-nvm-pm2.sh)"
