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
%include include/wordpress.ks
%include include/canvas-lsm.ks
%include include/reddit.ks


# - configuration ----------------------------------------------------------
part / --size 1024


# - package spec -----------------------------------------------------------
%packages
-@sound-and-video
-@office
-gnome-speech
-festival
-festival-lib
-cdrdao
-gnome-video-effects
-gnome-games
-transmission-common
-transmission-gtk
-cheese
-cheese-libs
-totem
-evolution-data-server
-evolution-NetworkManager
-evolution
-brasero-nautilus
-brasero-libs
-brasero
%end


# - post-install script ----------------------------------------------------
%post
touch /schoolnet
%end
