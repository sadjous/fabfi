# portalgun: Mesh network access controller
#
# This software is licensed as free software under the terms of the
# New BSD License. See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

# - configuration ----------------------------------------------------------
PKG_NAME:=portalgun
PKG_REV:=1025
PKG_VERSION:=1.0-r$(PKG_REV)
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://fabfi.googlecode.com/svn/trunk/src/portalgun/

# - sources ----------------------------------------------------------------
PKG_SOURCE_PROTO:=svn
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_SUBDIR:=$(if $(PKG_BRANCH),$(PKG_BRANCH),$(PKG_NAME))-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)


include $(INCLUDE_DIR)/package.mk

# - portalgun -------------------------------------------------------------
define Package/portalgun
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Captive Portals
	DEPENDS:=+villagebus-core
	TITLE:=Mesh network access controller
	VERSION:=$(PKG_VERSION)-$(PKG_RELEASE)
	URL:=http://fabfi.org
endef

define Package/portalgun/description
	Mesh network access controller
endef

define Package/portalgun/install
	$(INSTALL_DIR)  $(1)/usr/lib/lua/villagebus/modules
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/villagebus/modules/portalgun.lua  $(1)/usr/lib/lua/villagebus/modules
endef


# - compilation ------------------------------------------------------------
define Build/Compile
	# TODO luac
endef

# - eval packages ----------------------------------------------------------
$(eval $(call BuildPackage,portalgun))

