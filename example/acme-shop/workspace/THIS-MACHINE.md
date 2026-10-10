# This machine

The laptop the work is driven from. **A description, not a standard.** Measured 2026-10-01 10:20 +0330; re-measure
before trusting a row.

| | value | measured with |
| --- | --- | --- |
| macOS | 26.6.2, arm64 | `sw_vers -productVersion; uname -m` |
| git | 2.50.1 | `git --version` |
| gh | 2.97.0, logged in as the owner | `gh --version; gh auth status` |
| Docker | Docker Desktop 4.48 | `docker version --format '{{.Client.Version}}'` |
| python3 | 3.9.6 (system); the code repository pins its own runtime | `python3 --version` |
| network exit | abroad, through a VPN that is always on | `curl -s https://ipinfo.io/json` |
| ssh key | `~/.ssh/id_ed25519` (opens `prod` and `build`) | `ls ~/.ssh` |

**Paths**

- Code: `~/projects/acme-shop/acme-shop`
- This workspace: `~/projects/acme-shop/workspace`
- Claude memory: `~/.claude/projects/-Users-you-projects-acme-shop/memory`

**Quirks**

- **The VPN exit is abroad.** The payment gateway's sandbox refuses it (`000` from here, `200` from `prod`, 2026-10-01).
  A failed fetch from this laptop is not evidence that a service is down. Check from `prod`, read-only.
