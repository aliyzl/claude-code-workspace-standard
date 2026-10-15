# Claude Code Workspace Standard

After `/compact`, a restart or a new laptop, a Claude Code session has forgotten what was decided, what is running
and what is still open.

This standard keeps **everything about a project that is not code** in one plain folder beside the code: what is true
now, what happened, what waits for a person, and the machines involved. Each kind of file has one place and one rule
for how it changes, so a fresh session can trust what it reads. It is Markdown and three small scripts: nothing to
install, nothing running.

**Without it,** a fresh session rebuilds the picture from `git log` and guesses, and you explain the project again.
**With it,** the session opens `RESUME-HERE.md` and carries on. From the [worked example](example/README.md),
shortened:

```markdown
## Where the shop stands
**Live since 2026-09-28, release v1.4.2, checkout open.**
- 2026-10-03: checkout was slow for ~40 minutes because the production disk filled with logs. Fixed (12 GB freed);
  PRs #31 (log rotation) and #32 (a health check that writes) make it hold.

## Next, in order
1. Owner decides the backup destination (NEEDS-A-PERSON.md #1). Size: half a day, plus a restore drill.
2. PR #31 and #32 need one review each, then the owner's merge. Size: an hour.
```

## Try it in a minute

From your project's root folder, copy the [starter](starter/README.md) into `workspace/`:

```bash
mkdir workspace && curl -sL https://github.com/aliyzl/claude-code-workspace-standard/archive/refs/heads/main.tar.gz | tar -xz -C workspace --strip-components=2 claude-code-workspace-standard-main/starter
```

`mkdir` refuses if `workspace/` already exists, so nothing is overwritten. You get the minimal set of §3: four
registers with placeholders, a `.gitignore` written before the first commit, the three tools and the memory copy's
README. Check that the tools work:

```bash
workspace/tools/scan-secrets.sh --self-test     # self-test: 9/9 fakes caught, clean file passed
python3 -I workspace/tools/check-links.py workspace   # broken: 0  outside-workspace: 0
```

Then, in Claude Code, started in the same root folder:

> Read https://raw.githubusercontent.com/aliyzl/claude-code-workspace-standard/main/WORKSPACE-STANDARD.md, then fill
> in `workspace/` for this project by following §16. Remember that the workspace is at `workspace/` and that a new
> session starts at `workspace/RESUME-HERE.md`.

The last sentence puts a pointer in Claude's memory, so the next session finds the folder without being told.

The tools need `bash`, `python3` (standard library only), and `zsh` and `rsync` for the memory sync. macOS has all
four; on Linux, install `zsh` if you want the memory sync.

To have the agent build the folder from nothing instead, give it one line:

> Read `WORKSPACE-STANDARD.md` and set up a workspace for `<project>` at `<path>`.

The standard is self-contained. The agent needs nothing else, apart from your own preferences (language, timezone,
commit identity), which it reads from your `CLAUDE.md` or memory, or asks you for (§0.1).

## Minimal versus full

Most projects need only the first part. The rest of the standard is for the day a situation arises.

| | what | where in the standard |
| --- | --- | --- |
| **Start with** | `README.md`, `RESUME-HERE.md`, `NEEDS-A-PERSON.md`, `THIS-MACHINE.md`, `.gitignore`, `tools/`, `claude-memory/` (the [starter](starter/README.md)) | §3 |
| | `records/<date>/`, `reports/<date>-<topic>/`, `servers/<name>-<ip>/`, each when its first real file arrives | §3, §6 |
| **Core rules** | the kinds of document: registers say what is true now, records say what happened | §4, §5 |
| | the rules for every entry: dates, commands, what was not checked | §7 |
| | secrets and git: guards before the first commit, explicit paths only | §8, §9 |
| | Claude's memory, and the copy that travels with the workspace | §10 |
| **When you need it** | something runs in production: `DEPLOYED-NOW.md` | §5 |
| | owed work outgrows a section of `RESUME-HERE.md`: `NEXT-WORK.md` | §5 |
| | topic, integration, deliverable, ledger and unit folders; runbooks for irreversible operations | §6 |
| | the project relies on hooks, skills or plugins: `claude-setup/` | §10 |
| | several sessions or several projects in one folder | §11 |
| | the owner is away or has delegated decisions | §12 |
| | a project that must not be linkable to you | §13 |
| | sharing what a workspace knows | §14 |
| | your own preferences across projects: a private personal layer | §0.2 |

§16 is the bootstrap procedure, §17 the verification checklist, §18 the templates and §19 the anti-patterns.

## How it compares

This is a folder discipline, not a tool: no runtime, no dependencies, no service. It works alongside Claude Code's own
mechanisms rather than replacing them.

| | what it is | where it lives | what it is for |
| --- | --- | --- | --- |
| [`CLAUDE.md`](https://code.claude.com/docs/en/memory) | instructions you write; loaded at the start of every session, and the project-root file is re-read after `/compact` | in the code repository, shared through version control | build commands, conventions, project layout, "always do X" rules |
| [Auto memory](https://code.claude.com/docs/en/memory#auto-memory) | notes Claude writes itself; the first 200 lines or 25 KB of `MEMORY.md` load at session start | `~/.claude/projects/<project>/memory/`, machine-local | your preferences and corrections, and pointers to where things are |
| [Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank) (Cline) | a set of context files (`projectbrief.md`, `activeContext.md`, `progress.md` and others) the agent is told to read in full at the start of every task | a `memory-bank/` folder in the project | the project's brief, current focus and progress |
| **this standard** | a workspace with a rule for each kind of file: registers edited in place, records never rewritten, every number with its date and command | a folder beside the code, its own git repository | what is true now, what happened, what waits for a person, the machines, the evidence behind decisions |

How they fit together:

- **`CLAUDE.md` stays in the repository.** The standard says so explicitly (§1): the workspace links to it and never
  copies it. Use both.
- **Auto memory holds pointers; the workspace holds the facts** (§10). Because auto memory is machine-local,
  `tools/sync-claude-memory.sh` keeps a copy inside the workspace so it survives a machine move.
- **A memory bank is the closest relative.** The difference is the discipline around the files: an entry point with a
  size budget, history kept apart from current state in dated records that are never rewritten, a separate list of
  what only a person can decide, and checks for secrets and broken links.

## Make it yours

The standard is generic and meant to be shared. Do not fork it to add your preferences. Keep them in **a private
repository of your own** (for example `workspace-private`): an `OWNER-PROFILE.md` with your language, timezone, git
identity, delegation rules and stock phrases; a memory note that every new project installs on day one; and any
servers and tools you reuse across projects.

Then keep **one local entry file** that points an agent to your profile first and to this standard second. The profile
outranks the standard's defaults, and the standard stays clean for everyone else. §0.2 of the standard explains the
layout, and §18 has the `OWNER-PROFILE.md` template.

## What is here

| path | what it is |
| --- | --- |
| [`WORKSPACE-STANDARD.md`](WORKSPACE-STANDARD.md) | the standard: layout, document kinds, rules, secrets, git, Claude memory, multi-session work, a bootstrap procedure, a verification checklist and copy-ready templates |
| [`starter/`](starter/README.md) | the minimal set from §3 with placeholders, ready to copy into a project |
| [`example/`](example/README.md) | a fully worked, fictional workspace (`acme-shop`) after its first three days, mapped rule by rule to the standard |

## The ideas in one screen

1. **Answer in a file, then summarise in chat.** A chat window is not memory.
2. **Registers vs records.** A register says what is true now: undated, edited in place, checked against reality,
   and short (an entry point that grew to 2,379 lines stopped being read). A record says what happened: dated, and
   never rewritten.
3. **Every number carries its date and the command that measured it.** "I could not check this" is an entry, not a
   silence.
4. **Before you believe a number, ask which result would have been impossible.** A check that cannot fail proves
   nothing, and that applies to your own scans too.
5. **Link, never copy**, anything a code repository owns.
6. **Secrets never land in the workspace in plaintext.** Ask for access, not secrets. Scan by whole token
   family, and print counts, never matches. Git history is permanent.
7. **Never block on the owner.** Questions wait in a file. Decisions taken under delegation are recorded with their
   reason and their cost to reverse.
8. **Several sessions, one checkout:** commit with `git commit --only <paths>`. Permission does not travel between
   sessions. Shared memory directories get appends, not rewrites.

```
workspace/
├── README.md  RESUME-HERE.md  NEEDS-A-PERSON.md  THIS-MACHINE.md   ← registers, read first
├── records/<date>/                                                  ← what happened; never rewritten
├── reports/<date>-<topic>/{README.md, evidence/}                    ← investigations behind decisions
├── servers/<name>-<ip>/                                             ← what we may and may not do on each machine
├── tools/                                                           ← scripts that outlive a session
└── claude-memory/                                                   ← a copy of Claude's memory, so it travels
```

## Where it comes from

It was distilled from several long-running workspaces kept with Claude Code: products in production, shared build
servers, and several sessions working at once. Every rule names the failure it prevents, and the changelog at the end
of the standard records what changed and why. The current version is 2.1.

## License

[MIT](LICENSE).
