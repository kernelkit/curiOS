#!/bin/sh
# curios-nftables: loads a ruleset on start, and knows whether it is up.
set -e
. "$(dirname "$0")/../lib.sh"

TARBALL=$1
CFG=$(image_config "$TARBALL")
IMG=$(load_image "$TARBALL")

RULES=$(mktemp)
cat > "$RULES" <<'EOF'
table inet filter {
	chain input {
		type filter hook input priority 0; policy accept;
	}
}
EOF
trap 'cleanup; rm -f "$RULES"' EXIT

head1 "curios-nftables ($IMG)"

check_match "image declares a health check" "$CFG" '"Healthcheck"'
check_match "health check tests the ruleset" "$CFG" 'nft list ruleset'

start --network=none --cap-add NET_ADMIN --cap-add NET_RAW \
      -v "$RULES:/etc/nftables.conf:ro" "$IMG" >/dev/null
sleep 2

check "mounted ruleset is loaded" \
      sh -c "$RUNTIME exec $CID nft list ruleset | grep -q 'table inet filter'"
check "health check passes with a ruleset loaded" \
      $RUNTIME exec "$CID" /bin/sh -c 'test -n "$(nft list ruleset)"'

summary
