#!/bin/sh
tagline="curiOS -- a slim curated container OS"

for start in S02sysctl S20seedrng S51sysrepo-plugind S52netopeer2; do
    rm -f "${TARGET_DIR}/etc/init.d/$start"
done

# We allow S40network but the user must provide the configuration
# because by default container runtimes manage all networking.
rm -f "${TARGET_DIR}/etc/network/interfaces"

# Buildroot copies the external toolchain's runtime libraries into the
# image whenever it is linked dynamically.  For a C daemon that means
# carrying a 2.4 MB libstdc++ and an OpenMP runtime nothing references
# -- more than doubling curios-ntpd.  Drop the ones no ELF asks for.
for lib in libstdc++ libgomp libatomic; do
    if grep -rlq "$lib" "${TARGET_DIR}/bin" "${TARGET_DIR}/sbin"		\
	    "${TARGET_DIR}/usr/bin" "${TARGET_DIR}/usr/sbin"		\
	    "${TARGET_DIR}/usr/libexec" 2>/dev/null; then
	continue
    fi
    # Nothing in a library either, beyond the library itself.
    if find "${TARGET_DIR}/lib" "${TARGET_DIR}/usr/lib" -name '*.so*' 2>/dev/null \
	    | grep -v "$lib" | xargs -r grep -lq "$lib" 2>/dev/null; then
	continue
    fi
    find "${TARGET_DIR}/lib" "${TARGET_DIR}/usr/lib" -name "$lib*" \
	 -delete 2>/dev/null || true
done

VERSION="${CURIOS_VERSION}"
GIT_VERSION="${CURIOS_BUILD_ID}"

# Overwrite Buildroot's /usr/lib/os-release with curiOS content.
# /etc/os-release is a symlink -> ../usr/lib/os-release, so it keeps
# resolving correctly even when /etc is volume-mounted and the image
# is upgraded underneath it.
cat <<-EOF >"${TARGET_DIR}/usr/lib/os-release"
	NAME="curiOS"
	ID=curios
	PRETTY_NAME="$tagline $VERSION"
	ID_LIKE="buildroot"
	VERSION="${VERSION}"
	VERSION_ID="${VERSION}"
	BUILD_ID="${GIT_VERSION}"
	HOME_URL="https://github.com/kernelkit/curios"
	VENDOR_NAME="KernelKit"
	VENDOR_HOME="https://github.com/kernelkit"
	SUPPORT_URL="mailto:kernelkit@googlegroups.com"
EOF
ln -sf ../usr/lib/os-release "${TARGET_DIR}/etc/os-release"

echo "$tagline $VERSION — $(date +"%b %e %H:%M %Z %Y")" > "$TARGET_DIR/usr/lib/version"
ln -sf ../usr/lib/version "$TARGET_DIR/etc/version"
ln -sf version "$TARGET_DIR/etc/motd"
