#!/bin/sh
# Post-image script to create OCI tarball similar to release artifacts
# This makes local builds easier to distribute and test
# shellcheck disable=1090
set -e

get_br_var()
{
    val="$(sed -n "s/^$1=//p" "$BR2_CONFIG")"
    val="${val#\"}"
    printf '%s\n' "${val%\"}"
}

OCI_DIR="${BINARIES_DIR}/rootfs-oci"
if [ ! -d "${OCI_DIR}" ]; then
    echo "ERROR: ${OCI_DIR} not found!"
    exit 1
fi

# Determine container name and docker architecture from defconfig
NAME="$(get_br_var BR2_TARGET_ROOTFS_OCI_TAG)"
ARCH="$(get_br_var BR2_NORMALIZED_ARCH)"
FILE="${NAME}-oci-${ARCH}.tar.gz"

echo "Creating OCI tarball"
echo "  Container    : ${NAME}"
echo "  Architecture : ${ARCH}"

# Create tarball with OCI contents at root (no directory wrapper)
cd "${OCI_DIR}"
tar czf "${BINARIES_DIR}/${FILE}" .

cd "${BINARIES_DIR}"
echo "✓ Created      : ${FILE}"
echo
echo "To load this OCI image into your container store:"
echo
echo "$ docker load < ${FILE}"
echo "  Getting image source signatures"
echo "  Copying blob 03d195b2e729 done   | "
echo "  Copying config e98a88ec09 done   | "
echo "  Writing manifest to image destination"
echo "  Loaded image: localhost/${NAME}:latest"
echo
