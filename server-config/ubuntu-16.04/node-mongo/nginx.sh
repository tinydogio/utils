#!/usr/bin/env bash

sudo apt-get install nginx -y

sudo mkdir -p /etc/nginx/ssl/certs
sudo openssl dhparam -out /etc/nginx/ssl/certs/dhparam.pem 2048

sed 's/# server_tokens off;/server_tokens off;/g' -i /etc/nginx/nginx.conf

sudo mkdir -p /etc/nginx/snippets
echo -e "# from https://cipherli.st/\n# and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html\n\nssl_protocols TLSv1 TLSv1.1 TLSv1.2;\nssl_prefer_server_ciphers on;\nssl_ciphers \"EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4\";\nssl_ecdh_curve secp384r1;\nssl_session_cache shared:SSL:10m;\nssl_session_timeout 1h;\nssl_session_tickets off;\nssl_stapling on;\nssl_stapling_verify on;\n\nresolver 8.8.8.8 8.8.4.4 valid=300s;\nresolver_timeout 5s;\n\nadd_header Strict-Transport-Security \"max-age=63072000; includeSubdomains; preload\";\nadd_header X-Frame-Options DENY;\nadd_header X-Content-Type-Options nosniff;\n\nssl_dhparam /etc/nginx/ssl/certs/dhparam.pem;" > /etc/nginx/snippets/ssl-params.conf

sudo systemctl reload nginx
