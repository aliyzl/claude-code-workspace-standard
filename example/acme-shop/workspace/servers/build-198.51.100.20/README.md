# build (198.51.100.20)

**Kind:** server · **Last surveyed:** 2026-10-03 · ssh alias `build` · If this disagrees with the machine, the machine
is right: re-survey.

**What it is:** a build box abroad, `ssh builder@198.51.100.20` with `~/.ssh/id_ed25519`. **Shared with another
project**, which owns it and runs its CI runner here.

## What this project may do there

- **Yes:** build this project's images (`docker build` with the label `project=acme`) and push them to the registry.
- **No:**
  - `docker system prune` or `docker image prune`, which would delete the other project's images and cache;
  - touching containers without the `project=acme` label;
  - running anything long-lived.

## Known behaviour

- **It rate-limits new SSH connections.** On 2026-10-01, four parallel connections got port 22 refused for ~60 s
  (polled with `nc -z 198.51.100.20 22` every 10 s). Use one multiplexed connection; the laptop's `~/.ssh/config`
  now does (see `THIS-MACHINE.md` → Changes we made here).
- **The other project's CI shares this box.** Check `docker ps` before a heavy build; the other project's lock file
  `/var/lock/ci-heavy.lock` is held while its suite runs.

## Change log

| date | change | undo |
| --- | --- | --- |
| — | none: this project changes nothing on a box it does not own | — |
