#!/bin/bash

#echo "enter the openwrt codename"
#read owrtv
#OWRTPATH=openwrt
#IBPATH=../../../openwrt/$owrtv/bin/ar71xx/
echo "pick a profile (and you'd better spell it right or this thing blows up)"
read profile

here=$(pwd) #svn/fabfi/trunk/imagebuilder/

#
echo "enter path to the image builder (no trailing /)"
read IBPATH

IBDIR='OpenWrt-ImageBuilder-ar71xx-for-Linux-i686'

IBMake=${here}/target/linux/ar71xx/image/${profile}/Makefile


rm -f ${IBPATH}/${IBDIR}/target/linux/ar71xx/profiles/${profile}.mk
rm -f ${IBPATH}/${IBDIR}/target/linux/ar71xx/image/Makefile
rm -rf ${IBPATH}/${IBDIR}/fabfi

ln -s ${here}/target/linux/ar71xx/profiles/${profile}.mk ${IBPATH}/${IBDIR}/target/linux/ar71xx/profiles/${profile}.mk
ln -s $IBMake ${IBPATH}/${IBDIR}/target/linux/ar71xx/image/Makefile
cd ../

cp -a $(pwd)/files/router_configs/${profile} ${IBPATH}/${IBDIR}/fabfi/
#cp -a $(pwd)/files/router_configs/common/* ${IBPATH}/${IBDIR}/fabfi/${profile}
cp -a $(pwd)/files/router_configs/common/* ${IBPATH}/${IBDIR}/fabfi/

cd ${IBPATH}/${IBDIR}
make image PROFILE=${profile}
cd $here

rm -f ${IBPATH}/${IBDIR}/target/linux/ar71xx/profiles/${profile}.mk
rm -f ${IBPATH}/${IBDIR}/target/linux/ar71xx/image/Makefile
rm -rf ${IBPATH}/${IBDIR}/fabfi

