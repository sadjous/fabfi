# SchoolNet LiveCD Distribution
#
# Copyright (C) 2011 SchoolNet
# All rights reserved.
# 
# This software is licensed as free software under the terms of the
# New BSD License. See /LICENSE for more information. 


# - package spec -----------------------------------------------------------
%packages
openssl
openssl-devel
%end


# - post-install script ----------------------------------------------------
%post

# node.js
mkdir /usr/local/src
cd /usr/local/src
wget http://nodejs.org/dist/node-v0.4.11.tar.gz
tar xzvf node-v0.4.11.tar.gz
cd node-v0.4.11
./configure && make && make install

# npm
curl http://npmjs.org/install.sh | sh


touch /schoolnet.etherpad-lite
%end
