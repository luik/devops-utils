#!/usr/bin/env bash

sudo apt -y install apache2
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo service apache2 restart
