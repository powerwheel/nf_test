include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
PKG_NAME:=nf_test
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/nf_test
    TITLE:=nf_test
    SUBMENU:=Other modules
    AUTOLOAD:=$(call AutoLoad,99,nf_test)
    FILES:=$(PKG_BUILD_DIR)/nf_test.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/nf_test/description
    kernel netfilter test
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) -r src/. $(PKG_BUILD_DIR)
endef


MAKEOPTS:= -C $(LINUX_DIR) \
                ARCH="$(LINUX_KARCH)" \
                CROSS_COMPILE="$(TARGET_CROSS)" \
                SUBDIRS="$(PKG_BUILD_DIR)" \
                EXTRA_CFLAGS="-g $(BUILDFLAGS)" \
		        modules

define Build/Compile
    $(MAKE) $(MAKEOPTS)
endef

define KernelPackage/nf_test/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/nf_test.init $(1)/etc/init.d/nf_test
endef

$(eval $(call KernelPackage,nf_test))
