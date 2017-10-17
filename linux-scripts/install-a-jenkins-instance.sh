#!/usr/bin/env bash

JENKINS_POSTFIX=$1
JENKINS_PORT=$2
JENKINS_DOMAIN=$3
JENKINS_DATA_FOLDER=$4

if [ "$#" -ne 4 ]; then
    read -p "Postfix: " jenkins_postfix
    read -p "Port: " jenkins_port
    read -p "Domain: " jenkins_domain
    read -p "Data folder('ex. /media/nvme1/data'):" jenkins_data_folder

    JENKINS_POSTFIX=${jenkins_postfix}
    JENKINS_PORT=${jenkins_port}
    JENKINS_DOMAIN=${jenkins_domain}
    JENKINS_DATA_FOLDER=${jenkins_data_folder}
fi

cd ${JENKINS_DATA_FOLDER}

curl -O -L http://mirrors.jenkins-ci.org/war/latest/jenkins.war
mkdir jenkins_${JENKINS_POSTFIX}
mv jenkins.war jenkins_${JENKINS_POSTFIX}
cd jenkins_${JENKINS_POSTFIX}
JENKINS_ROOT=`pwd`
mkdir jenkins_home

cat > jenkins_${JENKINS_POSTFIX}.ini << EOM
#!/bin/bash
### BEGIN INIT INFO
# Provides: jenkins_${JENKINS_POSTFIX}
# Required-Start: \$local_fs \$network \$named \$time \$syslog
# Required-Stop: \$local_fs \$network \$named \$time \$syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: jenkins_${JENKINS_POSTFIX}
### END INIT INFO
export JENKINS_HOME=${JENKINS_ROOT}/jenkins_home
SERVICE_NAME=jenkins_${JENKINS_POSTFIX}
PID_PATH_NAME=/tmp/jenkins_${JENKINS_POSTFIX}
PORT=${JENKINS_PORT}

CURRENT_DIR=\`pwd\`
cd ${JENKINS_ROOT}

case \$1 in
    start)
        echo "Starting \$SERVICE_NAME ..."
        if [ ! -f \$PID_PATH_NAME ]; then
            sudo -E -u ubuntu nohup java -jar jenkins.war --httpPort=\$PORT 2>> jenkins.err >> jenkins.log &
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
            sudo -E -u ubuntu nohup java -jar jenkins.war --httpPort=\$PORT 2>> jenkins.err >> jenkins.log &
            echo "\$SERVICE_NAME started ..."
        else
            echo "\$SERVICE_NAME is not running ..."
        fi
    ;;

esac

cd \$CURRENT_DIR
EOM

sudo mv jenkins_${JENKINS_POSTFIX}.ini /etc/init.d/jenkins_${JENKINS_POSTFIX}
sudo chmod +x /etc/init.d/jenkins_${JENKINS_POSTFIX}
sudo update-rc.d jenkins_${JENKINS_POSTFIX} defaults 82
sudo service jenkins_${JENKINS_POSTFIX} start

cat > jenkins_${JENKINS_POSTFIX}.conf << EOM
<VirtualHost *:80>
         ServerAdmin admin@milkneko.com
         ServerName ${JENKINS_DOMAIN}

         AllowEncodedSlashes NoDecode
         ProxyPass / http://localhost:${JENKINS_PORT}/ nocanon
         ProxyPassReverse / http://localhost:${JENKINS_PORT}/
 </VirtualHost>
EOM

sudo mv jenkins_${JENKINS_POSTFIX}.conf /etc/apache2/sites-available/
sudo a2ensite jenkins_${JENKINS_POSTFIX}
sudo service apache2 reload

