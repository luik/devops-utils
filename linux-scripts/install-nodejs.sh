#!/usr/bin/env bash

NODEJS_VERSION=16

curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
sudo apt-get install -y nodejs
