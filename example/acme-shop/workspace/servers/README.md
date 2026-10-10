# Servers

**Kind:** register · **Owned by:** the shop session · **Last checked:** 2026-10-03 19:05 +0330

Every machine this project touches, and what it may be used for. One folder per machine: `<name>-<ip>/`. **This list
is the scope for any operation on "every machine"** (key rotation, access review, patching), not `~/.ssh/config`.

| name | ssh alias | where | role for this project | may host project infrastructure? |
| --- | --- | --- | --- | --- |
| [`prod`](prod-203.0.113.10/README.md) | `prod` | the owner's country | production: the shop and its database | **Yes**, it is the shop's own server |
| [`build`](build-198.51.100.20/README.md) | `build` | abroad | builds images; shared with another project | **No**: builds only |
