################################################################################
#
# mping
#
################################################################################

MPING_VERSION = 2.0
MPING_SITE = https://github.com/troglobit/mping/releases/download/v$(MPING_VERSION)
MPING_LICENSE = MIT
MPING_LICENSE_FILES = LICENSE

define MPING_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) all
endef

define MPING_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mping $(TARGET_DIR)/usr/bin/mping
endef

$(eval $(generic-package))
