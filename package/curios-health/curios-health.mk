################################################################################
#
# curios-health
#
################################################################################

CURIOS_HEALTH_VERSION = 1.0
CURIOS_HEALTH_SITE_METHOD = local
CURIOS_HEALTH_SITE = $(BR2_EXTERNAL_CURIOS_PATH)/src/health
CURIOS_HEALTH_LICENSE = ISC
CURIOS_HEALTH_LICENSE_FILES = LICENSE

define CURIOS_HEALTH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define CURIOS_HEALTH_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
