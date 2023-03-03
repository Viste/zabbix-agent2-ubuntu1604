#!/bin/bash

set -ex

#############################################################
# set vars

BUILD_DIR="/build"
RESULT_DIR="/artifacts"
PNAME="zabbix-agent2"
ARTIFACT_NAME="${PNAME}"
VERSION="5.4.12"
VERSION_MJ="5.4"

mkdir ${BUILD_DIR}

#############################################################
# get go

cd $BUILD_DIR
wget -q https://dl.google.com/go/go1.19.6.linux-amd64.tar.gz
tar -xf go1.19.6.linux-amd64.tar.gz
mv go /usr/local/
rm go1.19.6.linux-amd64.tar.gz

#############################################################
# setup env vars
export PATH=/usr/local/go/bin:$PATH
export GOPATH=${BUILD_DIR}
export USER=root

go version
cd $BUILD_DIR

#############################################################
# get sources
wget -q https://cdn.zabbix.com/zabbix/sources/oldstable/${VERSION_MJ}/zabbix-${VERSION}.tar.gz
tar xf zabbix-${VERSION}.tar.gz
cd zabbix-${VERSION}

#############################################################
# setup package build shit
dh_make --packagename ${PNAME}  --single -c gpl3 -e vistee@protonmail.com --createorig -y

cp /rules $BUILD_DIR/zabbix-${VERSION}/debian/rules
cp /control $BUILD_DIR/zabbix-${VERSION}/debian/control
cp /${PNAME}.dirs $BUILD_DIR/zabbix-${VERSION}/debian/${PNAME}.dirs
cp /${PNAME}.logrotate $BUILD_DIR/zabbix-${VERSION}/debian/${PNAME}.logrotate
cp /${PNAME}.postinst $BUILD_DIR/zabbix-${VERSION}/debian/${PNAME}.postinst
cp /${PNAME}.postrm $BUILD_DIR/zabbix-${VERSION}/debian/${PNAME}.postrm
cp /${PNAME}.preinst $BUILD_DIR/zabbix-${VERSION}/debian/${PNAME}.preinst
cp /${PNAME}.prerm $BUILD_DIR/zabbix-${VERSION}/debian/${PNAME}.prerm
cp /${PNAME}.service $BUILD_DIR/zabbix-${VERSION}/debian/${PNAME}.service
cp /${PNAME}.service /lib/systemd/system/${PNAME}.service
#######

#############################################################
# build package

dpkg-buildpackage -b -i -nc -rfakeroot

#############################################################
# create artifact
ARTIFACT_DIR=$RESULT_DIR/$ARTIFACT_NAME
mkdir -p $ARTIFACT_DIR/package
mkdir -p $ARTIFACT_DIR/package_src

cd /
cp -vR $BUILD_DIR/${PNAME}_${VERSION}-1_all.deb $ARTIFACT_DIR/package
cp -vR $BUILD_DIR/${PNAME}_${VERSION}.orig.tar.xz $ARTIFACT_DIR/package_src

cd $RESULT_DIR
tar -vczf ${ARTIFACT_NAME}-linux64.tar.gz -C $RESULT_DIR ${ARTIFACT_NAME} --remove-files
