#!/usr/bin/env bash

sudo apt-get install -y letsencrypt
sudo crontab -l | { cat; echo "30 2 * * 1 /usr/bin/letsencrypt renew >> /var/log/le-renew.log"; } | crontab -
sudo crontab -l | { cat; echo "35 2 * * 1 /bin/systemctl reload nginx"; } | crontab -
