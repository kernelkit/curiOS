include $(sort $(wildcard $(BR2_EXTERNAL_CURIOS_PATH)/package/*/*.mk))

export CURIOS_BUILD_ID ?= $(shell git -C $(BR2_EXTERNAL_CURIOS_PATH) describe --dirty --always --tags)
export CURIOS_VERSION   = $(if $(RELEASE),$(RELEASE),$(CURIOS_BUILD_ID))

.PHONY: upload
upload: all
	(cd $O/images; skopeo copy oci:rootfs-oci:edge docker://ghcr.io/kernelkit/curios:edge)
