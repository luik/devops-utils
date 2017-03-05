#!/usr/bin/env bash

FISHEYE_VERSION="4.3.1"
MYSQL_DRIVER_VERSION="5.1.41"

FISHEYE_POSTFIX=$1
FISHEYE_PORT=$2
FISHEYE_DOMAIN=$3
MYSQL_ROOT_PASSWORD=$4

if [ "$#" -ne 4 ]; then
    read -p "Postfix: " FISHEYE_POSTFIX
    read -p "Port: " FISHEYE_PORT
    read -p "Domain: " FISHEYE_DOMAIN
    echo -n "Mysql Root Password: "
    read -s MYSQL_ROOT_PASSWORD
fi

MYSQL_PASSWORD=`openssl rand -base64 12`

sudo apt install -y unzip

cd /media/nvme1/data/

curl -O -L https://downloads.atlassian.com/software/fisheye/downloads/fisheye-${FISHEYE_VERSION}.zip
mkdir fisheye_${FISHEYE_POSTFIX}
mv fisheye-${FISHEYE_VERSION}.zip fisheye_${FISHEYE_POSTFIX}

cd fisheye_${FISHEYE_POSTFIX}
unzip fisheye-${FISHEYE_VERSION}.zip
rm fisheye-${FISHEYE_VERSION}.zip
mkdir fisheye_home

curl -O -L https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz
tar xf mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz
rm mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz
cp mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}-bin.jar ./fecru-${FISHEYE_VERSION}/lib
rm -r mysql-connector-java-${MYSQL_DRIVER_VERSION}/

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE fisheye_${FISHEYE_POSTFIX} CHARACTER SET utf8 COLLATE utf8_bin"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER \"fisheye_${FISHEYE_POSTFIX}_admin\"@\"localhost\" IDENTIFIED BY \"${MYSQL_PASSWORD}\""
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON fisheye_${FISHEYE_POSTFIX}.* TO \"fisheye_${FISHEYE_POSTFIX}_admin\"@\"localhost\""

sed -i "s/8059/$((${FISHEYE_PORT}-1))/" ./fecru-${FISHEYE_VERSION}/config.xml
sed -i "s/8060/${FISHEYE_PORT}/" ./fecru-${FISHEYE_VERSION}/config.xml

cat > fisheye_${FISHEYE_POSTFIX}.conf << EOM
<VirtualHost *:80>
         ServerAdmin admin@milkneko.com
         ServerName ${FISHEYE_DOMAIN}

         AllowEncodedSlashes NoDecode
         ProxyPass / http://localhost:${FISHEYE_PORT}/ nocanon
         ProxyPassReverse / http://localhost:${FISHEYE_PORT}/
 </VirtualHost>
EOM

sudo mv fisheye_${FISHEYE_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite fisheye_${FISHEYE_POSTFIX}
sudo service apache2 reload

cat > fisheye_${FISHEYE_POSTFIX}.ini << EOM
#!/bin/bash
### BEGIN INIT INFO
# Provides: fisheye_${FISHEYE_POSTFIX}
# Required-Start: \$local_fs \$network \$named \$time \$syslog
# Required-Stop: \$local_fs \$network \$named \$time \$syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: fisheye_${FISHEYE_POSTFIX}
### END INIT INFO
SERVICE_NAME=fisheye_${FISHEYE_POSTFIX}
JIRA_ROOT=`pwd`/fecru-${FISHEYE_VERSION}/bin

CURRENT_DIR=\`pwd\`
cd \${JIRA_ROOT}

case \$1 in
    start)
        echo "Starting \$SERVICE_NAME ..."
        sudo -E -u ubuntu ./start.sh
    ;;
    stop)
        echo "\$SERVICE_NAME stoping ..."
        sudo -E -u ubuntu ./stop.sh
        echo "\$SERVICE_NAME stopped ..."
    ;;
    restart)
        echo "\$SERVICE_NAME stopping ...";
        sudo -E -u ubuntu ./stop.sh
        echo "\$SERVICE_NAME stopped ...";
        echo "\$SERVICE_NAME starting ..."
        sudo -E -u ubuntu ./start.sh
        echo "\$SERVICE_NAME started ..."
    ;;

esac

cd \$CURRENT_DIR
EOM

sudo mv fisheye_${FISHEYE_POSTFIX}.ini /etc/init.d/fisheye_${FISHEYE_POSTFIX}
sudo chmod +x /etc/init.d/fisheye_${FISHEYE_POSTFIX}
sudo update-rc.d fisheye_${FISHEYE_POSTFIX} defaults 82
sudo service fisheye_${FISHEYE_POSTFIX} start

echo ${MYSQL_PASSWORD}

