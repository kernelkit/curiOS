include $(sort $(wildcard $(BR2_EXTERNAL_CURIOS_PATH)/package/*/*.mk))

.PHONY: upload
upload: all
	(cd $O/images; skopeo copy oci:rootfs-oci:edge docker://ghcr.io/kernelkit/curios:edge)
