# SchoolNet LiveCD Distribution
#
# Copyright (C) 2011 SchoolNet
# All rights reserved.
# 
# This software is licensed as free software under the terms of the
# New BSD License. See /LICENSE for more information. 


# - includes ---------------------------------------------------------------
%include include/base.ks
%include include/minimization.ks

# - subsystems -------------------------------------------------------------
%include package-scripts/squid/squid.ks
%include package-scripts/wordpress/wordpress.ks
%include package-scripts/canvas-lms/canvas-lms.ks
%include package-scripts/reddit/reddit.ks


# - configuration ----------------------------------------------------------
part / --size 4096


# - package spec -----------------------------------------------------------
%packages
%end


# - post-install script ----------------------------------------------------
%post
touch /schoolnet
%end
