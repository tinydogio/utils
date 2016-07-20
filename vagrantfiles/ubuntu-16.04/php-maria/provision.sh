#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install -y build-essential checkinstall git

sudo apt-get install -y apache2

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

sudo ufw --force enable
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8000
sudo ufw allow 8080
sudo ufw allow 3306
sudo ufw allow 3307
sudo ufw allow 4000
sudo ufw allow 9000

sudo systemctl enable apache2
sudo a2enmod rewrite

sudo apt-get install -y mysql-server
sudo systemctl enable mysqld

sudo apt-get install -y php libapache2-mod-php php-mcrypt php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc

sudo sed 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/g' -i /etc/apache2/mods-enabled/dir.conf

sudo systemctl restart apache2
