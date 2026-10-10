# Example: a filled workspace

`acme-shop/workspace/` is what a workspace looks like after its first three days, built by following
[`WORKSPACE-STANDARD.md`](../WORKSPACE-STANDARD.md) version 2 with the owner profile's defaults: files in English,
the owner's words paraphrased.

The project is **fictional**:

- IP addresses come from the RFC 5737 documentation ranges (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`);
- domains are `example.com`, `example.net` and their subdomains;
- `<owner>` stands for the owner's GitHub account.

## The story it tells

| date | what happened | where it is recorded |
| --- | --- | --- |
| 2026-10-01 | the workspace was created; an SSH rate limit on the shared build box was hit | [`records/2026-10-01/`](acme-shop/workspace/records/2026-10-01/workspace-created.md), [`servers/build-…`](acme-shop/workspace/servers/build-198.51.100.20/README.md), `THIS-MACHINE.md` → Changes we made here |
| 2026-10-02 | the off-site backup question was investigated; the decision is the owner's | [`reports/2026-10-02-backup-destination/`](acme-shop/workspace/reports/2026-10-02-backup-destination/README.md), [`NEEDS-A-PERSON.md`](acme-shop/workspace/NEEDS-A-PERSON.md) #1 |
| 2026-10-03 | checkout slowed because the disk was full while the health check stayed green; the fix's choices were made under delegation | [`records/2026-10-03/`](acme-shop/workspace/records/2026-10-03/checkout-slow-disk-full.md), rulings D1 and D2 in `NEEDS-A-PERSON.md`, a standing fact and a trap in [`RESUME-HERE.md`](acme-shop/workspace/RESUME-HERE.md), a memory note |

## Which file shows which rule

| file | standard section | what to notice |
| --- | --- | --- |
| every file | §4 | the one-line kind header: kind, owner, last checked, what wins on disagreement |
| [`README.md`](acme-shop/workspace/README.md) | §5 | the only reading list; rules that name their incident |
| [`RESUME-HERE.md`](acme-shop/workspace/RESUME-HERE.md) | §5 | standing facts with the event that ends each; a size budget; sized next steps |
| [`NEEDS-A-PERSON.md`](acme-shop/workspace/NEEDS-A-PERSON.md) | §5, §12 | reason legend; a provisional row; rulings **decided under delegation** with their cost to reverse |
| [`DEPLOYED-NOW.md`](acme-shop/workspace/DEPLOYED-NOW.md) | §5 | one row per thing, and a "How to re-measure" block run whole |
| [`THIS-MACHINE.md`](acme-shop/workspace/THIS-MACHINE.md) | §5 | measured rows; **Changes we made here**, each with a "still in place?" check and an undo |
| [`records/…/checkout-slow-disk-full.md`](acme-shop/workspace/records/2026-10-03/checkout-slow-disk-full.md) | §6, §7 rule 4 | a check whose negative result was unreachable; verified vs not; what would change the answer |
| [`reports/2026-10-02-backup-destination/`](acme-shop/workspace/reports/2026-10-02-backup-destination/README.md) | §6 | verdict first; every number traced to a file in `evidence/` |
| [`servers/`](acme-shop/workspace/servers/README.md) | §6 | the list as the scope for "every machine"; ssh aliases; yes/no lists; change logs |
| [`tools/`](acme-shop/workspace/tools/README.md) | §6, §18 | the three standard tools, unchanged from the templates |
| [`claude-memory/`](acme-shop/workspace/claude-memory/README-THIS-IS-A-COPY.md) | §10 | a copy, never edited; one lesson per file, the rule in the description |
| [`.gitignore`](acme-shop/workspace/.gitignore) | §8, §18 | written before the first commit |

Not shown, because nothing in this project needed them yet: `NEXT-WORK.md`, `MOVING-TO-ANOTHER-MACHINE.md`,
`claude-setup/`, topic, integration, deliverable and ledger folders, `reference/`, `snapshots/`, `secrets/` and the
vault. The standard adds a folder only when its first real file arrives.

## Check it yourself

```bash
python3 -I example/acme-shop/workspace/tools/check-links.py example/acme-shop/workspace
example/acme-shop/workspace/tools/scan-secrets.sh --self-test
example/acme-shop/workspace/tools/scan-secrets.sh example
```
