# SchoolNet LiveCD Distribution
#
# Copyright (C) 2011 SchoolNet
# All rights reserved.
# 
# This software is licensed as free software under the terms of the
# New BSD License. See /LICENSE for more information. 


# - package spec -----------------------------------------------------------
%packages
squid
calamaris
%end


# - pre-install script ----------------------------------------------------
%pre
touch /schoolnet.squid.pre
%end


# - post-install script ----------------------------------------------------
%post
touch /schoolnet.squid
# TODO copy squid.conf over
%end
