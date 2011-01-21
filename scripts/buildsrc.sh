#!/bin/bash

#echo "enter the openwrt codename"
#read owrtv
#OWRTPATH=openwrt
#IBPATH=../../../openwrt/$owrtv/bin/ar71xx/
echo "WARNING. THIS SCRIPT WILL IRREVOCABLY CHANGE YOUR SOURCE DIRECTORY!!"
sleep 1;

here=$(pwd) #svn/fabfi/trunk/scripts/

#
echo "enter path to the contents of your source directory (no trailing /)"
read IBPATH

#IBDIR='OpenWrt-ImageBuilder-ar71xx-for-Linux-i686'

cd ../
IBMake=$(pwd)/openwrt

cp -a ${IBMAKE}/* ${IBPATH}/

cd ${IBPATH}
make V=99
cd $here


