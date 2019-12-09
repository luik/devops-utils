#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get -y install certbot python-certbot-apache

