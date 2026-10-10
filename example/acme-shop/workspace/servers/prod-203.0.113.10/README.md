# prod (203.0.113.10)

**What it is:** a VPS in the owner's country, 4 vCPU, 8 GB RAM, 80 GB disk, Ubuntu 24.04. `ssh deploy@203.0.113.10`
with `~/.ssh/id_ed25519`. Owned and paid for by the owner. Nothing else runs here.

## What this project may do there

- **Yes:**
  - read-only surveys (`df`, `docker compose ps`, logs);
  - deploys by the route in the code repository's `docs/runbooks/deploy.md`, with the owner's word for each release;
  - read-only `curl` checks of local services the laptop's VPN cannot reach.
- **No:**
  - writes to the production database by hand;
  - editing `/etc/acme/app.env`, which the owner maintains;
  - installing packages outside the runbook.

  Reason for all three: this is real customers' data, and a restore does not undo a payment that has already left.

## Known behaviour

- **2026-10-03:** the disk filled with container logs at ~1.3 GB a day; log rotation is PR #31. Re-measure with
  `ssh deploy@203.0.113.10 'df -h /'`.
- **2026-10-01:** the payment gateway's sandbox answers `200` from here and refuses the laptop's VPN exit.
