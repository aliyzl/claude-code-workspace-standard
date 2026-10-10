#!/bin/zsh
# Usage: sync-claude-memory.sh to-workspace | to-claude
#   to-workspace  copy the live Claude memory into claude-memory/ (run before a commit)
#   to-claude     restore claude-memory/ into the live memory directory (on a new machine)
set -eu
HERE=${0:A:h:h}
LIVE="$HOME/.claude/projects/-Users-you-projects-acme-shop/memory"     # verify with: ls ~/.claude/projects/
COPY="$HERE/claude-memory"
case "${1:-}" in
  to-workspace)
    # Memory must never hold a secret; refuse if anything key-shaped appears.
    if grep -rIl -E '(^|[^A-Za-z0-9])(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|AKIA[0-9A-Z]{16})|BEGIN [A-Z ]*PRIVATE KEY|[0-9]{8,10}:[A-Za-z0-9_-]{35}|password[[:space:]]*[:=][[:space:]]*[^[:space:]]{6,}' "$LIVE" >/dev/null 2>&1; then
      echo "refusing: something key-shaped is in the live memory" >&2; exit 1
    fi
    rsync -a --delete --exclude 'README-THIS-IS-A-COPY.md' "$LIVE/" "$COPY/" ;;
  to-claude)
    mkdir -p "$LIVE"; rsync -a --exclude 'README-THIS-IS-A-COPY.md' "$COPY/" "$LIVE/" ;;
  *) echo "usage: $0 to-workspace | to-claude" >&2; exit 2 ;;
esac
echo "done: $1"
