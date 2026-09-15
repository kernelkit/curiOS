#!/bin/sh
# curios: the staging container, where the full toolbox is the point.
set -e
. "$(dirname "$0")/../lib.sh"

IMG=$(load_image "$1")
trap cleanup EXIT

head1 "curios system ($IMG)"

check "declares a health check" \
      sh -c "image_field $IMG '{{.Config.Healthcheck.Test}}' | grep -q curios-health"

for tool in nft ntpq tcpdump netopeer2-cli mg; do
	check "ships $tool" $RUNTIME run --rm --entrypoint /bin/sh "$IMG" \
	      -c "command -v $tool"
done

check "os-release identifies curiOS" \
      sh -c "$RUNTIME run --rm --entrypoint /bin/sh $IMG -c 'cat /etc/os-release' | grep -q '^ID=curios'"

summary
