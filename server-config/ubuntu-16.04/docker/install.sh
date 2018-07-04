#!/usr/bin/env bash

sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/docker/updates-repos.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/docker/build-essentials.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/docker/networking.sh)"
sudo bash -c "$(curl -s https://raw.githubusercontent.com/tinydogio/utils/master/server-config/ubuntu-16.04/docker/docker.sh)"
