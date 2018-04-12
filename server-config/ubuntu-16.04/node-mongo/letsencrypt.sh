#!/usr/bin/env bash

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot
sudo crontab -l | { cat; echo "28 2 * * 1 /bin/systemctl stop nginx"; } | crontab -
sudo crontab -l | { cat; echo "30 2 * * 1 /usr/bin/certbot renew >> /var/log/certbot-renew.log"; } | crontab -
sudo crontab -l | { cat; echo "35 2 * * 1 /bin/systemctl start nginx"; } | crontab -
