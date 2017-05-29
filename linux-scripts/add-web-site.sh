#!/usr/bin/env bash

SITE_POSTFIX=$1
SITE_DIRECTORY=$2
SITE_DOMAIN=$3

if [ "$#" -ne 3 ]; then
    read -p "Postfix: " site_postfix
    read -p "Directory: " site_directory
    read -p "Domain: " site_domain

    SITE_POSTFIX=${site_postfix}
    SITE_DIRECTORY=${site_directory}
    SITE_DOMAIN=${site_domain}
fi

cat > site_${SITE_POSTFIX}.conf << EOM
<VirtualHost *:80>
        ServerAdmin admin@milkneko.com
        ServerName ${SITE_DOMAIN}

        DocumentRoot ${SITE_DIRECTORY}

        <Directory ${SITE_DIRECTORY}>
           #Options Indexes FollowSymLinks
           #AllowOverride AuthConfig
           Require all granted
        </Directory>
 </VirtualHost>
EOM

sudo mv site_${SITE_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite site_${SITE_POSTFIX}.conf
sudo service apache2 reload

