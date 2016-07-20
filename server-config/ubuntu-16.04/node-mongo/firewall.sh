#!/usr/bin/env bash

ufw --force enable
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable
