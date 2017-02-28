#!/bin/bash

MAVEN_VERSION=3.3.9

cd /tmp
curl -O -L "http://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz
sudo mv "/tmp/apache-maven-${MAVEN_VERSION}" "/usr/"

sudo update-alternatives --install /usr/bin/mvn mvn /usr/apache-maven-${MAVEN_VERSION}/bin/mvn 1
