#!/bin/sh
# Run the curiOS container tests.
#
#   ./test/run.sh                       test every tarball in output/images/
#   ./test/run.sh httpd output/images/curios-httpd-oci-x86_64.tar.gz
#
set -e

TOP=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
: "${RUNTIME:=podman}"
export RUNTIME

command -v "$RUNTIME" >/dev/null 2>&1 || {
	echo "ERROR: $RUNTIME not found, set RUNTIME=docker to use docker" >&2
	exit 1
}

rc=0

run_case()
{
	app=$1
	tarball=$2

	[ -f "$TOP/test/case/$app.sh" ] || {
		echo "ERROR: no test case for '$app'" >&2
		exit 1
	}
	"$TOP/test/case/$app.sh" "$tarball" || rc=1
}

if [ $# -eq 2 ]; then
	run_case "$1" "$2"
elif [ $# -eq 0 ]; then
	found=false
	for tarball in "$TOP"/output/images/curios*-oci-*.tar.gz; do
		[ -f "$tarball" ] || continue
		found=true
		name=$(basename "$tarball")
		name=${name%%-oci-*}
		case "$name" in
			curios)   app=system ;;
			curios-*) app=${name#curios-} ;;
			*)        continue ;;
		esac
		run_case "$app" "$tarball"
	done
	$found || {
		echo "Nothing to test.  Build an image first:" >&2
		echo "  make httpd_amd64_defconfig && make" >&2
		exit 1
	}
else
	echo "Usage: $0 [APP TARBALL]" >&2
	exit 1
fi

exit $rc
