#!/usr/bin/env bash

# https://hub.docker.com/r/rayyildiz/java8/~/dockerfile/

JAVA_VERSION=8
JAVA_UPDATE=131
JAVA_BUILD=11
JAVA_TOKEN=d54c1d3a095b4ff2b6607d096fa80163

cd /tmp
curl -O -L -H "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_TOKEN}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz"
tar xzf "jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz"
sudo mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "/usr/"

sudo update-alternatives  --install /usr/bin/java java /usr/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}/bin/java 1
sudo update-alternatives  --install /usr/bin/javac javac /usr/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}/bin/javac 1

export JAVA_HOME=/usr/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}/
export JRE_HOME=/usr/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}/jre/
