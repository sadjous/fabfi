# portalgun: Mesh network access controller
#
# This software is licensed as free software under the terms of the
# New BSD License. See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

# - configuration ----------------------------------------------------------
PKG_NAME:=fabfi-utils
PKG_REV:=1094
PKG_VERSION:=1.0-r$(PKG_REV)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://fabfi.googlecode.com/svn/trunk/src/fabfi/fabfi-utils/

# - sources ----------------------------------------------------------------
PKG_SOURCE_PROTO:=svn
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_SUBDIR:=$(if $(PKG_BRANCH),$(PKG_BRANCH),$(PKG_NAME))-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)


include $(INCLUDE_DIR)/package.mk

# - portalgun -------------------------------------------------------------
define Package/fabfi-utils
	SECTION:=base
	CATEGORY:=Fabfi
	TITLE:= fabfi configuration scripts
	VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
	URL:=http://fabfi.org
endef

define Package/fabfi-utils/description
	A collection of scripts for setting up fabfi wireless mesh network
endef

define Build/Compile
	# TODO luac
endef

define Package/fabfi-utils/install
	$(INSTALL_DIR) $(1)/etc/fabfi/
	$(INSTALL_DATA) ./files/* $(1)/etc/fabfi/files/*
	$(INSTALL_DATA) ./scripts/* $(1)/etc/fabfi/scripts/*
	$(LN) setup $(1)/etc/fabfi/scripts/setup.sh
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_DATA) ./run_once $(1)/etc/init.d/run_once
endef

define Package/portalgun/postinst
#!/bin/sh
# check if we are on the real system
if [ -z "$${IPKG_INSTROOT}" ]; then
	uci commit
fi
endef


# - eval packages ----------------------------------------------------------
$(eval $(call BuildPackage,fabfi-utils))

