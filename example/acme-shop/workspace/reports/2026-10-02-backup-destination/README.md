# Where should the off-site backups go?

**Kind:** report · **Date:** 2026-10-02 · A report, not a decision; the decision is `NEEDS-A-PERSON.md` #1.

## Question

Nightly database backups exist only on `prod`. Where should a second copy live, so that losing that server does not
lose the shop, at a cost the owner accepts?

## Verdict

1. **An S3-compatible bucket abroad**, written nightly by the existing backup script, with object lock for 30 days.
2. **Plus a weekly copy the owner keeps**, downloaded from the bucket, so one provider's account problem cannot erase
   everything.
3. **Not** a second VPS: it costs the most and adds a machine to maintain, for no gain in recovery time at this size.

## Why

- **Upload speed from `prod` is enough for all three.** The nightly dump is 380 MB; the slowest option takes under
  two minutes (`evidence/upload-speed.txt`).
- **The bucket is the cheapest per month** and needs no machine to patch (`evidence/quotes.tsv`).
- **Object lock** stops a compromised `prod`, which holds write credentials, from deleting old backups. The second
  VPS can only match that with extra setup.
- **The weekly owner copy** covers the case none of the others do: losing access to the provider account itself.

## Numbers

| option | upload of 380 MB from `prod` | monthly cost (30 nightly copies) | source |
| --- | --- | --- | --- |
| S3-compatible bucket abroad | 41 s | ~$0.08 (11.4 GB stored at $0.006/GB-month, plus four weekly 380 MB downloads at $0.01/GB) | `evidence/upload-speed.txt`, `evidence/quotes.tsv` |
| second VPS, same provider, other region | 18 s | ~$6.00 | same |
| the owner's home NAS | 1 min 52 s | $0 (already owned) | same |

## What is uncertain

- The bucket provider's price can change; it was read from its public price page on 2026-10-02.
- **Restore time was not measured.** The report compares uploads only. A restore drill is owed after the decision.

## Evidence

| file | contents |
| --- | --- |
| `evidence/upload-speed.txt` | raw output of three timed uploads from `prod`, 2026-10-02 |
| `evidence/quotes.tsv` | prices read from each provider's public page, with URL and date |
| `evidence/measure-upload.sh` | the script that produced `upload-speed.txt` |

## Method

`evidence/measure-upload.sh` ran once per destination from `prod`, at 14:10–14:25 +0330, uploading the same 380 MB
dump. Each command and its timing is in `upload-speed.txt`. Prices were read by hand from the public pages and dated.
