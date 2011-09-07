#!/bin/bash

here=$(pwd)

echo "Make sure "

echo "Enter the location of your OpenWrt directory"
read DIR

if [ -d ${DIR}/target/linux/ar71xx/base-files/etc/ ]; then

	cp ../files/fabfi ${DIR}/target/linux/ar71xx/base-files/etc/ -R

	cp ../openwrt/config ${DIR}/.config
	
	svn info > ${DIR}/target/linux/ar71xx/base-files/etc/fabfi/files/fabfi_info

	cd $DIR

	svn info > target/linux/ar71xx/base-files/etc/fabfi/files/openwrt_info

	if [ ! -h target/linux/ar71xx/base-files/setup  ]; then
		ln -s /etc/fabfi/scripts/setup target/linux/ar71xx/base-files/setup
	fi

	make -j 8 V=99
	
	if [ ! -d ${DIR}/latest-images/ ]; then mkdir ${DIR}/latest-images ; fi

	echo "RS, RSPRO and NanoStation images have been placed in ${DIR}/latest-images
	echo "Entering ${DIR}/latest-images
	cd $
else

	echo "Something is wrong with your openwrt directory - check then run the script again"

fi
