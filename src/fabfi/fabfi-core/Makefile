
include $(TOPDIR)/rules.mk

# - configuration ----------------------------------------------------------
PKG_NAME:=fabfi-core
PKG_VERSION:=0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

# - portalgun -------------------------------------------------------------
define Package/fabfi-core
	SECTION:=base
	CATEGORY:=Fabfi
	TITLE:= fabfi mesh network configuration scripts
	VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
	URL:=http://fabfi.org
endef

define Package/fabfi-core/description
	A collection of helper scripts and files necessary for setting up fabfi wireless mesh network
endef

define Build/Compile
	# to be done 
endef

define Package/fabfi-core/install
	$(INSTALL_DIR) $(1)/usr/bin/fabfi/
	$(INSTALL_DIR) $(1)/usr/share/fabfi/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DATA) ./files/* $(1)/usr/share/fabfi/
	$(INSTALL_BIN) ./scripts/* $(1)/usr/bin/fabfi/
	$(LN) /usr/bin/fabfi/run_once $(1)/etc/init.d/run_once
	$(LN) /usr/bin/fabfi/siit-init $(1)/etc/init.d/siit
	$(LN) /usr/bin/fabfi/siit-hotplug $(1)/etc/hotplug.d/iface/30-siit
	$(LN) /usr/bin/fabfi/setup.sh $(1)/setup
endef

define Package/portalgun/postinst
#!/bin/sh
# check if we are on the real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	uci commit	
fi
endef


# - eval packages ----------------------------------------------------------
$(eval $(call BuildPackage,fabfi-core))

