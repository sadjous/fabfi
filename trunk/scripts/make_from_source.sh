#!/bin/bash

echo "Enter the location of your OpenWrt directory"
read DIR

cp ../files/fabfi ${DIR}/target/linux/ar71xx/base-files/etc/ -R

cp ../openwrt/feeds.conf.default ${DIR}/

cp ../openwrt/config ${DIR}/.config

svn info > ${DIR}/target/linux/ar71xx/base-files/etc/fabfi/files/fabfi_info

cd $DIR

svn info > target/linux/ar71xx/base-files/etc/fabfi/files/openwrt_info

if [ ! -f target/linux/ar71xx/base-files/setup  ]; then
	ln -s /etc/fabfi/scripts/setup target/linux/ar71xx/base-files/setup
fi

make -j 8 V=99

