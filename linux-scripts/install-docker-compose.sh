#!/usr/bin/env bash

#Ref https://github.com/docker/compose/releases

sudo curl -L https://github.com/docker/compose/releases/download/2.10.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

