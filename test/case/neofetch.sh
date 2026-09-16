#!/bin/sh
# curios-neofetch: a one-shot command, so it is judged by what it prints.
set -e
. "$(dirname "$0")/../lib.sh"

IMG=$(load_image "$1")

head1 "curios-neofetch ($IMG)"

OUT=$($RUNTIME run --rm "$IMG" 2>&1 || true)

check_match "reports the OS"    "$OUT" curiOS
check_match "reports a kernel"  "$OUT" Kernel

summary
