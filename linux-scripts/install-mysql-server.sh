#!/usr/bin/env bash

MYSQL_PASSWORD=`openssl rand -base64 12`

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_PASSWORD}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_PASSWORD}"
sudo apt -y install mysql-server

sudo service mysql stop

cd /media/nvme1/data
sudo mv /var/lib/mysql .
sudo chown mysql:mysql mysql

if [ -f /etc/mysql/mysql.conf.d/mysqld.cnf ]; then
    sudo sed -i "s/\/var\/lib\/mysql/\/media\/nvme1\/data\/mysql/" /etc/mysql/mysql.conf.d/mysqld.cnf
fi
if [ -f /etc/mysql/my.cnf ]; then
    sudo sed -i "s/\/var\/lib\/mysql/\/media\/nvme1\/data\/mysql/" /etc/mysql/my.cnf
fi
sudo sed -i "s/\/var\/lib\/mysql\//\/media\/nvme1\/data\/mysql\//" /etc/apparmor.d/usr.sbin.mysqld

#fix for init script error on ubuntu server 16.04
sudo mkdir -p /var/lib/mysql/mysql
sudo chown mysql:mysql /var/lib/mysql/mysql
#end fix

sudo service apparmor restart
sudo service mysql start

echo ${MYSQL_PASSWORD}
echo ${MYSQL_PASSWORD} >> /media/nvme1/data/mysql-pass
