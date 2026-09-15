# Shared helpers for curiOS container tests.  Sourced, not run.
# shellcheck shell=sh

: "${RUNTIME:=podman}"

TESTS=0
FAILS=0
CID=

say()  { printf '    %s\n' "$*"; }
head1(){ printf '\n== %s\n' "$*"; }

ok()
{
	TESTS=$((TESTS + 1))
	printf '    ok   %s\n' "$*"
}

fail()
{
	TESTS=$((TESTS + 1))
	FAILS=$((FAILS + 1))
	printf '    FAIL %s\n' "$*"
}

check()
{
	desc=$1
	shift
	if "$@" >/dev/null 2>&1; then
		ok "$desc"
	else
		fail "$desc"
	fi
}

# Compare strings in the current shell; helper functions are not
# visible to a 'sh -c' subshell.
check_match()
{
	case "$2" in
		*"$3"*) ok   "$1" ;;
		*)      fail "$1  (looked for '$3' in '$2')" ;;
	esac
}

skip()
{
	printf '    skip %s\n' "$*"
}

check_not()
{
	desc=$1
	shift
	if "$@" >/dev/null 2>&1; then
		fail "$desc"
	else
		ok "$desc"
	fi
}

# Load an OCI tarball and echo the resulting image reference.
load_image()
{
	tarball=$1

	[ -f "$tarball" ] || {
		echo "ERROR: no such tarball: $tarball" >&2
		exit 1
	}

	out=$($RUNTIME load < "$tarball" 2>&1) || {
		echo "$out" >&2
		exit 1
	}
	printf '%s\n' "$out" | sed -n 's/.*Loaded image: *//p' | head -1
}

# Inspect a field of the image configuration.
image_field()
{
	$RUNTIME image inspect --format "$2" "$1" 2>/dev/null
}

# Read the image config blob straight out of the OCI directory in the
# tarball.  The runtimes drop anything the OCI config struct does not
# name -- Healthcheck among it -- so asking them is not the same as
# asking the image.
image_config()
{
	tarball=$1
	dir=$(mktemp -d)

	tar xzf "$tarball" -C "$dir" 2>/dev/null || {
		rm -rf "$dir"
		return 1
	}

	python3 - "$dir" <<-\EOF
	import json, os, sys
	oci = sys.argv[1]
	with open(os.path.join(oci, "index.json")) as fh:
	    index = json.load(fh)
	algo, hexd = index["manifests"][0]["digest"].split(":", 1)
	with open(os.path.join(oci, "blobs", algo, hexd)) as fh:
	    manifest = json.load(fh)
	algo, hexd = manifest["config"]["digest"].split(":", 1)
	with open(os.path.join(oci, "blobs", algo, hexd)) as fh:
	    sys.stdout.write(fh.read())
	EOF

	rm -rf "$dir"
}

start()
{
	CID=$($RUNTIME run -d "$@") || {
		echo "ERROR: could not start container" >&2
		exit 1
	}
	printf '%s\n' "$CID"
}

# Wait for the container health status to settle, up to N seconds.
await_health()
{
	want=$1
	secs=${2:-30}

	while [ "$secs" -gt 0 ]; do
		got=$($RUNTIME inspect --format '{{.State.Health.Status}}' \
		          "$CID" 2>/dev/null)
		[ "$got" = "$want" ] && return 0
		# An image with no health check never leaves the empty state.
		[ -z "$got" ] && return 1
		sleep 1
		secs=$((secs - 1))
	done

	return 1
}

cleanup()
{
	[ -n "$CID" ] && $RUNTIME rm -f "$CID" >/dev/null 2>&1
	CID=
}

summary()
{
	printf '\n    %d test(s), %d failure(s)\n' "$TESTS" "$FAILS"
	[ "$FAILS" -eq 0 ]
}
