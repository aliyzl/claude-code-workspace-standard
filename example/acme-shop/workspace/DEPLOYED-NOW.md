# Deployed now

**Kind:** register · **Measured:** 2026-10-03 19:00 +0330, by running "How to re-measure" whole · A row older than a
few days is re-measured before it is believed. If this disagrees with the machine, the machine is right.

| machine | what | version | since | measured with |
| --- | --- | --- | --- | --- |
| `prod` 203.0.113.10 | shop (app, worker, scheduler) | v1.4.2, image `acme-shop:3f9c2a1` | 2026-09-28 | `docker compose -p acme ps` |
| `prod` 203.0.113.10 | PostgreSQL | 16.4 | 2026-09-28 | `docker compose -p acme exec -T db postgres --version` |
| `prod` 203.0.113.10 | nightly backup timer | `acme-backup.timer`, last run OK 03:00 | 2026-09-28 | `systemctl list-timers acme-backup.timer` |
| `build` 198.51.100.20 | nothing runs for this project; image builds only | — | — | `docker ps --filter label=project=acme -q \| wc -l` → `0` |

## When nobody is watching

| question | answer | last tested |
| --- | --- | --- |
| owner unreachable for a day, and for a week | The shop keeps taking orders, which is intended. Nothing else acts on its own. | 2026-10-03 |
| how to stop it when the owner's usual channels are down | Only the owner can switch it to maintenance mode; no second person is named yet. | not tested |
| off-machine backups, and the last restore drill | None yet. Backups exist only on `prod` (`NEEDS-A-PERSON.md` #1). | never |
| what watches it from outside | Nothing yet. The health check now proves a write (PR #32), but it runs on `prod`. | not tested |

## How to re-measure

About thirty seconds. Run it whole, then move the "Measured" date above.

```bash
ssh deploy@203.0.113.10 '
  docker compose -p acme ps --format "{{.Service}} {{.Image}} {{.Status}}"
  docker compose -p acme exec -T db postgres --version
  systemctl list-timers acme-backup.timer --no-pager
'
ssh builder@198.51.100.20 'docker ps --filter label=project=acme -q | wc -l'
```
