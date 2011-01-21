#!/bin/bash

#echo "enter the openwrt codename"
#read owrtv
#OWRTPATH=openwrt
#IBPATH=../../../openwrt/$owrtv/bin/ar71xx/
echo "pick a profile (and you'd better spell it right or this thing blows up)"
read profile

here=$(pwd) #svn/fabfi/trunk/scripts/

#
echo "enter path to the image builder (no trailing /)"
read IBPATH

#IBDIR='OpenWrt-ImageBuilder-ar71xx-for-Linux-i686'

cd ../
IBMake=$(pwd)/imagebuilder/target/linux/ar71xx/image/${profile}/Makefile

rm -f ${IBPATH}/target/linux/ar71xx/profiles/${profile}.mk
rm -f ${IBPATH}/target/linux/ar71xx/image/Makefile
rm -rf ${IBPATH}/fabfi


ln -s $(pwd)/imagebuilder/target/linux/ar71xx/profiles/${profile}.mk ${IBPATH}/target/linux/ar71xx/profiles/${profile}.mk
ln -s $IBMake ${IBPATH}/target/linux/ar71xx/image/Makefile


cp -a $(pwd)/files/router_configs/${profile} ${IBPATH}/fabfi/
#cp -a $(pwd)/files/router_configs/common/* ${IBPATH}/fabfi/${profile}
cp -a $(pwd)/files/router_configs/common/* ${IBPATH}/fabfi/

cd ${IBPATH}
make image PROFILE=${profile}
cd $here

rm -f ${IBPATH}/target/linux/ar71xx/profiles/${profile}.mk
rm -f ${IBPATH}/target/linux/ar71xx/image/Makefile
rm -rf ${IBPATH}/fabfi

