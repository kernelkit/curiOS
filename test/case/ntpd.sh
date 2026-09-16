#!/bin/sh
# curios-ntpd: binds NTP, ships no shell, probes itself with the binary.
set -e
. "$(dirname "$0")/../lib.sh"

TARBALL=$1
CFG=$(image_config "$TARBALL")
IMG=$(load_image "$TARBALL")
trap cleanup EXIT

head1 "curios-ntpd ($IMG)"

check_match "exposes port 123/udp" "$(image_field "$IMG" '{{.Config.ExposedPorts}}')" "123/udp"
check_match "image declares a health check" "$CFG" '"Healthcheck"'
check_match "health check probes udp:123"    "$CFG" 'udp:123'

# The image deliberately has no shell, which is why its probe is a
# binary rather than the ash script the other images use.
check_not "ships no shell" $RUNTIME run --rm --entrypoint /bin/sh "$IMG" -c true

start --cap-add SYS_TIME "$IMG" >/dev/null
sleep 3

check "health probe reports the daemon bound" \
      $RUNTIME exec "$CID" /usr/libexec/curios/curios-health udp:123
check_not "health probe fails on an unbound port" \
      $RUNTIME exec "$CID" /usr/libexec/curios/curios-health -q udp:64999

summary
