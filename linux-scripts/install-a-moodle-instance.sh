#!/usr/bin/env bash

MOODLE_POSTFIX=$1
MOODLE_BRANCH=$2
MOODLE_DOMAIN=$3
MYSQL_ROOT_PASSWORD=$4

if [ "$#" -ne 3 ]; then
    read -p "Postfix: " MOODLE_POSTFIX
    read -p "BRANCH: " MOODLE_BRANCH
    read -p "Domain: " MOODLE_DOMAIN
    echo -n "Mysql Root Password: "
    read -s MYSQL_ROOT_PASSWORD
fi

MYSQL_PASSWORD=`openssl rand -base64 12`

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE moodle_${MOODLE_POSTFIX} CHARACTER SET utf8 COLLATE utf8_bin"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER \"moodle_${MOODLE_POSTFIX}\"@\"localhost\" IDENTIFIED BY \"${MYSQL_PASSWORD}\""
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON moodle_${MOODLE_POSTFIX}.* TO \"moodle_${MOODLE_POSTFIX}\"@\"localhost\""

cd /media/nvme1/data/

git clone https://github.com/moodle/moodle
mkdir moodle_${MOODLE_POSTFIX}
mv moodle moodle_${MOODLE_POSTFIX}
cd moodle_${MOODLE_POSTFIX}

mkdir moodle_files
sudo chown www-data:www-data moodle_files

cd moodle
git checkout ${MOODLE_BRANCH}
cp config-dist.php config.php

sed -i "s/'pgsql'/'mysqli'/" config.php
sed -i "s/'moodle'/'moodle_${MOODLE_POSTFIX}'/" config.php
sed -i "s/'username'/'moodle_${MOODLE_POSTFIX}'/" config.php
sed -i "s/'password'/'${MYSQL_PASSWORD}'/" config.php
sed -i "s/'http:\/\/example.com\/moodle'/'http:\/\/${MOODLE_DOMAIN}'/"  config.php
sed -i "s/'\/home\/example\/moodledata'/'\/media\/nvme1\/data\/moodle_${MOODLE_POSTFIX}\/moodle_files'/" config.php

cat > moodle_${MOODLE_POSTFIX}.conf << EOM
<VirtualHost *:80>
         ServerName ${MOODLE_DOMAIN}
         DocumentRoot /media/nvme1/data/moodle_${MOODLE_POSTFIX}/moodle

         <Directory /media/nvme1/data/moodle_${MOODLE_POSTFIX}/moodle>
            Require all granted
         </Directory>
 </VirtualHost>
EOM

sudo mv moodle_${MOODLE_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite moodle_${MOODLE_POSTFIX}
sudo service apache2 reload

