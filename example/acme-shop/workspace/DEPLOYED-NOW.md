# Deployed now

What runs where, right now. **Every row carries the command that measured it. A row more than a few days old must be
re-measured before it is believed**; a deploy record is true of a moment, not of today.

| machine | what | version | since | measured | with |
| --- | --- | --- | --- | --- | --- |
| `prod` 203.0.113.10 | shop (app, worker, scheduler) | v1.4.2, image `acme-shop:3f9c2a1` | 2026-09-28 | 2026-10-03 19:00 +0330 | `ssh deploy@203.0.113.10 'docker compose -p acme ps --format "{{.Service}} {{.Image}} {{.Status}}"'` |
| `prod` 203.0.113.10 | PostgreSQL 16 | 16.4 | 2026-09-28 | 2026-10-03 19:00 +0330 | `ssh deploy@203.0.113.10 'docker compose -p acme exec -T db postgres --version'` |
| `prod` 203.0.113.10 | nightly backup timer | `acme-backup.timer`, last run OK 03:00 | 2026-09-28 | 2026-10-03 19:02 +0330 | `ssh deploy@203.0.113.10 'systemctl list-timers acme-backup.timer --no-pager'` |
| `build` 198.51.100.20 | image builds only; nothing runs for this project | — | — | 2026-10-03 19:03 +0330 | `ssh builder@198.51.100.20 'docker ps --filter label=project=acme -q \| wc -l'` → `0` |
