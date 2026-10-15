# Tools

<!-- Starter: one row per script that outlives a session (§6). Fill the header; delete this line. -->

**Kind:** register · **Owned by:** <session role> · **Last checked:** <YYYY-MM-DD HH:MM timezone>

| script | usage | what it does |
| --- | --- | --- |
| `check-links.py` | `python3 -I tools/check-links.py` | reports broken relative links in live documents (`records/` and `evidence/` skipped, code spans stripped); exit 1 if any |
| `scan-secrets.sh` | `tools/scan-secrets.sh <path>...` · `tools/scan-secrets.sh --self-test` | lists files holding something key-shaped, as counts only, never the text; the self-test proves it can fail |
| `sync-claude-memory.sh` | `tools/sync-claude-memory.sh to-workspace \| to-claude` | copies the live Claude memory (`*.md`) into `claude-memory/`, or restores it into an empty folder on a new machine; refuses an empty source, a key-shaped file, or a restore over existing memory |

All three are the templates of `WORKSPACE-STANDARD.md` §18, unchanged.
