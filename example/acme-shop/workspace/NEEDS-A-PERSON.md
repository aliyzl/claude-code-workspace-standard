# Needs a person

**Kind:** register · **Owned by:** the shop session · **Last checked:** 2026-10-03 19:05 +0330

Things no agent can decide or verify. Each item says **why**, so it is clear who can unblock it.

| reason | why it blocks an agent |
| --- | --- |
| **business decision** | the answer is the owner's choice about money, law, product or direction |
| **owner's account** | it needs a registration, a payment or a login that only the owner holds |
| **owner's call by rule** | spending, publishing, deploying, merging, pushing, deleting, changing the owner's machine |
| **needs a network or device** | this laptop's VPN exits abroad, so it cannot see what a customer on a local mobile network sees |

## Open

| # | item | reason | since |
| --- | --- | --- | --- |
| 1 | **An off-site backup destination.** Until one exists, a disk failure on `prod` loses the database and its backups together. Options and costs: [`reports/2026-10-02-backup-destination/`](reports/2026-10-02-backup-destination/README.md) | business decision; owner's account | 2026-10-02 |
| 2 | **The payment gateway's merchant id**, entered by the owner in the panel's settings. It is never sent through chat | owner's account | 2026-10-01 |
| 3 | **A real checkout on a phone over mobile data.** The laptop's VPN exits abroad, so a successful test here proves nothing about customers | needs a network or device | 2026-10-03 |
| 4 | **Provisional: log rotation at 50 MB × 3 files per container** (adopted under delegation, see D1). Alternative: 20 MB × 5. Cost to reverse: one line in the compose file and a redeploy | business decision, provisional | 2026-10-03 |

## Decided under delegation

On 2026-10-03, while the checkout incident was being fixed, the owner delegated the technical choices of the fix and
reserved merging, deploying and anything that spends money.

| # | decision | reason | cost to reverse | date |
| --- | --- | --- | --- | --- |
| D1 | Log rotation: `max-size: 50m`, `max-file: 3` per container (PR #31) | at the measured 1.3 GB/day it caps logs at about 1 GB in total, and keeps about a day of history for debugging | one line and a redeploy | 2026-10-03 |
| D2 | The health check inserts and deletes a row in a `health_probe` table, and returns `503` if either fails (PR #32) | a check must exercise what it guards; the old one stayed green on a full disk | revert one pull request | 2026-10-03 |

## Closed

| item | outcome | date |
| --- | --- | --- |
| Should this workspace get a private GitHub remote? | **Yes, private.** The owner approved it in chat. Created as `<owner>/workspace-acme-shop` | 2026-10-01 |
