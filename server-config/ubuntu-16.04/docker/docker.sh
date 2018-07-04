#!/usr/bin/env bash

sudo apt-get remove docker docker-engine docker.io

sudo curl -fsSL get.docker.com -o get-docker.sh

sudo sh get-docker.sh
