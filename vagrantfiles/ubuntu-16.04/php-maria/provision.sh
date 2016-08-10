#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

mkdir -p /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

apt-get update
apt-get upgrade

apt-get --no-install-recommends install -y virtualbox-guest-utils

apt-get install -y build-essential checkinstall git

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

ufw --force enable
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8000
ufw allow 8080
ufw allow 3306
ufw allow 3307
ufw allow 4000
ufw allow 9000

MYSQL_ROOT_PASSWORD="root"
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
apt-get -qq install mysql-server > /dev/null
apt-get install -y mysql-client
systemctl enable mysql

apt-get install -y ghostscript libgs-dev imagemagick

apt-get install -y apache2
apt-get install -y php php-cli libapache2-mod-php php-mcrypt php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-json

a2enmod access_compat
a2enmod rewrite
a2enmod headers
a2enmod expires
a2enmod ssl
sed 's/AllowOverride None/AllowOverride All/g' -i /etc/apache2/apache2.conf
sed 's/;date.timezone =/date.timezone = "America\/Detroit"/' -i /etc/php/7.0/apache2/php.ini
sed 's/memory_limit = 128M/memory_limit = 1G/' -i /etc/php/7.0/apache2/php.ini

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "ServerTokens ProductOnly" >> /etc/apache2/apache2.conf
echo "ServerSignature Off" >> /etc/apache2/apache2.conf

echo "ServerName $(cat /etc/hostname)" | tee /etc/apache2/conf-available/servername.conf
a2enconf servername

mkdir -p /etc/ssl/private
chmod 710 /etc/ssl/private
openssl dhparam -out /etc/ssl/private/dhparams.pem 2048
chmod 600 /etc/ssl/private/dhparams.pem

sed 's/#SSLHonorCipherOrder on/SSLHonorCipherOrder on/' -i /etc/apache2/mods-available/ssl.conf
sed 's/#SSLStrictSNIVHostCheck On/#SSLStrictSNIVHostCheck On\n\n\tSSLOpenSSLConfCmd DHParameters "\/etc\/ssl\/private\/dhparams.pem"\n\tSSLStaplingCache shmcb:${APACHE_RUN_DIR}\/ssl_stapling_cache(128000)/' -i /etc/apache2/mods-available/ssl.conf

mkdir -p /etc/apache2/snippets
echo -e '# Header always set Content-Security-Policy "default-src https:"\nHeader always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"\nHeader always set X-Frame-Options "SAMEORIGIN"\nHeader always set X-Xss-Protection "1; mode=block"\nHeader always set X-Content-Type-Options "nosniff"' >> /etc/apache2/snippets/securityHeaders.conf
echo -e 'SSLUseStapling on\nSSLStaplingReturnResponderErrors off\nSSLStaplingResponderTimeout 5' >> /etc/apache2/snippets/sslStapling.conf

apt-get install -y memcached php-memcached
systemctl restart memcached
systemctl enable memcached

echo -e '<VirtualHost *:80>\n  ServerAdmin webmaster@localhost\n  DocumentRoot /var/www\n  DirectoryIndex index.php index.html index.htm\n\n  Include /etc/apache2/snippets/securityHeaders.conf\n\n  ErrorLog ${APACHE_LOG_DIR}/error.log\n  CustomLog ${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

systemctl restart apache2.service
systemctl enable apache2.service

apt-get install -y sendmail
systemctl start sendmail.service
systemctl enable sendmail.service

apt-get install -y letsencrypt
crontab -l | { cat; echo "30 2 * * 1 /usr/bin/letsencrypt renew >> /var/log/le-renew.log"; } | crontab -
crontab -l | { cat; echo "35 2 * * 1 /bin/systemctl reload nginx"; } | crontab -

apt-get install -y fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
