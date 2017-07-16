#!/usr/bin/env bash

SERVER_POSTFIX=$1
SERVER_PORT=$2
SERVER_DOMAIN=$3

if [ "$#" -ne 3 ]; then
    read -p "Postfix: " server_postfix
    read -p "Port: " server_port
    read -p "Domain: " server_domain

    SERVER_POSTFIX=${server_postfix}
    SERVER_PORT=${server_port}
    SERVER_DOMAIN=${server_domain}
fi


cat > reverse_proxying_${SERVER_POSTFIX}.conf << EOM
<VirtualHost *:80>
         ServerAdmin admin@milkneko.com
         ServerName ${SERVER_DOMAIN}

         AllowEncodedSlashes NoDecode
         ProxyPass / http://localhost:${SERVER_PORT}/ nocanon
         ProxyPassReverse / http://localhost:${SERVER_PORT}/
 </VirtualHost>
EOM

sudo mv reverse_proxying_${SERVER_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite reverse_proxying_${SERVER_POSTFIX}
sudo service apache2 reload
