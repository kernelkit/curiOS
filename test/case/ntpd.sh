#!/bin/sh
# curios-ntpd: binds NTP, reports healthy, and ships no shell.
set -e
. "$(dirname "$0")/../lib.sh"

IMG=$(load_image "$1")
trap cleanup EXIT

head1 "curios-ntpd ($IMG)"

check "exposes port 123/udp" \
      sh -c "image_field $IMG '{{.Config.ExposedPorts}}' | grep -q '123/udp'"
check "declares a health check" \
      sh -c "image_field $IMG '{{.Config.Healthcheck.Test}}' | grep -q curios-health"

# The image deliberately has no shell, which is why the health probe is
# a binary rather than a shell one-liner.
check_not "ships no shell" $RUNTIME run --rm --entrypoint /bin/sh "$IMG" -c true

start --cap-add SYS_TIME "$IMG" >/dev/null

if await_health healthy 40; then
	ok "reports healthy"
else
	fail "reports healthy (got '$($RUNTIME inspect --format '{{.State.Health.Status}}' "$CID" 2>/dev/null)')"
fi

summary
