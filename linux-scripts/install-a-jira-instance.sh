#!/usr/bin/env bash

JIRA_VERSION="7.3.2"
MYSQL_DRIVER_VERSION="5.1.41"

JIRA_POSTFIX=$1
JIRA_PORT=$2
JIRA_DOMAIN=$3
MYSQL_ROOT_PASSWORD=$4

if [ "$#" -ne 4 ]; then
    read -p "Postfix: " JIRA_POSTFIX
    read -p "Port: " JIRA_PORT
    read -p "Domain: " JIRA_DOMAIN
    echo -n "Mysql Root Password: "
    read -s MYSQL_ROOT_PASSWORD
fi

MYSQL_PASSWORD=`openssl rand -base64 12`

cd /media/nvme1/data/

curl -O -L https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz
mkdir jira_${JIRA_POSTFIX}
mv atlassian-jira-software-${JIRA_VERSION}.tar.gz jira_${JIRA_POSTFIX}
cd jira_${JIRA_POSTFIX}
tar xf atlassian-jira-software-${JIRA_VERSION}.tar.gz
rm atlassian-jira-software-${JIRA_VERSION}.tar.gz
mkdir jira_home

curl -O -L https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz
tar xf mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz
rm mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz
cp mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}-bin.jar ./atlassian-jira-software-${JIRA_VERSION}-standalone/lib
rm -r mysql-connector-java-${MYSQL_DRIVER_VERSION}/

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE jira_${JIRA_POSTFIX} CHARACTER SET utf8 COLLATE utf8_bin"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER \"jira_${JIRA_POSTFIX}_admin\"@\"localhost\" IDENTIFIED BY \"${MYSQL_PASSWORD}\""
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON jira_${JIRA_POSTFIX}.* TO \"jira_${JIRA_POSTFIX}_admin\"@\"localhost\""

cat > jira_home/dbconfig.xml << EOM
<jira-database-config>
  <name>defaultDS</name>
  <delegator-name>default</delegator-name>
  <database-type>mysql</database-type>
  <jdbc-datasource>
    <url>jdbc:mysql://localhost:3306/jira_${JIRA_POSTFIX}?useUnicode=true&amp;characterEncoding=UTF8&amp;sessionVariables=default_storage_engine=InnoDB&useSSL=false</url>
    <driver-class>com.mysql.jdbc.Driver</driver-class>
    <username>jira_${JIRA_POSTFIX}_admin</username>
    <password>${MYSQL_PASSWORD}</password>
    <pool-min-size>20</pool-min-size>
    <pool-max-size>20</pool-max-size>
    <pool-max-wait>30000</pool-max-wait>
    <validation-query>select 1</validation-query>
    <min-evictable-idle-time-millis>60000</min-evictable-idle-time-millis>
    <time-between-eviction-runs-millis>300000</time-between-eviction-runs-millis>
    <pool-max-idle>20</pool-max-idle>
    <pool-remove-abandoned>true</pool-remove-abandoned>
    <pool-remove-abandoned-timeout>300</pool-remove-abandoned-timeout>
    <pool-test-on-borrow>false</pool-test-on-borrow>
    <pool-test-while-idle>true</pool-test-while-idle>
    <validation-query-timeout>3</validation-query-timeout>
  </jdbc-datasource>
</jira-database-config>
EOM

sed -i "s/jira.home =/jira.home = \/media\/nvme1\/data\/jira_${JIRA_POSTFIX}\/jira_home\//" ./atlassian-jira-software-${JIRA_VERSION}-standalone/atlassian-jira/WEB-INF/classes/jira-application.properties
sed -i "s/8005/$((${JIRA_PORT}+1))/" ./atlassian-jira-software-${JIRA_VERSION}-standalone/conf/server.xml
sed -i "s/8080/${JIRA_PORT}/" ./atlassian-jira-software-${JIRA_VERSION}-standalone/conf/server.xml
sed -i "s/bindOnInit=\"false\"/bindOnInit=\"false\" proxyName=\"${JIRA_DOMAIN}\" proxyPort=\"80\"/" ./atlassian-jira-software-${JIRA_VERSION}-standalone/conf/server.xml

cat > jira_${JIRA_POSTFIX}.conf << EOM
<VirtualHost *:80>
         ServerAdmin admin@milkneko.com
         ServerName ${JIRA_DOMAIN}

         AllowEncodedSlashes NoDecode
         ProxyPass / http://localhost:${JIRA_PORT}/ nocanon
         ProxyPassReverse / http://localhost:${JIRA_PORT}/
 </VirtualHost>
EOM

sudo mv jira_${JIRA_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite jira_${JIRA_POSTFIX}
sudo service apache2 reload

cat > jira_${JIRA_POSTFIX}.ini << EOM
#!/bin/bash
### BEGIN INIT INFO
# Provides: jira_${JIRA_POSTFIX}
# Required-Start: \$local_fs \$network \$named \$time \$syslog
# Required-Stop: \$local_fs \$network \$named \$time \$syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: jira_${JIRA_POSTFIX}
### END INIT INFO
JIRA_ROOT=`pwd`/atlassian-jira-software-${JIRA_VERSION}-standalone/bin

CURRENT_DIR=\`pwd\`
cd \${JIRA_ROOT}

case \$1 in
    start)
        echo "Starting \$SERVICE_NAME ..."
        sudo -E -u ubuntu ./start-jira.sh
    ;;
    stop)
        echo "\$SERVICE_NAME stoping ..."
        sudo -E -u ubuntu ./stop-jira.sh
        echo "\$SERVICE_NAME stopped ..."
    ;;
    restart)
        echo "\$SERVICE_NAME stopping ...";
        sudo -E -u ubuntu ./stop-jira.sh
        echo "\$SERVICE_NAME stopped ...";
        echo "\$SERVICE_NAME starting ..."
        sudo -E -u ubuntu ./start-jira.sh
        echo "\$SERVICE_NAME started ..."
    ;;

esac

cd \$CURRENT_DIR
EOM

sudo mv jira_${JIRA_POSTFIX}.ini /etc/init.d/jira_${JIRA_POSTFIX}
sudo chmod +x /etc/init.d/jira_${JIRA_POSTFIX}
sudo update-rc.d jira_${JIRA_POSTFIX} defaults 82
sudo service jira_${JIRA_POSTFIX} start

echo ${MYSQL_PASSWORD}

