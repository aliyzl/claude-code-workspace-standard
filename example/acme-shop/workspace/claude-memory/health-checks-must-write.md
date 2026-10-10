---
name: health-checks-must-write
description: A health check must prove a write; one that only answers stayed green through a full disk on 2026-10-03
metadata:
  type: feedback
---

On 2026-10-03 checkout was slow for ~40 minutes while `/health` answered `200` in 3 ms: the production disk was full and every write failed. The check never touched the disk or the database, so it could not have reported the failure.

**Why:** a check whose negative result is unreachable proves nothing when it passes.
**How to apply:** any health check, smoke test or monitor added to this project must exercise the thing it guards (insert and delete a row, write a file). Before trusting a green result, ask what red would have required. Record: `workspace/records/2026-10-03/checkout-slow-disk-full.md`. Related: [[acme-shop-workspace]].
