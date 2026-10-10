# 2026-10-01: the workspace was created

**Kind:** record · never rewritten; a correction is a new record that links this one.

**What was asked:** the owner asked for one place holding everything about the shop that is not code, so that they
would not have to explain the project again after a restart.

**Where the material was before:** server facts and the backup question in chat only; a measurement script in a
session scratchpad; notes about the build box in the code repository's `notes.md` (not reviewed, not current).

**What was done, 10:00–11:10 +0330:**

- Created `~/projects/acme-shop/workspace` beside the code repository, with `.gitignore` written before any other
  file.
- Measured the laptop (`THIS-MACHINE.md`) and both servers (`servers/`).
- Saved the scratchpad's upload-speed script before the session ended. It became evidence in the next day's backup
  report rather than a tool.
- Left `notes.md` in the code repository, untouched; the server facts it held were re-measured instead of copied.
- Installed the tools. `tools/scan-secrets.sh --self-test` passed. `tools/sync-claude-memory.sh to-workspace`
  printed the derived path `-Users-you-projects-acme-shop`, confirmed with `ls ~/.claude/projects/`.
- The owner approved a **private** remote in chat. It was created as `<owner>/workspace-acme-shop`; first commit with
  explicit paths.

**Verified:** `tools/check-links.py` → `broken: 0`; it reported a planted broken link in a test sample, so the zero
is meaningful. `tools/scan-secrets.sh .` → nothing. `git status --ignored` → no secret-shaped file tracked.

**Not verified:** whether `notes.md` holds anything still true that was not re-measured. It is linked, not trusted.

**Incident on the day:** four parallel SSH connections to `build` were refused on port 22 for ~60 s (measured with a
polling loop: `nc -z 198.51.100.20 22` every 10 s). With the owner's OK, connection sharing was added to
`~/.ssh/config`; the rule is on the server's page and the change in `THIS-MACHINE.md`.
