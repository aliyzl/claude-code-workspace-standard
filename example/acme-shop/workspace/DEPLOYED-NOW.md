# Deployed now

**Kind:** register · **Measured:** 2026-10-03 19:00 +0330, by running "How to re-measure" whole · A row older than a
few days is re-measured before it is believed. If this disagrees with the machine, the machine is right.

| machine | what | version | since | measured with |
| --- | --- | --- | --- | --- |
| `prod` 203.0.113.10 | shop (app, worker, scheduler) | v1.4.2, image `acme-shop:3f9c2a1` | 2026-09-28 | `docker compose -p acme ps` |
| `prod` 203.0.113.10 | PostgreSQL | 16.4 | 2026-09-28 | `docker compose -p acme exec -T db postgres --version` |
| `prod` 203.0.113.10 | nightly backup timer | `acme-backup.timer`, last run OK 03:00 | 2026-09-28 | `systemctl list-timers acme-backup.timer` |
| `build` 198.51.100.20 | nothing runs for this project; image builds only | — | — | `docker ps --filter label=project=acme -q \| wc -l` → `0` |

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
