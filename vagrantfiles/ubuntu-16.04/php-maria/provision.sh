#!/usr/bin/env bash

sudo mkdir -p /home/vagrant/.ssh
sudo wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
sudo chmod 0700 /home/vagrant/.ssh
sudo chmod 0600 /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant /home/vagrant/.ssh

sudo apt-get update
sudo apt-get upgrade

sudo apt-get --no-install-recommends install -y virtualbox-guest-utils

sudo apt-get install -y build-essential checkinstall git

sudo apt-get install -y apache2

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

sudo ufw --force enable
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 8000
sudo ufw allow 8080
sudo ufw allow 3306
sudo ufw allow 3307
sudo ufw allow 4000
sudo ufw allow 9000

sudo MYSQL_ROOT_PASSWORD="root"
sudo export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
sudo apt-get -qq install mysql-server > /dev/null
sudo apt-get install -y mysql-client
sudo systemctl enable mysql

sudo apt-get install -y ghostscript libgs-dev imagemagick

sudo apt-get install -y apache2
sudo apt-get install -y php php-cli libapache2-mod-php php-mcrypt php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-json

sudo a2enmod access_compat
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod expires
sudo a2enmod ssl
sudo sed 's/AllowOverride None/AllowOverride All/g' -i /etc/apache2/apache2.conf
sudo sed 's/;date.timezone =/date.timezone = "America\/Detroit"/' -i /etc/php/7.0/apache2/php.ini
sudo sed 's/memory_limit = 128M/memory_limit = 1G/' -i /etc/php/7.0/apache2/php.ini

sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

sudo echo "ServerTokens ProductOnly" >> /etc/apache2/apache2.conf
sudo echo "ServerSignature Off" >> /etc/apache2/apache2.conf

sudo echo "ServerName $(cat /etc/hostname)" | tee /etc/apache2/conf-available/servername.conf
sudo a2enconf servername

sudo mkdir -p /etc/ssl/private
sudo chmod 710 /etc/ssl/private
sudo openssl dhparam -out /etc/ssl/private/dhparams.pem 2048
sudo chmod 600 /etc/ssl/private/dhparams.pem

sudo sed 's/#SSLHonorCipherOrder on/SSLHonorCipherOrder on/' -i /etc/apache2/mods-available/ssl.conf
sudo sed 's/#SSLStrictSNIVHostCheck On/#SSLStrictSNIVHostCheck On\n\n\tSSLOpenSSLConfCmd DHParameters "\/etc\/ssl\/private\/dhparams.pem"\n\tSSLStaplingCache shmcb:${APACHE_RUN_DIR}\/ssl_stapling_cache(128000)/' -i /etc/apache2/mods-available/ssl.conf

sudo mkdir -p /etc/apache2/snippets
sudo echo -e '# Header always set Content-Security-Policy "default-src https:"\nHeader always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"\nHeader always set X-Frame-Options "SAMEORIGIN"\nHeader always set X-Xss-Protection "1; mode=block"\nHeader always set X-Content-Type-Options "nosniff"' >> /etc/apache2/snippets/securityHeaders.conf
sudo echo -e 'SSLUseStapling on\nSSLStaplingReturnResponderErrors off\nSSLStaplingResponderTimeout 5' >> /etc/apache2/snippets/sslStapling.conf

sudo apt-get install -y memcached php-memcached
sudo systemctl restart memcached
sudo systemctl enable memcached

sudo systemctl restart apache2.service
sudo systemctl enable apache2.service

sudo apt-get install -y sendmail
sudo systemctl start sendmail.service
sudo systemctl enable sendmail.service

sudo ufw --force enable
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

sudo apt-get install -y letsencrypt
sudo crontab -l | { cat; echo "30 2 * * 1 /usr/bin/letsencrypt renew >> /var/log/le-renew.log"; } | crontab -
sudo crontab -l | { cat; echo "35 2 * * 1 /bin/systemctl reload nginx"; } | crontab -

sudo apt-get install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
