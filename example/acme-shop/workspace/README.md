# workspace: everything about Acme Shop that is not code

**Kind:** register · **Owned by:** the shop session · **Last checked:** 2026-10-03 19:05 +0330

The owner asked for this folder on 2026-10-01, after a week in which the shop's server facts, a backup question and a
checkout incident lived only in chat. It holds what is true now, what is still open, the servers, the investigations
behind decisions, and the tools. It follows `WORKSPACE-STANDARD.md` version 2, with the owner profile's defaults.

## New here? Read in this order

| | file | what it answers |
| --- | --- | --- |
| 1 | [`RESUME-HERE.md`](RESUME-HERE.md) | **The entry point.** Standing facts, where the shop stands, what comes next |
| 2 | [`NEEDS-A-PERSON.md`](NEEDS-A-PERSON.md) | What only the owner can do or decide; what was decided under delegation |
| 3 | [`DEPLOYED-NOW.md`](DEPLOYED-NOW.md) | What runs where right now, and how to re-measure it |
| 4 | [`servers/`](servers/README.md) | Both servers, and what this project may do on each |
| 5 | [`THIS-MACHINE.md`](THIS-MACHINE.md) | The laptop: paths, versions, the VPN, and the changes we made to it |

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

The roadmap, specs, ADRs, runbooks and `CLAUDE.md` live in the code repository (`../acme-shop/`, not included in this
example). This folder links to them by branch and path and never copies them.

## Rules

1. **No secret ever lands here in plaintext.** The database password is in `/etc/acme/app.env` on `prod`, written by
   the owner. The payment gateway's merchant id is entered in the shop panel by the owner.
2. **Stage explicit paths.** Never `git add -A`, `git add .` or `git commit -a`.
3. **Nothing here writes to production.** A runbook in the code repository describes; the owner, or an agent with the
   owner's word for that change, acts.
4. **A health check must prove a write, not just answer.** Origin: [`records/2026-10-03/checkout-slow-disk-full.md`](records/2026-10-03/checkout-slow-disk-full.md).

## Where this folder sits

`~/projects/acme-shop/workspace`, beside the code repository `~/projects/acme-shop/acme-shop`. Sessions start in
`~/projects/acme-shop`. It is its own git repository with a **private** remote, created 2026-10-01 on the owner's word
(see `NEEDS-A-PERSON.md` → Closed).
