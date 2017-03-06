#!/usr/bin/env bash

SERVER_IP=$1

if [ "$#" -ne 1 ]; then
    read -p "IP: " SERVER_IP
fi

ssh -o StrictHostKeyChecking=no -i ~/.ssh/spot_pk ubuntu@${SERVER_IP} /bin/bash << EOM
    sudo apt update
    sudo apt -y install git
    git clone https://github.com/luik/devops-utils
    cd devops-utils/linux-scripts
    chmod +x *
    ./create-nvme-fs.sh
    ./install-apache.sh
    ./install-php5.sh
    ./install-mysql-server.sh
EOM
