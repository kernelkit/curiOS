export BR2_EXTERNAL := $(CURDIR)
export PATH         := $(CURDIR)/bin:$(PATH)

ARCH ?= $(shell uname -m)
O    ?= $(CURDIR)/output

config := $(O)/.config
bmake   = $(MAKE) -C buildroot O=$(O) $1

# Read a symbol out of the generated .config, stripping the quotes
brvar   = $(shell sed -n 's/^$1="\(.*\)"/\1/p' $(config) 2>/dev/null)

VERSION ?= $(shell git -C $(CURDIR) describe --dirty --always --tags 2>/dev/null)


all: $(config) buildroot/Makefile
	@+$(call bmake,$@)

$(config):
	@+$(call bmake,list-defconfigs)
	@echo "\e[7mERROR: No configuration selected.\e[0m"
	@echo "Please choose a configuration from the list above by running"
	@echo "'make <board>_defconfig' before building an image."
	@exit 1


# Software Bill of Materials, in both formats the CRA technical
# documentation is likely to be asked for.  Requires every source
# tarball, so it downloads what the build has not already fetched.
sbom: $(config) buildroot/Makefile
	@+$(call bmake,legal-info)
	@$(CURDIR)/utils/mksbom							\
		--manifest $(O)/legal-info/manifest.csv				\
		--image    "$(call brvar,BR2_TARGET_ROOTFS_OCI_TAG)"		\
		--version  "$(VERSION)"						\
		--arch     "$(call brvar,BR2_NORMALIZED_ARCH)"			\
		--outdir   $(O)/images/sbom
	@cp $(O)/legal-info/manifest.csv						\
		$(O)/images/sbom/$(call brvar,BR2_TARGET_ROOTFS_OCI_TAG)-$(call brvar,BR2_NORMALIZED_ARCH).manifest.csv
	@echo "  License manifest : $(O)/images/sbom/$(call brvar,BR2_TARGET_ROOTFS_OCI_TAG)-$(call brvar,BR2_NORMALIZED_ARCH).manifest.csv"
	@echo "  Complete source  : $(O)/legal-info/sources/"

# CVE status for the versions this configuration builds, limited to what
# actually ships.  The first run clones the NVD feed, which takes a while.
cve: $(config) buildroot/Makefile
	@+$(call bmake,pkg-stats)
	@+$(call bmake,show-info) | sed -n '/^{/p' >$(O)/show-info.json
	@$(CURDIR)/utils/cve-summary $(O)/pkg-stats.json			\
		--packages $(O)/show-info.json					\
		--image    "$(call brvar,BR2_TARGET_ROOTFS_OCI_TAG)"		\
		--version  "$(VERSION)"

# Run the container tests against whatever is in $(O)/images/
test:
	@$(CURDIR)/test/run.sh

# Scaffold a new container:  make new-container NAME=foo ARGS="--package"
new-container:
	@$(CURDIR)/utils/new-container $(NAME) $(ARGS)

%: | buildroot/Makefile
	@+$(call bmake,$@)

buildroot/Makefile:
	@git submodule update --init

.PHONY: all sbom cve test new-container
