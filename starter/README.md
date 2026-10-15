# workspace: everything about <project> that is not code

<!-- Starter: what this folder is, its only reading list, and its rules (§5). Fill every <…>; delete this line. -->

**Kind:** register · **Owned by:** <session role> · **Last checked:** <YYYY-MM-DD HH:MM timezone>

<One paragraph: who asked for this folder and when, what it holds, and what it was scattered across before.>

## New here? Read in this order

| | file | what it answers |
| --- | --- | --- |
| 1 | [`RESUME-HERE.md`](RESUME-HERE.md) | **The entry point.** Where the project stands and what comes next |
| 2 | [`NEEDS-A-PERSON.md`](NEEDS-A-PERSON.md) | What only the owner can do or decide; what was decided under delegation |
| 3 | [`THIS-MACHINE.md`](THIS-MACHINE.md) | The laptop: paths, versions, the network, the changes we made |

<!-- Add a row for servers/README.md when the first server page exists. -->

This is the only reading list. Other files link here rather than repeating it.

## Where a file belongs

| kind | where | rule |
| --- | --- | --- |
| **register**: what is true now | top level, never dated | edited in place; kind header; about 150 lines at most |
| **record**: what happened or was measured | `records/<YYYY-MM-DD>/` | never moved, never rewritten; a correction is a new record |
| **report**: an investigation behind a decision | `reports/<YYYY-MM-DD>-<topic>/` | `README.md` is the verdict; `evidence/` holds what it rests on |
| **server**: one machine | `servers/<name>-<ip>/` | what we may and may not do there; a change log |
| **tool**: a script | `tools/` | usage line at the top; listed in `tools/README.md` |
| **memory copy** | `claude-memory/` | a copy; refreshed by `tools/sync-claude-memory.sh` |

Specs, plans, runbooks and `CLAUDE.md` live in the code repository. This folder links to them by branch and path and
never copies them.

## Rules

1. **No secret ever lands here in plaintext.** Name where a secret lives instead.
2. **Stage explicit paths.** Never `git add -A`, `git add .` or `git commit -a`.
3. <Project-specific rules, each with the incident or reason behind it.>

## Where this folder sits

`<absolute path>`. <Git: "its own repository, remote `<owner>/<name>`, private, since <date>" OR "not a git
repository yet; see NEEDS-A-PERSON #<n>".> The code repositories are `<paths>`; this folder links to them and never
copies them.
