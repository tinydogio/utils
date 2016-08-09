#!/usr/bin/env bash

echo "Please enter a password for the MySQL root user: "
read MYSQL_ROOT_PASSWORD

# TODO: Implement SSH key for deployment keys.
# echo "Please enter an email address for a server SSH key (used for deployment keys): "
# read SSH_KEY_EMAIL
# echo "Please enter a password for a server SSH key (used for deployment keys): "
# read SSH_KEY_PASSWORD

# -----------------------

apt-get -y update
apt-get install -y build-essential checkinstall git

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
apt-get -qq install mysql-server > /dev/null
apt-get install -y mysql-client
systemctl enable mysql
# TODO: Automate mysql_secure_installation. Look into "expect"
# mysql_secure_installation

apt-get install -y apache2
apt-get install -y php libapache2-mod-php php-mcrypt php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc

a2enmod access_compat
a2enmod rewrite
a2enmod headers
a2enmod expires
a2enmod ssl
sed 's/AllowOverride None/AllowOverride All/g' -i /etc/apache2/apache2.conf

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
echo -e '# Header always set Content-Security-Policy "default-src https:"\nHeader always set Strict-Transport-Security "max-age=63072000; includeSubdomains;"\nHeader always set X-Frame-Options "SAMEORIGIN"\nHeader always set X-Xss-Protection "1; mode=block"\nHeader always set X-Content-Type-Options "nosniff"' >> /etc/apache2/snippets/securityHeaders2.conf
echo -e 'SSLUseStapling on\nSSLStaplingReturnResponderErrors off\nSSLStaplingResponderTimeout 5' >> /etc/apache2/snippets/sslStapling.conf

apt-get install -y memcached php-memcached
systemctl restart memcached
systemctl enable memcached

systemctl restart apache2.service
systemctl enable apache2.service

apt-get install -y sendmail
systemctl start sendmail.service
systemctl enable sendmail.service

ufw --force enable
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable

apt-get install -y letsencrypt
crontab -l | { cat; echo "30 2 * * 1 /usr/bin/letsencrypt renew >> /var/log/le-renew.log"; } | crontab -
crontab -l | { cat; echo "35 2 * * 1 /bin/systemctl reload nginx"; } | crontab -

apt-get install -y fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# TODO: Implement SSH key for deployment keys.
# Need a way to automate the password entry for this
#ssh-keygen -t rsa -b 4096 -C "$SSH_KEY_EMAIL" -P "$SSH_KEY_PASSWORD" -f "/root/.ssh/id_rsa" -q
#ssh-add /root/.ssh/id_rsa
