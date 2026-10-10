# Servers

Every machine this project touches, and what it may be used for. One folder per machine: `<name>-<ip>/`.

| name | where | role for this project | may host project infrastructure? |
| --- | --- | --- | --- |
| [`prod`](prod-203.0.113.10/README.md) | the owner's country | production: the shop and its database | **Yes**, it is the shop's own server |
| [`build`](build-198.51.100.20/README.md) | abroad | builds images; shared with another project | **No**: builds only |
