#!/bin/sh
# curios: the staging container, where the full toolbox is the point.
set -e
. "$(dirname "$0")/../lib.sh"

TARBALL=$1
CFG=$(image_config "$TARBALL")
IMG=$(load_image "$TARBALL")
trap cleanup EXIT

head1 "curios system ($IMG)"

check_match "image declares a health check" "$CFG" '"Healthcheck"'
check_match "health check probes tcp:22"    "$CFG" 'tcp:22'

for tool in nft ntpq tcpdump netopeer2-cli mg mcjoin mping; do
	check "ships $tool" $RUNTIME run --rm --entrypoint /bin/sh "$IMG" \
	      -c "command -v $tool"
done

OUT=$($RUNTIME run --rm --entrypoint /bin/sh "$IMG" -c 'cat /etc/os-release')
check_match "os-release identifies curiOS" "$OUT" "ID=curios"

start "$IMG" >/dev/null
sleep 3
check "health probe reports sshd listening" \
      $RUNTIME exec "$CID" /usr/libexec/curios/curios-health tcp:22

summary
