#!/bin/bash

echo "Enter the location of your snmp directory"
read DIR

cp ../files/fabfi ${DIR}/target/linux/ar71xx/base-files/etc/

cp ../openwrt/feeds.conf.default ${DIR}/

svn info > ${DIR}/target/linux/ar71xx/base-files/etc/fabfi/files/fabfi_info


cd $DIR

svn info > target/linux/ar71xx/base-files/etc/fabfi/files/openwrt_info

if [ ! -f target/linux/ar71xx/base-files/setup  ]; then
	ln -s /etc/fabfi/scripts/setup target/linux/ar71xx/base-files/setup
fi


make defconfig

make V=99

