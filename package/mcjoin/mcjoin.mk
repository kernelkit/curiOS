################################################################################
#
# mcjoin
#
################################################################################

MCJOIN_VERSION = 2.11
MCJOIN_SITE = https://github.com/troglobit/mcjoin/releases/download/v$(MCJOIN_VERSION)
MCJOIN_LICENSE = ISC
MCJOIN_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
