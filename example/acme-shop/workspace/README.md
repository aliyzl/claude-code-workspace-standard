# workspace: everything about Acme Shop that is not code

The owner asked for this folder on 2026-10-01, after a week in which the shop's server facts, a backup question and a
checkout incident lived only in chat. It holds what is true now, what is still open, the servers, the investigations
behind decisions, and the tools. It follows `WORKSPACE-STANDARD.md` version 1.

> **For the owner, in one line:** «هر چیزی درباره‌ی فروشگاه Acme که کد نیست، اینجاست. از `RESUME-HERE.md` شروع کنید.»

## New here? Read in this order

| | file | what it answers |
| --- | --- | --- |
| 1 | [`RESUME-HERE.md`](RESUME-HERE.md) | **The entry point.** Where the shop stands and what comes next |
| 2 | [`NEEDS-A-PERSON.md`](NEEDS-A-PERSON.md) | Decisions only the owner can make, each with the reason |
| 3 | [`DEPLOYED-NOW.md`](DEPLOYED-NOW.md) | What runs where right now, with the command that measured it |
| 4 | [`servers/`](servers/README.md) | Both servers, and what this project may do on each |
| 5 | [`THIS-MACHINE.md`](THIS-MACHINE.md) | The laptop: paths, versions, the VPN |

## Where a file belongs

| kind | where | rule |
| --- | --- | --- |
| **register**: what is true now | top level, never dated | edited in place; carries the date it was last checked |
| **record**: what happened or was measured | `records/<YYYY-MM-DD>/` | never moved, never rewritten; a correction is a new record |
| **report**: an investigation behind a decision | `reports/<YYYY-MM-DD>-<topic>/` | `README.md` is the verdict; `evidence/` holds what it rests on |
| **server**: one machine | `servers/<name>-<ip>/` | what we may and may not do there |
| **tool**: a script | `tools/` | usage line at the top; listed in `tools/README.md` |
| **memory copy** | `claude-memory/` | a copy; refreshed by `tools/sync-claude-memory.sh` |

The roadmap, specs, ADRs, runbooks and `CLAUDE.md` live in the code repository (`../acme-shop/`, not included in this
example). This folder links to them by branch and path and never copies them.

## Rules

1. **No secret ever lands here in plaintext.** The database password is in `/etc/acme/app.env` on `prod`, written by
   the owner; the payment gateway's merchant id is entered in the shop panel by the owner.
2. **Stage explicit paths.** Never `git add -A`, `git add .` or `git commit -a`.
3. **Nothing here writes to production.** A runbook in the code repository describes; the owner, or an agent with the
   owner's word for that change, acts.
4. **A health check must prove a write, not just answer.** Origin: [`records/2026-10-03/checkout-slow-disk-full.md`](records/2026-10-03/checkout-slow-disk-full.md).

## Where this folder sits

`~/projects/acme-shop/workspace`, beside the code repository `~/projects/acme-shop/acme-shop`. It is its own git
repository with a **private** remote, created 2026-10-01 on the owner's word (see `NEEDS-A-PERSON.md` → Closed).
