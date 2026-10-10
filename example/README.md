# Example: a filled workspace

`acme-shop/workspace/` is what a workspace looks like after its first three days, built by following
[`WORKSPACE-STANDARD.md`](../WORKSPACE-STANDARD.md). The project is **fictional**:

- IP addresses come from the RFC 5737 documentation ranges (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`);
- domains are `example.com`, `example.net` and their subdomains;
- `<owner>` stands for the owner's GitHub account.

The owner's summary lines are in Persian, to show the standard's "owner's language" rule. Everything an agent works
with is in English.

## The story it tells

| date | what happened | where it is recorded |
| --- | --- | --- |
| 2026-10-01 | the workspace was created; an SSH rate limit on the shared build box was hit | [`records/2026-10-01/`](acme-shop/workspace/records/2026-10-01/workspace-created.md), [`servers/build-…`](acme-shop/workspace/servers/build-198.51.100.20/README.md) |
| 2026-10-02 | the off-site backup question was investigated; the decision is the owner's | [`reports/2026-10-02-backup-destination/`](acme-shop/workspace/reports/2026-10-02-backup-destination/README.md), [`NEEDS-A-PERSON.md`](acme-shop/workspace/NEEDS-A-PERSON.md) #1 |
| 2026-10-03 | checkout slowed because the disk was full while the health check stayed green | [`records/2026-10-03/`](acme-shop/workspace/records/2026-10-03/checkout-slow-disk-full.md), a trap in [`RESUME-HERE.md`](acme-shop/workspace/RESUME-HERE.md), a memory note |

## Which file shows which rule

| file | standard section | what to notice |
| --- | --- | --- |
| [`README.md`](acme-shop/workspace/README.md) | §5 | the owner's one-line summary; rules that name their incident |
| [`RESUME-HERE.md`](acme-shop/workspace/RESUME-HERE.md) | §5 | "checked against reality by" with the commands; traps with their rules |
| [`NEEDS-A-PERSON.md`](acme-shop/workspace/NEEDS-A-PERSON.md) | §5 | reason legend; owner-language summary; the owner's answer quoted verbatim in Closed |
| [`DEPLOYED-NOW.md`](acme-shop/workspace/DEPLOYED-NOW.md) | §5 | every row carries the command and time that measured it |
| [`THIS-MACHINE.md`](acme-shop/workspace/THIS-MACHINE.md) | §5 | measured, not remembered; "a failed fetch from here is not evidence" |
| [`records/…/checkout-slow-disk-full.md`](acme-shop/workspace/records/2026-10-03/checkout-slow-disk-full.md) | §6, §7.4 | a check whose negative result was unreachable; verified vs not; what would change the answer |
| [`reports/2026-10-02-backup-destination/`](acme-shop/workspace/reports/2026-10-02-backup-destination/README.md) | §6 | verdict first; every number traced to a file in `evidence/` |
| [`servers/`](acme-shop/workspace/servers/README.md) | §6 | explicit yes/no lists; a shared server's "may not" |
| [`tools/`](acme-shop/workspace/tools/README.md) | §6, §16 | the two standard tools, ready to copy |
| [`claude-memory/`](acme-shop/workspace/claude-memory/README-THIS-IS-A-COPY.md) | §10 | a copy, never edited; memory notes that point into the workspace |
| [`.gitignore`](acme-shop/workspace/.gitignore) | §8, §16 | written before the first commit |

Not shown, because nothing in this project needed them yet: `NEXT-WORK.md`, `MOVING-TO-ANOTHER-MACHINE.md`,
`reference/`, `snapshots/`, `secrets/` and the vault. The standard adds a folder only when its first real file
arrives.

## Check it yourself

```bash
python3 -I example/acme-shop/workspace/tools/check-links.py example/acme-shop/workspace
```
