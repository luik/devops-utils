#!/usr/bin/env bash

SERVER_POSTFIX=$1
SERVER_PORT=$2
SERVER_DOMAIN=$3
SERVER_HOME=$4
SERVER_JAR=$5

if [ "$#" -ne 3 ]; then
    read -p "Postfix: " server_postfix
    read -p "Port: " server_port
    read -p "Domain: " server_domain
    read -p "Home: " server_home
    read -p "Jar:" server_jar

    SERVER_POSTFIX=${server_postfix}
    SERVER_PORT=${server_port}
    SERVER_DOMAIN=${server_domain}
    SERVER_HOME=${server_home}
    SERVER_JAR=${server_jar}
fi

cd ${SERVER_HOME}

cat > java_server_${SERVER_POSTFIX}.ini << EOM
#!/bin/bash
### BEGIN INIT INFO
# Provides: java_server_${SERVER_POSTFIX}
# Required-Start: \$local_fs \$network \$named \$time \$syslog
# Required-Stop: \$local_fs \$network \$named \$time \$syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: java_server_${SERVER_POSTFIX}
### END INIT INFO

SERVICE_NAME=java_server_${SERVER_POSTFIX}
PID_PATH_NAME=/tmp/java_server_${SERVER_POSTFIX}
PORT=${SERVER_PORT}

cd ${SERVER_HOME}

case \$1 in
    start)
        echo "Starting \$SERVICE_NAME ..."
        if [ ! -f \$PID_PATH_NAME ]; then
            sudo -E -u ubuntu nohup java -jar ${SERVER_JAR} --server.port=\$PORT 2>> java_server_${SERVER_POSTFIX}.err >> java_server_${SERVER_POSTFIX}.log &
            echo \$! > \$PID_PATH_NAME
           echo "\$SERVICE_NAME started ..."
        else
            echo "\$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f \$PID_PATH_NAME ]; then
            PID=\$(cat \$PID_PATH_NAME);
            echo "\$SERVICE_NAME stoping ..."
            kill \$PID;
            echo "\$SERVICE_NAME stopped ..."
            rm \$PID_PATH_NAME
        else
            echo "\$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f \$PID_PATH_NAME ]; then
            PID=\$(cat \$PID_PATH_NAME);
            echo "\$SERVICE_NAME stopping ...";
            kill \$PID;
            echo "\$SERVICE_NAME stopped ...";
            rm \$PID_PATH_NAME
            echo "\$SERVICE_NAME starting ..."
            sudo -E -u ubuntu nohup java -jar ${SERVER_JAR} --server.port=\$PORT 2>> java_server_${SERVER_POSTFIX}.err >> java_server_${SERVER_POSTFIX}.log &
            echo "\$SERVICE_NAME started ..."
        else
            echo "\$SERVICE_NAME is not running ..."
        fi
    ;;

esac

EOM

sudo mv java_server_${SERVER_POSTFIX}.ini /etc/init.d/java_server_${SERVER_POSTFIX}
sudo chmod +x /etc/init.d/java_server_${SERVER_POSTFIX}
sudo update-rc.d java_server_${SERVER_POSTFIX} defaults 82
sudo service java_server_${SERVER_POSTFIX} start


cat > java_server_${SERVER_POSTFIX}.conf << EOM
<VirtualHost *:80>
         ServerAdmin admin@milkneko.com
         ServerName ${SERVER_DOMAIN}

         AllowEncodedSlashes NoDecode
         ProxyPass / http://localhost:${SERVER_PORT}/ nocanon
         ProxyPassReverse / http://localhost:${SERVER_PORT}/
 </VirtualHost>
EOM

sudo mv java_server_${SERVER_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite java_server_${SERVER_POSTFIX}
sudo service apache2 reload
