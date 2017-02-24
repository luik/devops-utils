#!/bin/bash

ANT_VERSION=1.10.1

cd /tmp
curl -O -L "http://www-eu.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz"
tar xzf apache-ant-${ANT_VERSION}-bin.tar.gz
sudo mv "/tmp/apache-ant-${ANT_VERSION}" "/usr/"

sudo update-alternatives --install /usr/bin/ant ant /usr/apache-ant-${ANT_VERSION}/bin/ant 1

