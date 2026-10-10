# 2026-10-03: checkout was slow for ~40 minutes; the disk was full

**What happened:** the owner wrote at 17:52 +0330: «پرداخت خیلی کند شده، مشتری زنگ زده» (payment has become very
slow; a customer called).

**What was measured, 17:55–18:40 +0330:**

| check | result | command |
| --- | --- | --- |
| disk on `prod` | `/` at 100%, 0 bytes free | `ssh deploy@203.0.113.10 'df -h /'` |
| largest directory | `/var/lib/docker/containers`: 11.8 GB of JSON logs | `ssh deploy@203.0.113.10 'sudo du -xh /var/lib/docker --max-depth 2 \| sort -h \| tail -5'` |
| the health check | `200` in 3 ms, the whole time | `curl -s -o /dev/null -w '%{http_code} %{time_total}' https://shop.example.com/health` |
| a real write | failed: `could not extend file: No space left on device` | app log, 17:58 |

**Why the alarm stayed silent:** the health check answered from memory and never touched the disk or the database.
It **could not** have reported this failure. A check whose negative result is unreachable is not a check.

**What was done, with the owner's word («درستش کن»):**

1. Truncated the container logs (12 GB freed). Checkout recovered at 18:31.
2. PR #31 in the code repository: log rotation in the compose file (`max-size: 50m`, `max-file: 3`).
3. PR #32: the health check now inserts and deletes a row in a `health_probe` table, and returns `503` if either fails.

**Verified:** checkout completed with a sandbox card at 18:36 from `prod` (`curl` against the sandbox flow). Disk at
41% (`df -h /`, 18:38).

**Not verified:** a real customer payment on a phone over mobile data. That is `NEEDS-A-PERSON.md` #3.

**What would change the answer:** if PR #31 is not merged before the next log burst, the disk fills again in about
nine days, at the measured rate of 1.3 GB a day.
