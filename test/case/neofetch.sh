#!/bin/sh
# curios-neofetch: a one-shot command, so it is checked by what it prints.
set -e
. "$(dirname "$0")/../lib.sh"

IMG=$(load_image "$1")

head1 "curios-neofetch ($IMG)"

OUT=$($RUNTIME run --rm "$IMG" 2>&1 || true)

check "runs and reports the OS" sh -c "printf '%s' \"\$0\" | grep -qi curios" "$OUT"
check "reports a kernel"        sh -c "printf '%s' \"\$0\" | grep -qi kernel" "$OUT"

summary
