# Resume here

**Last updated: 2026-10-03 19:05 +0330.** Checked against reality by: `ssh deploy@203.0.113.10 'df -h /; docker
compose -p acme ps'` and `gh pr list --repo <owner>/acme-shop --state open`. Kept current; edit in place.

## Where the shop stands

**Live since 2026-09-28, release v1.4.2, checkout open.** See [`DEPLOYED-NOW.md`](DEPLOYED-NOW.md).

- **2026-10-03:** checkout was slow for ~40 minutes because the production disk filled with uncompressed logs. It is
  fixed (log rotation + 12 GB freed), and the health check now writes a row instead of only answering. Record:
  [`records/2026-10-03/checkout-slow-disk-full.md`](records/2026-10-03/checkout-slow-disk-full.md).
- **Backups:** nightly database backups exist **only on the production server**. A disk failure would lose the
  database and its backups together. The investigation is done:
  [`reports/2026-10-02-backup-destination/`](reports/2026-10-02-backup-destination/README.md). It recommends an
  object-storage bucket abroad plus a weekly copy kept by the owner. The decision is `NEEDS-A-PERSON.md` #1.

## Next, in order

1. **Owner decides the backup destination** (`NEEDS-A-PERSON.md` #1). Then the off-site copy goes in as a pull request
   to the code repository's backup script; nothing is configured by hand on the server.
2. **Open PR #31** (log rotation in the compose file) needs one review, then the owner's merge.
3. **Owner checks checkout on a real phone over mobile data** (`NEEDS-A-PERSON.md` #3). The laptop's VPN cannot
   reproduce what customers see.

## Traps that already cost something

- **2026-10-03: a health check that could not fail.** It answered `200` in 3 ms while every write failed on a full
  disk. Rule: a health check must prove a write. See [`records/2026-10-03/checkout-slow-disk-full.md`](records/2026-10-03/checkout-slow-disk-full.md).
- **2026-10-01: four parallel SSH connections to the build box** got this laptop refused on port 22 for about a
  minute. Rule: one multiplexed connection. See [`servers/build-198.51.100.20/`](servers/build-198.51.100.20/README.md).
