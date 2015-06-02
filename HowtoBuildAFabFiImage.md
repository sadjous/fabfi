

# Introduction #

Instead of using the images we provide on the site, you can build your own images either from source or from our customized OpenWRT imagebuilder. This page outlines both methods.

## Workflow ##

When we build images, we follow these steps:

  1. Checkout the scripts, imagebuilder and openwrt folders from the fabfi svn
  1. download latest openwrt source
  1. navigate to the trunk/scripts directory in the fabfi source tree
  1. run buildsrc.sh to build the OpenWRT imagebuilder from the latest OpenWRT source.
  1. Extract the imagebuilder to your hard drive
  1. Run the trunk/scripts/ffimage.sh script to build a custom image.

## Step-by-Step ##

### Building Source ###

If you have not done so before, now is the time to [set up your build enviroment](http://wiki.openwrt.org/doc/howto/build) (you can stop at "Downloading Feeds")

```
$  cd {your svn dir}/fabfi/
$  svn checkout https://fabfi.googlecode.com/svn/trunk --username yourgoogleusername
```

Download the OpenWRT source to a directory of your choice
```
$ cd {your backfire source dir}
$ svn co svn://svn.openwrt.org/openwrt/branches/backfire
```

Navigate to the scripts directory and run the src builder:
```
$ cd {fabfi svn}/trunk/scripts/
$ sudo sh buildsrc.sh
```

the above command will probably take an hour or so the first time you run it.  When it finishes, you will find a brand new [imagebuilder](http://wiki.openwrt.org/doc/howto/imagebuilder) in the bin directory for your platform.  My imagebuilder comes out here:
```
{your backfire source dir}/bin/ar71xx/OpenWrt-ImageBuilder-ar71xx-for-Linux-i686.tar.bz2
```

Open this archive and extract the contained folder to your hard drive.  You will use it to complete the rest of the build process

### Building from Imagbuilder ###

**NOTE: as of this version, you can no longer simply download the stock OpenWRT imagebuilder from OpenWRT and proceed.  You must instead use our custom imagebuilder or download and build awesome-chilli from [afrimesh](http://afrimesh.googlecode.com/svn/branches/unstable/package-scripts/openwrt/) then update the package list (I have no idea how to do the latter part).**

If you're not building from source or hacking stock OpenWRT, [get our custom imagebuilder here](http://portal.joinafrica.org/dev/fabfi-OpenWrt-ImageBuilder-ar71xx-for-Linux-i686.tar.bz2).

Extract the imagebuilder to your directory of choice.

Then, from the scripts directory from above, run:
```
$ sh ffimage.sh
```

You will be asked to enter the profile name and the path to the imagebuilder.  The currently available profiles are
  * WRT160NL
  * UBNTNANOM (works for ubiquiti nanom and picoM devices)

Note: "path to the imagebuilder" is the path to the contents of the imagebuilder folder you extracted above.

If this process completes with no errors (and it should), you will find you image in:
```
{path to imagebuilder}/bin/ar71xx/
```

The ones you care about are the .bin files ending in "factory" and "sysupgrade" with the device name of the device you built fw for.