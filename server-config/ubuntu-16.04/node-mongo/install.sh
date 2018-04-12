#!/usr/bin/env bash

sudo sh ./updates-repos.sh
sudo sh ./build-essentials.sh
sudo sh ./graphics.sh
sudo sh ./mongo.sh
sudo sh ./letsencrypt.sh
sudo sh ./fail2ban.sh
sudo sh ./nginx.sh
sudo sh ./node-nvm-pm2.sh
sudo sh ./firewall.sh
