# Claude Code Workspace Standard

A written standard for keeping **everything about a project that is not code** in one trustworthy folder, so that a
Claude Code session can pick the project up after a compaction, a restart or a machine move without the owner
explaining it again.

It was distilled from several long-running workspaces kept with Claude Code: products in production, shared build
servers, and several sessions working at once. Every rule names the failure it prevents.

## Use it

Give your agent one line:

> Read `WORKSPACE-STANDARD.md` and set up a workspace for `<project>` at `<path>`.

The standard is self-contained. The agent needs nothing else, apart from your own preferences (language, timezone,
commit identity), which it reads from your `CLAUDE.md` or memory, or asks you for (§0.1).

## What is here

| path | what it is |
| --- | --- |
| [`WORKSPACE-STANDARD.md`](WORKSPACE-STANDARD.md) | the standard: layout, document kinds, rules, secrets, git, Claude memory, multi-session work, a bootstrap procedure, a verification checklist and copy-ready templates |
| [`example/`](example/README.md) | a fully worked, fictional workspace (`acme-shop`) after its first three days, mapped rule by rule to the standard |

## The ideas in one screen

1. **Answer in a file, then summarise in chat.** A chat window is not memory.
2. **Registers vs records.** A register says what is true now: undated, edited in place, and checked against
   reality. A record says what happened: dated, and never rewritten.
3. **Every number carries its date and the command that measured it.** "I could not check this" is an entry, not a
   silence.
4. **Before you believe a number, ask which result would have been impossible.** A check that cannot fail proves
   nothing.
5. **Link, never copy**, anything a code repository owns.
6. **Secrets never land in the workspace in plaintext.** Ask for access, not secrets. Git history is permanent.
7. **Several sessions, one checkout:** commit with `git commit --only <paths>`. Shared memory directories get
   appends, not rewrites.

```
workspace/
├── README.md  RESUME-HERE.md  NEEDS-A-PERSON.md  THIS-MACHINE.md   ← registers, read first
├── records/<date>/                                                  ← what happened; never rewritten
├── reports/<date>-<topic>/{README.md, evidence/}                    ← investigations behind decisions
├── servers/<name>-<ip>/                                             ← what we may and may not do on each machine
├── tools/                                                           ← scripts that outlive a session
└── claude-memory/                                                   ← a copy of Claude's memory, so it travels
```

## License

[MIT](LICENSE).
