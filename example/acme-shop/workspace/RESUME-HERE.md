# Resume here

**Kind:** register · **Owned by:** the shop session · **Last checked against reality:** 2026-10-03 19:05 +0330, by
`ssh prod 'df -h /; docker compose -p acme ps'` and `gh pr list --repo <owner>/acme-shop --state open` · Budget:
about 150 lines; adding a block means archiving an older one.

## Standing facts

- **Production holds real customers' orders and payments.** Nothing writes to its database by hand without the owner's
  word for that change. **Ends when:** never, while the shop trades.
- **Backups exist only on `prod`.** A disk failure loses the database and its backups together. **Ends when:** the
  off-site copy of `NEEDS-A-PERSON.md` #1 runs and its first restore drill passes.

## Where the shop stands

**Live since 2026-09-28, release v1.4.2, checkout open.** See [`DEPLOYED-NOW.md`](DEPLOYED-NOW.md).

- **2026-10-03:** checkout was slow for ~40 minutes because the production disk filled with uncompressed logs. It is
  fixed (12 GB freed), and two pull requests make it hold: log rotation (#31) and a health check that writes (#32).
  Record: [`records/2026-10-03/checkout-slow-disk-full.md`](records/2026-10-03/checkout-slow-disk-full.md).
- **Backups:** the investigation is done:
  [`reports/2026-10-02-backup-destination/`](reports/2026-10-02-backup-destination/README.md). It recommends an
  object-storage bucket abroad plus a weekly copy kept by the owner. The decision is `NEEDS-A-PERSON.md` #1.

## Resuming on another machine

1. Clone `<owner>/acme-shop` beside this workspace, then run `tools/sync-claude-memory.sh to-claude`.
2. Lives outside git: the `prod` and `build` entries in `~/.ssh/config`. Re-create them from the server pages in
   `servers/`, which name the user and port. The production `.env` stays on `prod` and is never copied.

## Next, in order

1. **Owner decides the backup destination** (`NEEDS-A-PERSON.md` #1). The off-site copy then goes in as a pull
   request to the code repository's backup script; nothing is configured by hand on the server. Size: half a day,
   plus a restore drill.
2. **PR #31 and #32** need one review each, then the owner's merge. Size: an hour.
3. **Owner checks checkout on a real phone over mobile data** (`NEEDS-A-PERSON.md` #3). The laptop's VPN cannot
   reproduce what customers see. Size: ten minutes of the owner's time.

## Traps that already cost something

- **2026-10-03: a health check that could not fail.** It answered `200` in 3 ms while every write failed on a full
  disk. Rule: a health check must prove a write. See [`records/2026-10-03/checkout-slow-disk-full.md`](records/2026-10-03/checkout-slow-disk-full.md).
- **2026-10-01: four parallel SSH connections to the build box** got this laptop refused on port 22 for about a
  minute. Rule: one multiplexed connection. See [`servers/build-198.51.100.20/`](servers/build-198.51.100.20/README.md).
