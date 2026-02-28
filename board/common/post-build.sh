#!/bin/sh
tagline="curiOS -- a slim curated container OS"

for start in S02sysctl S20seedrng S51sysrepo-plugind S52netopeer2; do
    rm -f "${TARGET_DIR}/etc/init.d/$start"
done

# We allow S40network but the user must provide the configuration
# because by default container runtimes manage all networking.
rm "${TARGET_DIR}/etc/network/interfaces"

VERSION="${CURIOS_VERSION}"
GIT_VERSION="${CURIOS_BUILD_ID}"

# Buildroot original remain in /usr/lib/os-release
rm "${TARGET_DIR}/etc/os-release"
cat <<-EOF >"${TARGET_DIR}/etc/os-release"
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

echo "$tagline $VERSION — $(date +"%b %e %H:%M %Z %Y")" > "$TARGET_DIR/etc/version"
ln -sf version "$TARGET_DIR/etc/motd"
