# Desktop with customizationst to fit in a CD sized image (package removals, etc.)
# Maintained by the Fedora Desktop SIG:
# http://fedoraproject.org/wiki/SIGs/Desktop
# mailto:desktop@lists.fedoraproject.org

%include include/base.ks
%include include/minimization.ks
%include include/wordpress.ks
%include include/canvas-lsm.ks
%include include/reddit.ks

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

%post
touch /schoolnetwuzhere
%end
