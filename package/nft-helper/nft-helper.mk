################################################################################
#
# nft-helper
#
################################################################################

NFT_HELPER_VERSION = 1.0
NFT_HELPER_SITE_METHOD = local
NFT_HELPER_SITE = $(BR2_EXTERNAL_CURIOS_PATH)/src/nft-helper
NFT_HELPER_LICENSE = ISC
NFT_HELPER_LICENSE_FILES = LICENSE

define NFT_HELPER_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define NFT_HELPER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/nft-helper $(TARGET_DIR)/usr/sbin/
endef

$(eval $(generic-package))
