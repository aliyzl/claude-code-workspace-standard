# Tools

| script | usage | what it does |
| --- | --- | --- |
| `check-links.py` | `python3 -I tools/check-links.py` | reports broken relative links in live documents (`records/` and `evidence/` skipped, code spans stripped); exit 1 if any |
| `sync-claude-memory.sh` | `tools/sync-claude-memory.sh to-workspace \| to-claude` | copies the live Claude memory into `claude-memory/` (before a commit) or back (on a new machine); refuses if anything key-shaped is in it |

The upload-speed script lives with the report it served, in
`reports/2026-10-02-backup-destination/evidence/measure-upload.sh`, because it is evidence, not a reusable tool.
