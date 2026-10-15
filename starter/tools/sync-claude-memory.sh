#!/bin/zsh
# Usage: tools/sync-claude-memory.sh to-workspace | to-claude
#   to-workspace  copy the live Claude memory (*.md only) into claude-memory/ (run before a commit)
#   to-claude     restore claude-memory/ into the live memory folder (on a new machine, into an empty folder only)
# The live folder is derived from the project root (this workspace's parent), the directory sessions start in.
# If sessions start elsewhere, set CLAUDE_MEMORY_DIR. Verify the printed path with: ls ~/.claude/projects/
set -eu
HERE=${0:A:h:h}
ROOT=${HERE:h}
LIVE=${CLAUDE_MEMORY_DIR:-$HOME/.claude/projects/${ROOT//[^A-Za-z0-9]/-}/memory}
COPY="$HERE/claude-memory"
case "${1:-}" in
  to-workspace)
    if [[ ! -f $LIVE/MEMORY.md ]]; then
      echo "refusing: no MEMORY.md in $LIVE; a sync from an empty or wrong folder would empty the copy" >&2; exit 1
    fi
    if ! "$HERE/tools/scan-secrets.sh" "$LIVE" >/dev/null; then
      echo "refusing: something key-shaped is in the live memory; run tools/scan-secrets.sh $LIVE" >&2; exit 1
    fi
    for f in $LIVE/*(N.:t); do
      [[ $f == *.md ]] || { echo "skipped, not memory: $f" >&2; continue; }
      [[ $f == MEMORY.md ]] || grep -qF "($f)" "$LIVE/MEMORY.md" || echo "note: $f is not indexed in MEMORY.md" >&2
    done
    mkdir -p "$COPY"
    rsync -a --delete --exclude 'README-THIS-IS-A-COPY.md' --include '*.md' --exclude '*' "$LIVE/" "$COPY/" ;;
  to-claude)
    if [[ -d $LIVE && -n $(ls -A "$LIVE") ]]; then
      echo "refusing: $LIVE already has files; restoring would replace newer memory. Move them aside first." >&2; exit 1
    fi
    mkdir -p "$LIVE"; rsync -a --exclude 'README-THIS-IS-A-COPY.md' "$COPY/" "$LIVE/" ;;
  *) echo "usage: $0 to-workspace | to-claude" >&2; exit 2 ;;
esac
echo "done: $1 ($LIVE)"
