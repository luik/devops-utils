#!/usr/bin/env bash

WORDPRESS_POSTFIX=$1
WORDPRESS_BRANCH=$2
WORDPRESS_DOMAIN=$3
MYSQL_ROOT_PASSWORD=$4

if [ "$#" -ne 3 ]; then
    read -p "Postfix: " WORDPRESS_POSTFIX
    read -p "Branch: " WORDPRESS_BRANCH
    read -p "Domain: " WORDPRESS_DOMAIN
    echo -n "Mysql Root Password: "
    read -s MYSQL_ROOT_PASSWORD
fi

MYSQL_PASSWORD=`openssl rand -base64 12`

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE wp_${WORDPRESS_POSTFIX} CHARACTER SET utf8 COLLATE utf8_bin"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER \"wp_${WORDPRESS_POSTFIX}\"@\"localhost\" IDENTIFIED BY \"${MYSQL_PASSWORD}\""
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON wp_${WORDPRESS_POSTFIX}.* TO \"wp_${WORDPRESS_POSTFIX}\"@\"localhost\""

cd /media/nvme1/data/

git clone https://github.com/WordPress/WordPress
mkdir wordpress_${WORDPRESS_POSTFIX}
mv WordPress wordpress_${WORDPRESS_POSTFIX}
cd wordpress_${WORDPRESS_POSTFIX}/WordPress

WORDPRESS_ROOT=`pwd`

git checkout ${WORDPRESS_BRANCH}

sudo chown www-data:www-data wp-content
cp wp-config-sample.php wp-config.php

sed -i "s|'database_name_here'|'wp_${WORDPRESS_POSTFIX}'|" wp-config.php
sed -i "s|'username_here'|'wp_${WORDPRESS_POSTFIX}'|" wp-config.php
sed -i "s|'password_here'|'${MYSQL_PASSWORD}'|" wp-config.php
sed -i "s|'AUTH_KEY',         'put your unique phrase here'|'AUTH_KEY',         '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php
sed -i "s|'SECURE_AUTH_KEY',  'put your unique phrase here'|'SECURE_AUTH_KEY',  '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php
sed -i "s|'LOGGED_IN_KEY',    'put your unique phrase here'|'LOGGED_IN_KEY',    '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php
sed -i "s|'NONCE_KEY',        'put your unique phrase here'|'NONCE_KEY',        '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php
sed -i "s|'AUTH_SALT',        'put your unique phrase here'|'AUTH_SALT',        '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php
sed -i "s|'SECURE_AUTH_SALT', 'put your unique phrase here'|'SECURE_AUTH_SALT', '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php
sed -i "s|'LOGGED_IN_SALT',   'put your unique phrase here'|'LOGGED_IN_SALT',   '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php
sed -i "s|'NONCE_SALT',       'put your unique phrase here'|'NONCE_SALT',       '"$(echo `openssl rand  -base64 64` | sed "s/[\n| ]//")"'|" wp-config.php


cat > wordpress_${WORDPRESS_POSTFIX}.conf << EOM
<VirtualHost *:80>
         ServerName ${WORDPRESS_DOMAIN}
         DocumentRoot ${WORDPRESS_ROOT}

         <Directory ${WORDPRESS_ROOT}>
            Require all granted
         </Directory>
 </VirtualHost>
EOM

sudo mv wordpress_${WORDPRESS_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite wordpress_${WORDPRESS_POSTFIX}.conf
sudo service apache2 reload

