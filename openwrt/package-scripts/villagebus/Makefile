# villagebus: REST dispatch for mesh networks
#
# This software is licensed as free software under the terms of the
# New BSD License. See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

# - configuration ----------------------------------------------------------
PKG_NAME:=villagebus
PKG_REV:=1025
PKG_VERSION:=1.0-r$(PKG_REV)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://fabfi.googlecode.com/svn/trunk/src/villagebus/

# - sources ----------------------------------------------------------------
PKG_SOURCE_PROTO:=svn
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_SUBDIR:=$(if $(PKG_BRANCH),$(PKG_BRANCH),$(PKG_NAME))-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)


include $(INCLUDE_DIR)/package.mk

# - villagebus -------------------------------------------------------------
define Package/villagebus-core
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+luci-lib-lucid-http +luci-lib-px5g +lualogging +luajson +luasocket
	TITLE:=REST dispatch for mesh networks
	VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
	URL:=http://fabfi.org
endef

define Package/villagebus-core/description
	Core villagebus distribution
endef

define Package/villagebus-core/install
	$(INSTALL_DIR)  $(1)/usr/lib/lua/villagebus
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/urlcode.lua     $(1)/usr/lib/lua/villagebus
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/dispatcher.lua  $(1)/usr/lib/lua/villagebus

	$(INSTALL_DIR)  $(1)/usr/lib/lua/villagebus/modules
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/modules/http.lua  $(1)/usr/lib/lua/villagebus/modules

	$(INSTALL_DIR)  $(1)/usr/lib/lua/luci/lucid/http
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/lucid/VillagebusPublisher.lua  $(1)/usr/lib/lua/luci/lucid/http

	$(INSTALL_DIR)  $(1)/usr/lib/lua/luci/lucid/http/handler
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/lucid/handler/villagebus.lua  $(1)/usr/lib/lua/luci/lucid/http/handler
endef


# - compilation ------------------------------------------------------------
define Build/Compile
	# TODO luac
endef

# - eval packages ----------------------------------------------------------
$(eval $(call BuildPackage,villagebus-core))
