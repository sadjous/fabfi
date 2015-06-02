

# Introduction #

Instead of using the images we provide on the site, you can build your own images either from source or from our customized OpenWRT imagebuilder. This page outlines both methods.

# Workflow Overview #

When we build images, we follow these steps:

  1. Checkout the svn trunk of the fabfi source (or a branch if you're not building latest)
  1. download latest openwrt source trunk
  1. run one of the fabfi build scripts from {fabfisrc}/trunk/scripts/ to create a fabfi image (there are a few methods explained below)

# Step-by-Step #

## Method 1: Automated from-scratch build ##

This script may be buggy / troubleshooting may be difficult, but if it works it's the simplest method.

  1. Prepare your computer - http://wiki.openwrt.org/doc/howto/buildroot.exigence
  1. Checkout latest fabfi trunk
```
	svn checkout https://fabfi.googlecode.com/svn/trunk/ fabfi 
```
  1. Navigate to scripte directory and run the build\_source script.  (This script checks out the latest openwrt trunk source or updates your existing source. Make sure your local copy of the fabfi repository is up to date before running this script. ( svn up ))
```
cd fabfi/scripts
bash build_source
(The script will ask you for your openwrt source directory.  
It uses trunk.  so you'll want to give it the path that ends in /trunk.)
```
You'll see menuconfig window popping up.  Exit without saving and script will continue
  1. You will then probably need to also run
```
bash make_from_source.sh
```
to get all the packages to build.  If you get an error that looks like this:
```
WARNING: your configuration is out of sync. 
Please run make menuconfig, oldconfig or defconfig!
```
then run
```
make menuconfig
```
from the openwrt source directory, immediately exit and save config, then run make\_from\_source.sh again

**After the first build, you can rebuild images with changes to fabfi files simply by running make\_from\_source.sh**

You can find your new images in
```
<openwrt source dir>/latest-images/
```

## Method 2: Manual Source Build ##

  1. Prepare your computer - http://wiki.openwrt.org/doc/howto/buildroot.exigence
  1. Checkout latest fabfi trunk
```
	svn checkout https://fabfi.googlecode.com/svn/trunk/ fabfi 
```
  1. Choose a home for your OpenWRT source and download it.  We choose openwrt.trunk below
```
svn checkout svn://svn.openwrt.org/openwrt/trunk/ openwrt.trunk
```
  1. Copy feeds.conf.default from fabfi trunk to openwrt trunk
```
cd openwrt.trunk
cp fabfi/openwrt/feeds.conf.default openwrt.trunk/feeds.conf.default
```
  1. Copy config from fabfi trunk to openwrt.trunk ( observe that in fabfi trunk, the filename is config; in openwrt.trunk, the filename is .config )
```
	cp fabfi/openwrt/config openwrt.trunk/.config
```
  1. Copy fabfi files from fabfi trunk to openwrt.trunk
```
cp -a fabfi/files/fabfi openwrt.trunk/target/linux/ar71xx/base-files/etc/
```
  1. Enter openwrt.trunk, update sources and install.  Then compile.
```
cd openwrt.trunk
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make V=99
```
To compile faster, you might want to run several parallel make processes
```
make -j 4 V=99 #for 4 concurrent processes
```