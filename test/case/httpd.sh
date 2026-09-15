#!/bin/sh
# curios-httpd: serves the bundled page, probes healthy, stays minimal.
set -e
. "$(dirname "$0")/../lib.sh"

TARBALL=$1
CFG=$(image_config "$TARBALL")
IMG=$(load_image "$TARBALL")
trap cleanup EXIT

head1 "curios-httpd ($IMG)"

check_match "entrypoint runs under tini" "$(image_field "$IMG" '{{.Config.Entrypoint}}')" tini
check_match "exposes port 80"            "$(image_field "$IMG" '{{.Config.ExposedPorts}}')" "80/tcp"
check_match "image declares a health check" "$CFG" '"Healthcheck"'
check_match "health check probes tcp:80"    "$CFG" 'tcp:80'

start -p 127.0.0.1:18080:80 "$IMG" >/dev/null
check "serves the index page" \
      sh -c "curl -fsS http://127.0.0.1:18080/ | grep -qi curios"
check "health probe reports the listener up" \
      $RUNTIME exec "$CID" /usr/libexec/curios/curios-health tcp:80
cleanup

# A web server has no business fetching from the network, and there is
# no package manager to add one with.
check_not "has no wget"            $RUNTIME run --rm --entrypoint /bin/sh "$IMG" -c "command -v wget"
check_not "has no package manager" $RUNTIME run --rm --entrypoint /bin/sh "$IMG" -c "command -v apk || command -v opkg"

summary
