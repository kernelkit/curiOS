#!/bin/sh
# curios-nftables: loads a ruleset on start and flushes it on stop.
set -e
. "$(dirname "$0")/../lib.sh"

IMG=$(load_image "$1")
trap cleanup EXIT

head1 "curios-nftables ($IMG)"

check "declares a health check" \
      sh -c "image_field $IMG '{{.Config.Healthcheck.Test}}' | grep -q 'nft list ruleset'"

RULES=$(mktemp)
cat > "$RULES" <<'EOF'
table inet filter {
	chain input {
		type filter hook input priority 0; policy accept;
	}
}
EOF
trap 'cleanup; rm -f "$RULES"' EXIT

start --network=none --cap-add NET_ADMIN --cap-add NET_RAW \
      -v "$RULES:/etc/nftables.conf:ro" "$IMG" >/dev/null

if await_health healthy 30; then
	ok "reports healthy with a ruleset loaded"
else
	fail "reports healthy (got '$($RUNTIME inspect --format '{{.State.Health.Status}}' "$CID" 2>/dev/null)')"
fi

check "ruleset is actually present" \
      sh -c "$RUNTIME exec $CID nft list ruleset | grep -q 'table inet filter'"

summary
