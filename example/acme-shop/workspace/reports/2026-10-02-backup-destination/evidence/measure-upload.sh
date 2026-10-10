#!/bin/bash
# Usage (on prod): measure-upload.sh <dump-file> <destination-name> <upload-command...>
# Times one upload of the same dump and prints bytes, seconds and rate. Read-only on prod; writes only to the target.
set -eu
FILE="$1"; NAME="$2"; shift 2
BYTES=$(stat -c%s "$FILE")
START=$(date +%s.%N)
"$@" "$FILE"
END=$(date +%s.%N)
SECS=$(echo "$END - $START" | bc)
echo "== $NAME"
echo "upload: $BYTES bytes in $(printf '%.1f' "$SECS") s ($(echo "scale=1; $BYTES / 1048576 / $SECS" | bc) MiB/s)"
