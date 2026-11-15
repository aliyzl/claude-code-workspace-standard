#!/bin/bash
# Usage: tools/scan-secrets.sh <path>...     list files holding something key-shaped, as "<file>: <count>"; exit 1 if any
#        tools/scan-secrets.sh --self-test    prove the scan can fail: plant fakes in a temp dir, expect each caught
# Prints counts only, never the matching text: a "masking" step that prints matching lines is how a key reaches a
# transcript. Project-specific personal-data patterns (phone numbers, national ids, e-mails) go in
# tools/personal-data.patterns, one extended regex per line; blank lines and # comments are ignored.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
KEYS='(^|[^A-Za-z0-9])(sk-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|xox[abprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35})|BEGIN [A-Z ]*PRIVATE KEY|[0-9]{8,10}:[A-Za-z0-9_-]{35}|sshpass[[:space:]]+-p|password[[:space:]]*[:=][[:space:]]*[^[:space:]]{6,}'
EXTRA=$(mktemp); trap 'rm -rf "$EXTRA" ${T:+"$T"}' EXIT
grep -vE '^[[:space:]]*(#|$)' "$HERE/personal-data.patterns" > "$EXTRA" 2>/dev/null || true

count() {
  local n m=0
  n=$(grep -cIE -e "$KEYS" -- "$1" 2>/dev/null) || n=0
  if [ -s "$EXTRA" ]; then m=$(grep -cIEf "$EXTRA" -- "$1" 2>/dev/null) || m=0; fi
  echo $(( n + m ))
}

scan() {
  local hits=0 f n
  while IFS= read -r -d '' f; do
    n=$(count "$f")
    if [ "$n" -gt 0 ]; then echo "$f: $n"; hits=$((hits + 1)); fi
  done < <(find "$@" -type f -not -path '*/.git/*' -print0)
  [ "$hits" -eq 0 ]
}

if [ "${1:-}" = "--self-test" ]; then
  T=$(mktemp -d)
  # The fakes are assembled at run time, so this script never matches its own scan.
  s=sk; g=gh; x=xo; a=AK; z=AI; b=BEG; p=pass; t='123456789:'
  printf '%s\n' "KEY=${s}-proj-AbCdEfGhIjKlMnOpQrStUvWx123" > "$T/1"
  printf '%s\n' "${g}o_AbCdEfGhIjKlMnOpQrStUvWxYz0123456789" > "$T/2"
  printf '%s\n' "${x}xb-1234567890-abcdefghijkl" > "$T/3"
  printf '%s\n' "${a}IAABCDEFGHIJKLMNOP" > "$T/4"
  printf '%s\n' "${z}zaSyAbCdEfGhIjKlMnOpQrStUvWxYz0123456" > "$T/5"
  printf '%s\n' "-----${b}IN OPENSSH PRIVATE KEY-----" > "$T/6"
  printf '%s\n' "${t}AAEhBP0av28dAAAAAAAAAAAAAAAAAAAAAAA" > "$T/7"
  printf '%s\n' "ssh${p} -p hunter22x ssh root@host" > "$T/8"
  printf '%s\n' "db ${p}word = hunter22x" > "$T/9"
  printf '%s\n' "checkout-slow-disk-full; the task-runner; gh_pages; ask-me" > "$T/clean"
  out=$(scan "$T"); ok=1
  for i in 1 2 3 4 5 6 7 8 9; do
    printf '%s\n' "$out" | grep -q "/$i: " || { echo "self-test: fake $i was NOT caught" >&2; ok=0; }
  done
  if printf '%s\n' "$out" | grep -q '/clean: '; then echo "self-test: a clean file was flagged" >&2; ok=0; fi
  [ "$ok" -eq 1 ] && { echo "self-test: 9/9 fakes caught, clean file passed"; exit 0; }
  exit 1
fi

[ $# -ge 1 ] || { echo "usage: $0 <path>... | --self-test" >&2; exit 2; }
for p in "$@"; do  # a scan of a path that does not exist must fail, not report "clean"
  [ -e "$p" ] || { echo "no such path: $p" >&2; exit 2; }
done
scan "$@"
