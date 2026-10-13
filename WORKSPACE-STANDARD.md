# Workspace Standard

**How to build, fill and keep a project workspace with Claude Code.** Version 2.1, 2026-10-13.

This document is self-contained. An agent that reads it can set up and keep a workspace for a new project without
seeing any other project. It was distilled from several long-running workspaces kept with Claude Code in 2026. They
covered products in production, shared build servers, and several sessions working at once. Every rule names the
failure it prevents, because most of those failures have already happened once.

A complete worked example lives in [`example/acme-shop/workspace/`](example/acme-shop/workspace/README.md).

---

## 0. How to use this document

**Owner:** give the agent one line, for example:

> Read `<path>/WORKSPACE-STANDARD.md` and set up a workspace for `<project>` at `<path>`.

**Agent:**

1. Read this whole file before creating anything.
2. Read the **owner profile** (§0.1).
3. Follow the procedure in [§16](#16-bootstrap-procedure).
4. Ask the owner only what you cannot find yourself, and never in a way that blocks (§12).
5. Write everything into files first. Summarise in chat afterwards.

Where this standard and a project's own repository disagree, **the repository wins** for anything about its code.
This standard governs only the workspace.

### 0.1 The owner profile

Some choices belong to the owner, not to this standard. Look for them in this order:

1. the owner's `CLAUDE.md`;
2. Claude's memory;
3. a local wrapper file the owner points you to.

**The profile outranks this standard's defaults**, and it outranks any identity, trailer or address the harness
proposes. Where the profile is silent, use the default below and confirm it the first time it matters.

| setting | default when the profile is silent |
| --- | --- |
| the language of chat replies to the owner | the language the owner writes in |
| the language of files (registers, records, reports, memory, commits) | professional English |
| **whether the owner's own words may be quoted verbatim in files** | **no**: paraphrase them in the files' language. A file records what was decided, not a transcript of the chat |
| an owner-language summary inside files (a one-line README summary, a section of `NEEDS-A-PERSON.md`) | no; the owner reads summaries in chat |
| timezone for every timestamp | ask; state it in every timestamp |
| where projects live on disk | ask |
| commit identity, and whether commits carry an AI co-author trailer | ask; record the answer here, and check `git config user.email` before each commit |
| where remotes go, and their default visibility | private, under the owner's account, created only on the owner's word |
| how much is delegated ("decide yourself", "do not ask") and what stays reserved | decide and record (§12); spending, deleting, production writes and deploys stay reserved |
| the owner's stock phrases and what each means (e.g. what "stop safely" requires) | ask once, then record |
| network constraints and vantage points | measure them (§16, step 2) |

### 0.2 Make it yours: a private personal layer

This standard is generic on purpose. Personalise it by keeping your own choices in **a private repository of your
own** (for example `workspace-private`), never by editing this file:

```
workspace-private/                 ← private; yours
├── README.md                      how a new project uses it
├── OWNER-PROFILE.md               §0.1 filled in: language, timezone, git identity, delegation, stock phrases, network
├── memory-seeds/owner-profile.md  a memory note installed in every new project, so sessions follow the profile untold
├── servers/                       machines you reuse across projects, and what any project may do there
└── tools/                         personal tools you reuse across projects
```

Then keep **one local entry file**, outside both repositories, that you hand to an agent. It points to your profile
first and to this standard second. The profile outranks the standard's defaults; the standard stays shareable; and a
new project inherits your preferences through the memory seed.

- **What does not belong there:** a project's own facts (they live in that project's workspace), and any project that
  must stay unlinked from you, if the private repository sits under your real-name account.
- **The template** is `OWNER-PROFILE.md` in §18.

---

## 1. What a workspace is, and what it is not

A workspace is a plain folder, **separate from the code repositories**, that holds **everything about a project that
is not code**:

| holds | why it needs a home outside the code |
| --- | --- |
| **what is true now**: state, decisions, what is running where | a chat window is not memory; a compaction deletes it |
| **what is still open**: decisions owed by a person, work owed | an unrecorded question gets asked again, and the owner pays twice |
| **facts about the machines**: servers, the laptop, the network | no repository owns them |
| **the reason behind a guard**: the dated incident a rule exists to prevent | a step whose story is forgotten gets deleted for being slow |
| **investigations and their evidence** | a conclusion must not outlive the evidence for it |

It is **not** a second copy of the documentation. Specs, plans, ADRs, runbooks and `CLAUDE.md` live in the
repository, next to the code they describe, and are reviewed there. The workspace **links** to them by branch and
path and never copies them, because a copy goes stale silently. **Code does not live in the workspace either:** a
Dockerfile or deploy script "not yet copied into the repo" belongs in a branch, not here.

> **The core habit: answer in a file, then summarise in chat. Never the other way round.**

---

## 2. Where it lives

**Preferred:** a project root that holds the repositories and the workspace side by side. Sessions start in the
project root.

```
<project-root>/                 ← sessions start here; Claude's memory is keyed to this path (§10)
├── workspace/                  ← this standard
├── <repo-a>/                   ← code repositories, cloned; never moved once they exist
└── <repo-b>/
```

**When the code repository already is the project root:** put the workspace inside it as `workspace-<project>/`. Make
it **its own git repository**, and hide it from the code repository with `.git/info/exclude`. That file is local and
never committed, so the two histories cannot mix. For the same reason a fresh clone does not have it: re-create it on
every new machine (§5, **Resuming on another machine**; §9).

**Never move a repository or the project root to make room.** Repository paths appear in memory files, shell history
and tool configuration. Claude's memory folder is named after the directory sessions start in, so moving it silently
starts a new, empty memory (§10).

---

## 3. The layout

Start with the minimal set. Add a folder only when its first real file arrives. Empty scaffolding is noise that
looks like information.

```
workspace/
├── README.md               register · what this folder is, THE read order, where each kind of file belongs, rules
├── RESUME-HERE.md          register · the entry point: standing facts, state, running now, next steps, traps
├── NEEDS-A-PERSON.md       register · what only a human can do or decide, and what was decided under delegation
├── THIS-MACHINE.md         register · the laptop: paths, versions, network quirks, and the changes we made to it
├── .gitignore              guards secrets before the first commit
├── records/<YYYY-MM-DD>/   history · what happened or was measured; never moved, never rewritten
├── reports/<YYYY-MM-DD>-<topic>/
│   ├── README.md           the verdict, citing evidence by file
│   └── evidence/           raw outputs: agent results, fetched pages, scripts, measurements
├── servers/<name>-<ip>/    one folder per machine: what it is, who owns it, what we may do there
├── tools/                  scripts used to work on the project, each with a usage line
└── claude-memory/          a COPY of the Claude memory, so it travels with the workspace
```

**Added when needed:**

| path | add it when | purpose |
| --- | --- | --- |
| `DEPLOYED-NOW.md` | something runs in production | what runs where right now; one row per thing, each with the command that measured it, and a re-measure block (§5) |
| `NEXT-WORK.md` | owed work outgrows a section of `RESUME-HERE.md` | the queue, counted from every source (§5) |
| `MOVING-TO-ANOTHER-MACHINE.md` | the project must survive losing the laptop | what travels, what does not, what must be re-established by hand. A how-to, so it holds no snapshot of state |
| `claude-setup/` | the project relies on Claude Code settings, hooks, skills or plugins beyond the defaults | a scrubbed copy of the Claude Code setup (§10) |
| `<topic>/` | one subject outgrows a report | a topic register named for the question it answers (§6) |
| `connecting-<a>-to-<b>/` | two systems with different repositories or owners exchange data | the register for that seam (§6) |
| `deliverables/` | people outside the agent loop need a document | handouts with an edition and a staleness rule (§6) |
| `ledgers/<YYYY-MM-DD>-<run>/` | agent runs produce briefs, reports and reviews | what one run produced, indexed (§6) |
| `lessons/` or `WHAT-WENT-WRONG.md` | the traps outgrow a screen of `RESUME-HERE.md` | one lesson per file, or one catalogue of incidents sorted by cost |
| `reference/<topic>/` | there are runbooks or external documents to read | how to do things; external docs, meeting notes, brand files |
| `deploy/` | there is a release route | facts about deploying, subordinate to the repository's runbooks |
| `snapshots/` | there are restore points or transfer bundles | point-in-time copies; nothing in it is live |
| `secrets/` | a credential must exist on disk | `chmod 700`, git-ignored, never read into a chat (§8) |
| `scratch/` | tools produce output | output, not input; safe to delete without asking; git-ignored |
| `<units>/<slug>/` | the project has parallel units (shops, apps, bots, regional sites) | one folder per unit, so their settings and results never mix |

**One home per kind.** The owner's answers, meetings, move guides and memory copies each have exactly one place. A
second home for the same kind is where the newer copy hides from the reader.

---

## 4. The kinds of document

Every file is exactly one of these. Choosing the kind decides where the file goes and how it may change.

| kind | says | where | rule | the failure it prevents |
| --- | --- | --- | --- | --- |
| **register** | what is true **now** | top level or a topic README; **never dated** in the name | edited in place; checked against reality; one owner; a size budget (§5) | a reader trusting a file whose name promises currency after nobody updated it |
| **record** | what **happened** or was **measured** at a moment | `records/<YYYY-MM-DD>/` | **never moved, never rewritten.** A correction is a new record that names the old one | a later tidy-up rewriting what was actually known when a decision was taken |
| **report** | an **investigation** behind a decision | `reports/<YYYY-MM-DD>-<topic>/` | `README.md` holds the verdict and cites `evidence/` by file | a conclusion surviving after its evidence is lost |
| **runbook** | **how** to do a thing | `reference/<topic>/`, `deploy/` or a topic folder | links into repositories; never pastes their commands; holds no state | somebody following an instruction at 2 a.m. into a path that moved |
| **server** | one **machine** | `servers/<name>-<ip>/` | what it is, who owns it, what this project may and may not do there, dated surveys | an agent doing something on a machine it was never cleared for |
| **deliverable** | a document for **people outside the agent loop** | `deliverables/` | carries an edition, a date, the commit it describes and a staleness rule; Markdown is canonical | a handout that drifts from the system with nobody noticing |
| **ledger** | what **one agent run** produced | `ledgers/<date>-<run>/` | written by the run, never edited afterwards; indexed | the run's work being impossible to find or resume |
| **tool** | a **script** | `tools/` | a usage line at the top; listed in `tools/README.md` | a working script dying with the session scratchpad it lived in |

**A dated file cannot be current, and a register nobody updates is a record wearing a register's name.** That is more
dangerous than a plainly stale file, because its name invites trust.

### Every file says what it is

Each file opens, right after its title, with a one-line header. It states the kind, the owner (for a register), when
it was last checked against reality, and **what wins when it disagrees with reality**:

```markdown
**Kind:** register · **Owned by:** the shop session · **Last checked:** 2026-10-03 19:05 +0330 · If this disagrees with
the server, the server is right: re-measure.
```

### Names

- **Folders and files:** lowercase ASCII words joined by hyphens, named for the question they answer
  (`touching-the-database/`, never `checks/trust-pass-0915/`). Registers keep their upper-case names
  (`RESUME-HERE.md`).
- **No spaces,** and no names that differ only by case.
- **ISO dates** (`2026-10-11`), never a local calendar alone.
- **Records** are named by type when the type recurs (`STOPPED-1315.md`, `RULINGS.md`, `RUN-<name>-ARGS.json`).
  Add the time when a type repeats in a day, and never repeat the date the folder already gives.

---

## 5. The registers

**Budget.** A register fits on about two screens. `RESUME-HERE.md` stays under about 150 lines. A session that adds a
block deletes or archives an older one **in the same edit**, and moves its lasting facts into a record. A register
that needs to say "the newest block wins" has become a log. *In one real workspace, the entry point grew to 2,379
lines with 85 blocks, and its "Last updated" line was eleven days older than its newest block.*

**Each fact about the present lives in exactly one place.** A change updates the row it changes. It does not prepend
a paragraph above a table it leaves alone, and it does not leave an old section under a heading that still says
"right now".

**Retiring a register is a move, not a banner.**

1. `git mv` it to `records/<last-true-date>/`.
2. Add one line saying what replaced it.
3. In the same commit, repoint every link to it from live documents, memory, `CLAUDE.md` files and agent briefs
   (§7, "a move is finished…").

*A file bannered "HISTORY, NOT GUIDANCE" was still the README's "look here first" link, and was read as current.*

### `README.md`

- What the folder is, in one paragraph.
- **The read order**, as a numbered table. **Only the README holds it**; other files link to it and never repeat it.
  A second reading list drifts from the first.
- Where each kind of file belongs: §4, adapted.
- The rules: §8, §9 and any project-specific ones, each with its reason.
- Where the folder sits: its path, its git status and its remote.
- An owner-language summary only if the profile asks for one (§0.1).

### `RESUME-HERE.md`: the entry point

Read first after a compaction, a restart or a machine move. It holds:

- **The header:** owner, last checked against reality (date, time, timezone), and the commands that checked it.
- **Standing facts:** the few facts that outrank everything below ("production holds real customer data"), each
  with **the event that would end it**. When one ends, put a dated banner at the top of every register it affects
  saying what it revokes. Every earlier claim about risk has then expired until it is re-checked.
- **Where the project stands:** the phase, the direction, and what was decided, each linked to its record.
- **Running now:** every live workflow run or background loop. *Delete the section when nothing runs.*
  - **Its full launch arguments, saved to a file when it starts** (`records/<date>/RUN-<name>-ARGS.json`). A resume id
    without its arguments cannot restart anything: *the printed resume line of one real run failed at once.*
  - **Whether it is alive,** judged from its newest agent transcript's modification time and the time you read it,
    never from a ledger's last line. *Ledgers that "looked like work in progress" had been dead for six hours.*
  - **Where it writes:** the file or folder its result lands in. A session can end at any moment (a usage limit, a
    shutdown), and a missing result is only noticed if its place was written down.
- **Next, in order:** numbered and checkable, each with a size.
- **Traps that already cost something:** short, dated, each with the rule it produced. When they outgrow a screen,
  move them to `lessons/` or `WHAT-WENT-WRONG.md`.

Newest block first. **Do not tick; delete.** When several sessions work on the project, each role keeps its own
`<ROLE>-RESUME-HERE.md`, and the bare `RESUME-HERE.md` becomes an index of the role files (§11).

**A stop is a record.** When work stops, write `records/<date>/STOPPED-<HHMM>.md`. It lists:

- what is at rest;
- what was mid-flight, with its relaunch arguments;
- uncommitted work, saved as a patch inside the workspace;
- each worktree's branch, head and unpushed count, for **every related repository** (code, workspace, private
  layer), with stashes and branches that exist only locally;
- every file that matters and lives outside git, with where its backup is;
- whether work may resume on its own, or only on the owner's word;
- a checked "nothing else is running".

A stop record newer than `RESUME-HERE.md` wins over it. A run stopped on purpose is **relaunched with a written
account of what was decided since**, not replayed: a cached replay restores what the agents returned, not what a
person decided in between.

**A machine move is planned for, not improvised.** `RESUME-HERE.md` keeps a short **Resuming on another machine**
block. It says what to clone and where, which toolchain to install, and to run `tools/sync-claude-memory.sh
to-claude`. It names the local entry file (§0.2) and every file that matters and lives outside git, each with its
backup or the source to re-create it from. Secrets are never copied; the block says where each one is re-created.
Before the old machine is switched off, git-ignored folders worth keeping are copied into the workspace. A run's
ledger kept inside a code repository is the usual example. The block also lists every ignore rule that lives only on
the old machine (`.git/info/exclude`, a global excludes file), because a fresh clone has none of them (§9).

### `NEEDS-A-PERSON.md`

What no agent can decide or verify. **"I could not check this" is an entry, not a silence.** Structure:

1. **A reason legend:**
   - **business decision**;
   - **owner's account**;
   - **owner's call by rule**: spending, publishing, deploying, merging, pushing, deleting, and **changing the owner's
     machine** (shell profile, global git config, `~/.claude`);
   - **needs a network or device the agent lacks**.
2. **Open:** `# | item | reason | since`. Two kinds of row are marked as such:
   - a **provisional** row is a decision adopted under delegation that the owner should confirm. It states the answer
     adopted, the alternative, and the cost of reversing it;
   - a **reminder** row is a "remind me" from the owner. It gives the trigger, and a dated line each time it was
     raised.
3. **Decided under delegation:** `# | decision | reason | cost to reverse | date`, under a line recording the
   delegation and what it excludes (§12).
4. **Closed:** `item | outcome | date`. Record the owner's answer as the profile allows: paraphrased by default
   (§0.1).

Numbers are never reused, and a closed item moves to Closed rather than being deleted. Group by item, never by release
or by day: *a section headed by one release stayed "open" through ten later releases.*

### `THIS-MACHINE.md`

The laptop **as a description, not a standard**: OS, toolchain versions and where each lives, paths, the VPN and what
it breaks, and quirks. **Every row is measured and carries the command.** On another machine, re-measure; do not
inherit.

It ends with **Changes we made here**: every local patch to a plugin or dependency, and every daemon, hook, cron job
or shell-profile edit we installed. Each entry carries its date, path, reason, **a command that shows it is still in
place**, the undo, and when it comes off. *A plugin patch that stopped about 1 TB of SSD writes is silently dropped
by the plugin's next update, and only a check catches that.*

### `DEPLOYED-NOW.md` (when something runs)

- One row per running thing: the machine, the version or commit, since when, and **the command that measured it**.
- A row older than a few days is re-measured before it is believed.
- The file ends with `## How to re-measure`, which refreshes every row in one run. Its "measured" date moves only when
  that block was run whole.
- A deploy record is true of a moment, so it is the wrong source for "what is running".

*One real file had 29 "Before that:" paragraphs above a table nobody updated, and gave two answers to "what is in
production".*

### `NEXT-WORK.md` (when the queue outgrows `RESUME-HERE.md`)

**Count what remains from every source, not from what was touched recently.** The sources are:

- unfinished plan tasks;
- in-flight register items;
- the repository's open issues;
- decision records still marked "Proposed", because a decision taken but not built is invisible from the plans.

The count carries its date and the commit it was taken against. Each item carries its size and the risk it removes.
An item that will never be done is deleted, with a line in its source saying it was declined. *A "table of six items"
given to the owner left out three whole features.*

---

## 6. Records, reports, servers, and the other folders

### Records: `records/<YYYY-MM-DD>/<what>.md`

One file per event or measurement. Its links stay as they were when written: a stale link inside a record is the
policy working, not a defect. Each record says:

- **what was asked or what happened**, with the owner's words recorded as the profile allows;
- **what was run**: the commands, workflow run ids, durations;
- **the numbers**, each with the command and the time;
- **what was verified and what was not**;
- **the outcome**, and **what would change the answer**, so a settled question stays settled.

### Reports: `reports/<YYYY-MM-DD>-<topic>/`

- `README.md`: the question, then the **verdict first**, then the reasons, the numbers, what is uncertain, an index of
  the evidence, and the method.
- `evidence/`: everything the verdict rests on, unchanged. That covers structured agent results, fetched pages with an
  `index.tsv` of URL → question, measurement output, and the scripts or workflow files that produced them.
- **Later questions about the same investigation** go into a dated appendix of the same `README.md`, with their own
  evidence subfolder, plus a record on that day.

### Servers: `servers/<name>-<ip>/README.md`

- **What it is:** provider, location, its **ssh alias**, how to reach it (`user@ip`, and the key's name, never the
  key itself).
- **Who owns it**, and **what else runs there**.
- **What this project may do there**, as an explicit yes/no list. *Example: a server that is production for another
  business may be used for read-only outbound fetches and nothing else.*
- **Known behaviour**, dated. *Example: "rate-limits new SSH connections: six parallel connections → port 22 refused
  for ~60 s."*
- **A change log:** every change made on the machine gets a dated line here, with its undo.

**`servers/README.md` is the list for any operation on "every machine"** (key rotation, access review, patching), not
`~/.ssh/config` or shell history. *A key rotation scoped to "the hosts in `~/.ssh/config`" locked a team out of the
box holding its production backups for sixteen hours, because that box had no config entry.*

### Topic folders: `<topic>/`

Add one when a subject outgrows a single report. Name it for the question it answers, in the words a newcomer would
search for. Its `README.md` is a register: it carries a last-checked line and a `file | kind | what it holds` table.
Its dated material goes in `records/<date>/` and is linked from there. When the topic ends, the README's first line
says so.

### Integration folders: `connecting-<a>-to-<b>/`

Add one when two systems with different repositories or owners exchange data. Its README is the register for the
seam. It records:

- what runs where;
- who owns each side, and what this project may do in the other side's repository (often: read, and file issues);
- a table of **where the authority lives**, naming the file in each repository that decides each subject. Where they
  disagree, this folder is wrong.

### Deliverables: `deliverables/`

Documents for people outside the agent loop (staff guides, functional references, handouts), in their readers'
language. Each one carries:

- an edition and a date;
- the commit it describes;
- a staleness rule ("if the screen disagrees, the screen is right");
- a row in `README.md`.

**The Markdown is canonical.** An export (PDF, DOCX) is generated from it by a recorded command, named with its
edition, and never changes without its source. *A 1.7 MB PDF sat beside its source in git, unlinked and unversioned,
while the system it described moved on by 32 database migrations.*

### Ledgers: `ledgers/<YYYY-MM-DD>-<run>/`

What one agent run produced: briefs, reports, reviews and the run's progress file, all inside the run's folder.
Written by the run and never edited afterwards. `ledgers/README.md` has one row per run: run id, branch or pull
request, outcome. Screenshots go in only when a verdict cites them. *In one workspace, ledgers grew to 3,158 files
(89% of the folder) with 8 of 87 runs indexed.*

**Before a ledger is deleted, read the record extracted from it.** A search that matched nothing writes an empty
record, and the only copy is then gone. *One run's rulings came back empty from a search after their ledger had been
deleted; they were rebuilt from the conversation.*

### Units: `<units>/<slug>/`

When a project has parallel units (shops, apps, bots, regional sites), give each its own folder. It holds:

- what the unit is;
- its public handle;
- its repository;
- its configuration, described in prose;
- dated sub-records of results (`campaigns/<date>-<name>.md`), measured from the platform's own statistics.

**Never file one unit's facts under another.**

### Tools: `tools/`

Scripts that outlive a session: fetchers, checkers, the memory sync and the secret scan.

- Each has a usage comment near the top and a row in `tools/README.md` (`script | usage | what it does`).
- A tool that touches a remote machine states in its header what it may and may not do there.
- A tool that opens SSH connections uses **one multiplexed connection** (`ControlMaster auto`, `ControlPersist`).
- A reusable script is born in `tools/`, never inside a dated record folder with a hard-coded path back to it.

### Runbooks for irreversible operations

A runbook for a production data change, a DNS change or a money operation:

- opens with **"This file authorises nothing"**: the owner's word for this change is the authority, and a method that
  makes a change safe does not make it wanted;
- maps what each object really is **by what reads it**, never by its name. *A table named like a disposable inbox was
  a de-duplication ledger, and deleting it undid itself within a minute;*
- carries a guarded template that is idempotent, checks its own result before committing, and says what to do if it
  fails half-way (read before starting);
- keeps a dated table of past runs.

---

## 7. Rules for every entry

1. **Answer in a file, then summarise in chat.** A measurement not written down has to be re-taken.
2. **Every number and time comes from a command run at the time**, and carries its date and timezone. Never from
   memory.
3. **Say what was not checked.** "Not verified: X, because Y" is required content, not an admission.
4. **Before you believe a number, ask which result would have been impossible.** A test that cannot fail proves
   nothing when it passes, and a count that cannot come back clean proves nothing when it comes back dirty.
   *Example: a broken-link count taken from `git archive`, which omits ignored files, so links to them could never
   resolve.*
5. **A zero has two meanings:** "it is not there" and "you did not look where it is". Write the path and the commit
   searched (`git -C <dir> log -1 --format=%h`) beside any "not found". *A claim was nearly reported as false from a
   checkout 34 commits behind `main`.*
6. **A command written into a document is first run outside the agent's shell**, by absolute path (`/usr/bin/grep`)
   or from a script. The agent's shell may wrap tools: in Claude Code, `grep` can be a bundled `ugrep` with features
   the system `grep` lacks. *A plan wrote a PCRE `grep -P` into five steps that failed for every other reader.*
7. **A settled question stays settled.** Record the measurement **and what would change the answer**.
8. **Every guard names the incident that produced it.** A rule without its story gets removed for being slow.
9. **Link, never copy**, anything a repository owns.
10. **Record the owner's words as the profile allows** (§0.1): paraphrased in the files' language by default.
11. **Done is deleted, not ticked**, in registers and queues. History belongs in records.
12. **A register is only as good as the moment it was last checked against the thing it describes.** Put that date
    in it.
13. **Compare like with like.** A before/after measured with a different method on each side is a method change
    dressed as an improvement.
14. **Work dies with the place it was written.** Session scratchpads go at reboot. Git-ignored files inside a worktree
    go with `git worktree remove`. A plan in `~/.claude/plans/` does not outlive its session. Copy whatever supports a
    conclusion into the workspace when it is written. Before removing a worktree, list its ignored files minus build
    output: anything left exists nowhere else.
15. **A move is finished when nothing that instructs a session still names the old path.** Grep the live memory,
    every `CLAUDE.md`, skills, agent briefs and scripts, and fix each link's visible text as well as its target. *A
    folder dissolved on one day had 28 new entries two weeks later, because a memory note still sent sessions there.*

---

## 8. Secrets and personal data

**Git history is permanent.** A file committed once stays in every clone after it is deleted. So the guards come
before the first commit.

**Plaintext**
- **No secret in plaintext anywhere in the workspace.** That covers passwords, API keys, bot tokens, wallet seeds,
  session strings, private keys, `.env` files and database dumps. Write **where** a secret lives, never its value:
  "the API token is in `/etc/<app>/env` on `<server>`, written by the owner".

**Ask for access, not secrets**
- Never ask the owner to paste a credential into chat, because a chat keeps a transcript. Use instead:
  - a key in `~/.ssh`;
  - `~/.pgpass` with mode 600;
  - an env file the owner writes on the host;
  - `gh secret set`, which reads from stdin.
- **Never generate a replacement credential yourself.**

**Claude Code's own settings are a secret store**
- `settings.json` can hold a live token in `env`.
- Every "allow always" writes **the whole approved command** into `permissions.allow`, passwords included.
- So approve command shapes (`Bash(gh pr *)`), never a command with a credential in it. Review both settings files
  before any copy of them leaves `~/.claude/`.

**Scanning**
- **Scan by pattern, and print counts only.** `tools/scan-secrets.sh` (§18) lists files and match counts, never the
  matching text. *A "masking" command that printed matching lines leaked a live SMS API key into a transcript.*
- **Match whole token families, not the prefix you remember:** `gh[pousr]_`, `github_pat_`, `xox[abprs]-`, `sk-`,
  `AKIA`, `AIza`, private-key headers, bot tokens, passwords handed to `sshpass` on a command line. *A scan without
  `gho_` reported a live token as clean.* Keep the patterns tight too: a bare `sk-` matches "disk-full", and a scan
  that always fires gets ignored.
- **Prove the scan can fail** (`tools/scan-secrets.sh --self-test`) before trusting a clean result.

**When a secret leaks**
- **A secret that reached a transcript is rotated, not redacted.** A live session's transcript must not be edited,
  and "was it seen?" can no longer be answered.
- Record where copies sit at rest, by count, and open an urgent `NEEDS-A-PERSON` item.

**`secrets/` and the vault**
- **`secrets/`, when a secret must exist on disk:** `chmod 700`, git-ignored, never read through a pipe or heredoc
  into the transcript.
- **The vault, when secrets must travel with the workspace:** one encrypted bundle, never per-file, because file names
  alone reveal which credentials exist.

  ```bash
  tar -czf /tmp/vault.tar.gz secrets snapshots
  gpg --batch --yes --symmetric --cipher-algo AES256 --digest-algo SHA512 \
      --s2k-mode 3 --s2k-count 65011712 -o vault.tar.gz.gpg /tmp/vault.tar.gz
  rm -f /tmp/vault.tar.gz
  # PROVE the round-trip before committing: decrypt to a temp file, compare `shasum -a 256`.
  ```

  The owner holds the passphrase. It is never written anywhere in the repository and never asked for in chat. A
  ZipCrypto "password-protected zip" is not protection: it falls to a known-plaintext attack.

**Personal data**
- **Personal data** (customers, staff, phone numbers, national ids) does not go into a repository, even encrypted.
  Permanence and personal data are a bad combination; use a backup system.
- **Scan for it in the project's own formats** (`tools/personal-data.patterns`) before the first commit and before
  pushing agent-written folders. Agents do not stop to ask whether a number is somebody's. *One workspace held 86
  distinct phone-number-shaped strings in 192 tracked files, and one in a file name.*
- **Before `git init`, look for files that say they must stay outside version control**, and ignore them first. *Two
  files that said "deliberately outside git" were committed when their folder became a repository.*

---

## 9. Git and the remote

- **The workspace is its own git repository**, private unless the owner says otherwise. Creating the remote,
  choosing the account and pushing are **the owner's call**. Record the answer in `NEEDS-A-PERSON.md` → Closed.
- **Commit identity comes from the owner profile** (§0.1), and it outranks any identity or trailer the harness
  proposes. For a pseudonymous project, ask (§13).
- **Stage explicit paths only.** Never `git add -A`, `git add .`, `git add -u` or `git commit -a`.
- **When another session may share the checkout, commit with `git commit --only <paths> -F <msgfile>`.**
  `git add <file>` followed by `git commit` writes the **whole shared index**. *743 of another session's staged
  renames were swept into an unrelated commit, though only named files had been added.*
- **If a commit sweeps in a peer's files, do not revert or reset.** Tell them at once, with the commit id, the file
  count and which files are theirs.
- **Before every push:** run `tools/sync-claude-memory.sh to-workspace`, `tools/check-links.py` and
  `tools/scan-secrets.sh .`.
- **Moves are renames** (`git mv`), and relative links are fixed in the same commit, so `git log --follow` survives.
- **A rewritten history gets an old → new hash map as a record.** Records citing old hashes are not edited.
- **An ignore rule that lives on one machine does not travel.** `.git/info/exclude`, a global `core.excludesfile`,
  and a self-ignoring `.gitignore` that a tool writes inside its own folder are all absent from a fresh clone. A
  folder restored there by hand from a backup comes back unguarded. So every folder a tool writes run state into
  inside a repository (agent ledgers, review packages, a local server's session files) gets its line in that
  repository's **committed** `.gitignore`. *After a machine move, a run ledger that had been "git-ignored" was due to
  be re-created by hand from its backup. Its only guard was a `.gitignore` its tool wrote inside the ledger folder,
  and a sibling tool folder that holds a session key had no guard at all.*

---

## 10. Claude memory and the Claude setup

### Where memory lives

- Claude Code keeps a project's memory at `~/.claude/projects/<encoded-cwd>/memory/`. `<encoded-cwd>` is the
  directory sessions start in, with every character outside `A–Z a–z 0–9` replaced by `-`. For example,
  `/Users/you/projects/acme` becomes `-Users-you-projects-acme`, and `/x/.claude` becomes `-x--claude`. The sync
  script derives this path (§18). **Verify it with `ls ~/.claude/projects/`** rather than trusting the rule.
- **Moving that directory starts a new, empty memory** and orphans the old one. After a move, read each orphaned file
  and record whether it was carried over, and if not, why.

### Shared memory

- **Sessions started in the same directory share one memory directory.** It has no history, so a whole-file rewrite
  by one session silently wins over another's append. Append; do not regenerate a memory file.

### The memory copy

- **The live folder is the source of truth.** `workspace/claude-memory/` is a **copy**, refreshed by
  `tools/sync-claude-memory.sh`.
- `to-workspace` copies `*.md` only. It **refuses an empty or missing live folder** (it would empty the copy), and it
  lists any file `MEMORY.md` does not index. A memory folder collects downloads and copied documents, and the copy
  would commit them.
- `to-claude` **refuses when the live folder already has files**: restoring onto a machine that still has its memory
  replaces newer facts with older ones.
- Never edit the copy. Keep a `README-THIS-IS-A-COPY.md` in it.

### How a memory note is written

**One lesson per file.** Its frontmatter carries three fields:

- `name`;
- a one-line `description` that **states the rule**, which the index shows;
- `type`.

The body gives the dated incident first, then `**Why:**` and `**How to apply:**`, then `[[links]]` to related lessons.
`MEMORY.md` holds one line per file. **A correction is appended under the old text, with its date**; how the
understanding moved is part of the lesson.

**Memory and the workspace hold different things.** Memory holds what a future session needs in order to *behave*
correctly: the owner's preferences, constraints, and pointers into the workspace. The workspace holds the facts.

### The Claude Code setup: `claude-setup/`

`~/.claude/` is what Claude Code actually reads, and it is in no repository, so a new machine starts from nothing.
When the project relies on more than the defaults, keep a scrubbed **copy** in `claude-setup/`:

- **What it copies:**
  - both settings files, scrubbed of tokens and of credential-bearing allow-list entries (§8);
  - `hooks/`;
  - hand-installed `skills/` (they load only from `~/.claude/skills/`; a copy under `reference/` never loads).
- **`PLUGINS.md`.** It lists, for each plugin:
  - its real source repository, read from the marketplace manifest;
  - its reinstall command;
  - the hooks it registers.

  It also lists every plugin **kept off by verdict**, with its record, and every local patch, with the command that
  shows whether an update reverted it.
- **`capture.sh`** scrubs, scans its own output, and refuses on a hit.
- **`restore.sh`** refuses to overwrite an existing file.
- **Never carried:** transcripts, plugin caches, and other projects' memory. Memory has its own copy.

---

## 11. Several sessions, several projects

**Roles and reading**
- **Name sessions by role** ("the shop session"), never by session name, which changes on restart.
- **One `RESUME-HERE` per session role** (`SHOP-RESUME-HERE.md`, `CRM-RESUME-HERE.md`) when two or more sessions work
  in the same workspace. No role keeps the bare `RESUME-HERE.md`: it becomes a short index, one row per role file,
  with its owner and last update. **README's read order names every role file.** *One role's entry point was
  unreachable from the README for weeks.*

**Commitments and authority**
- **"I am clear of the workspace" is a commitment, not a status report.** Once another session acts on it, going back
  in needs a new message first.
- **Permission does not travel between sessions.** The owner's word for a production write, a deploy or a deletion
  counts only in the session it was given to. A peer relaying it is a reason to ask, not authority.
- **A peer's proposed selection** (ids, rows, files) **is re-derived independently, and the counts must agree,
  before anyone acts on it.** *A peer's proposed rule would have deleted the one real sale.*

**Shared resources and shared files**
- **Shared machine resources get a named lock or slot, recorded on that machine's page.** That covers the laptop's
  disk, a local container VM and a shared build server. Global cleanups (prune, VM restart) run only inside the lock,
  or after every peer says it is clear. *One session's prune, run after it released the lock, took another session's
  containers.*
- **A file that binds several sessions says who may change it**: who drafted it, who agreed and when, and whether the
  owner approved it. A change is announced to the other sessions first. **Change a method between runs, never during
  one**: a finding goes into a dated trial log and is applied at the next boundary.

**Several projects**
- **Split a folder by project only when the second project's material arrives** (`deploy/shop/`, `deploy/crm/`), as
  subfolders, never as file-name prefixes. Nesting a single-project folder buys nothing.
- **Never file cross-project knowledge under one project.** Put what is true of both at the folder's top, for example
  `deploy/LAWS.md`. Otherwise it is invisible on the day the other project needs it.
- **Never assume one project's fact holds for another.** Write the difference down as a table.

---

## 12. Working with the owner

- **Never block on the owner.** A question waits in `NEEDS-A-PERSON.md`, never in a blocking prompt. A blocking
  question stops the whole session, not just the decision. *A blocking question asked while the owner was away froze
  a session for hours: a release cut was missed and a second piece of work never started.*
- **When the owner is away or has said "decide yourself", decide.** Write each ruling as
  `Ruling: <what> — <why> — <cost if wrong>`, in the day's record and in **Decided under delegation**. List it in
  `RESUME-HERE.md` for their return, and carry on. Hold only what they explicitly reserved. Put any hold or freeze into
  the automated run's own arguments, because a freeze stated only in chat does not stop a run.
- **A class of decision the owner hands over for good becomes a standing method file**, with thresholds, so later
  cases are logged and reported as facts, not asked again.
- **Stock phrases mean what the owner says they mean.** Record each one in the profile (§0.1) the first time it is
  explained. *A phrase that sounds like "stop now" can mean "list what is running, with the minutes to its next safe
  point, and ask". Reading it literally once cut a review's fix round, and its work was repeated.*
- **The owner's machine is the owner's.** Editing a shell profile, global git config or `~/.claude` needs their word.
  Record the workaround per command in `THIS-MACHINE.md` instead.

---

## 13. Pseudonymous projects

Some projects must not be linkable to the owner, for example a publication run under a pen name. Then:

- **Nothing the project publishes** carries the owner's real name, phone number, e-mail, company, domain or
  identifiable servers. That covers content, profiles, ad accounts and public repositories.
- **Nothing about the project is published or shared** (pages, gists, public repositories) unless the owner asks;
  write to the workspace.
- **Never host the project's infrastructure on a server tied to an identifiable business**, even when it is
  convenient. Record this as a "may not" on that server's page.
- **The git remote's account and the commit identity are open questions** (`NEEDS-A-PERSON.md`). The owner's usual
  account may carry their real name. Do not create a remote or push until they are answered.
- **Name every identity-linking step** the project forces (ID checks on payment platforms, card payments, phone
  numbers) as a decision for the owner, with the trade-off stated.

---

## 14. Sharing: a pack, never the workspace

When the owner asks to share what the workspace knows, **build a pack; never share the workspace itself**:

1. Build it in a new folder, from copies, **with no git history**.
2. Map each address, name and account to **one placeholder, used everywhere**. Use the RFC 5737 documentation ranges
   for addresses and `example.com` for domains.
3. Replace settings files with illustrative examples.
4. Write `MANIFEST.md`. It lists every file, its source path and what changed, plus a table of what was left out and
   why.
5. Run the secret and personal-data scans on the pack, proving first that they can fail.

*Building one such pack is what found that a settings allow-list held whole commands with plaintext passwords.*

---

## 15. Language

The owner profile decides (§0.1). By default:

- **Files are in professional English**: registers, records, reports, memory, commits, tools, and the short
  descriptions of commands.
- **Chat replies to the owner are in the owner's language.** Check before sending that the prose really is in it.
- **The owner's own words are paraphrased in files**, not quoted, unless the profile allows quoting.
- **Product text stays verbatim in its own language**: UI labels, error messages, and terms with no clean English
  equivalent (glossed).
- **A folder that is in another language on purpose**, such as acceptance stories walked in front of a UI in that
  language, says so in its README and is pinned to the build it describes. Do not "correct" it into English.

---

## 16. Bootstrap procedure

Follow these steps in order. Steps 1–3 are read-only.

1. **Establish the facts.** Find them yourself where possible, and ask only what you cannot find, without blocking
   (§12):
   - the project root and the repositories (local paths, remotes);
   - the servers, and for each: who owns it, what else runs there, what this project may do there;
   - whether the project is pseudonymous (§13);
   - whether the workspace gets a git remote now, and under which account (default: local only, and ask);
   - the owner profile settings that are missing (§0.1);
   - existing material scattered elsewhere: chat, session scratchpads, `~/.claude/plans/`, worktrees, other
     workspaces, old folders.
2. **Measure the machine** for `THIS-MACHINE.md`: OS version, toolchain versions, the network's exit point
   (`curl -s https://ipinfo.io/json`), and the relevant paths and keys (names only). Record the time.
3. **Find the memory directory** (`ls ~/.claude/projects/`) and read its `MEMORY.md`.
4. **Create the minimal layout** (§3), writing **`.gitignore` first** (§18).
5. **Move material in; don't leave it scattered.**
   - Copy outputs that support conclusions into `reports/<date>-<topic>/evidence/`.
   - Copy reusable scripts into `tools/`.
   - Never copy secrets; record where they live instead.
   - Link to old project folders rather than copying them.
6. **Write the registers** from the facts measured in steps 1–5, each with its kind header (§4).
7. **Write a record** for the day the workspace was created.
8. **Install the tools** (§18). Run `tools/scan-secrets.sh --self-test`. Update the memory (one lesson per file, and a
   pointer in `MEMORY.md`) so future sessions know the workspace exists. Then run
   `tools/sync-claude-memory.sh to-workspace`.
9. **Verify** everything in §17.
10. **Git:** run `git init` and make the first commit only if the owner has agreed (§9). Create a remote only on the
    owner's word.
11. **Report in chat:** a short summary, the tree, the entry point and the open questions. The detail stays in the
    files.

---

## 17. Verification checklist

Run each item; do not assume it. Run commands from a script or by absolute path (§7, rule 6).

- [ ] `python3 -I tools/check-links.py` reports **0 broken** in live documents. Prove the checker can fail by running
      it once on a sample with a known broken link.
- [ ] `tools/scan-secrets.sh --self-test` passes, then `tools/scan-secrets.sh .` reports nothing. Read any hits under
      `evidence/` by eye: third-party pages can match.
- [ ] If the workspace is a git repository, `git status --ignored` shows that nothing under `secrets/` and no `.env`,
      key, dump or `.ovpn` file is tracked or staged.
- [ ] Every register has its kind header and is within budget: `wc -l RESUME-HERE.md` under about 150. The newest
      date inside `RESUME-HERE.md` equals its "last checked".
- [ ] No live document links to a retired file. Grep the retired file's name.
- [ ] Every tool runs from its new location (one real invocation each).
- [ ] `tools/sync-claude-memory.sh to-workspace` prints `done` with the path it used, and that path exists under
      `~/.claude/projects/`.
- [ ] Every open question from the session is in `NEEDS-A-PERSON.md`, numbered, with a reason. Every decision taken
      under delegation is in its table.
- [ ] Before a stop or a machine move, check every related repository: nothing uncommitted, unpushed, stashed or
      only local. Every file that lives outside git is listed under **Resuming on another machine** with its backup.
- [ ] After cloning on a new machine, `git status --short --ignored` in every related repository shows each tool's
      run folder and any nested workspace as ignored (`!!`), not untracked (`??`).

---

## 18. Templates

Copy each template, then replace every `<…>` and delete the guidance comments. The
[example workspace](example/acme-shop/workspace/README.md) shows them filled in.

### `OWNER-PROFILE.md` (in your private layer, §0.2)

````markdown
# Owner profile

**Kind:** register · **Owned by:** <you> · **Last checked:** <YYYY-MM-DD> · Fills §0.1 of the Workspace Standard and
outranks its defaults. A later instruction from you outranks this file: update it.

## Language
| | rule |
| --- | --- |
| chat replies | <language; how to check it before sending> |
| command and agent descriptions | <language> |
| files | <language and register, e.g. professional English from the first draft> |
| your own words in files | <paraphrased in the files' language / quoted verbatim> |
| text that stays verbatim | <product text: UI labels, error messages, glossed terms> |

## Time and place
| | |
| --- | --- |
| timezone | <e.g. +0330> |
| projects root | <path>; sessions start in the project root |

## Git and GitHub
| | |
| --- | --- |
| commit identity | <name> <email>, set per clone; checked before each commit |
| AI trailers | <none / allowed> |
| remotes | <private, under <account>, created only on your word> |
| pseudonymous projects | <which account; never mentioned in this repository> |

## Working with you
- **Delegation:** <what "decide yourself" covers; what stays reserved: spending, deleting, production writes, deploys>
- **When you are away:** <ask nothing; decide, record, continue>
- **Stock phrases:** <phrase → what it means>
- **Your machine:** <what needs your word before it is changed>

## Network
- <VPN, exit country, what refuses it; vantage points and their rules>
````

### `.gitignore`

```gitignore
# What must never reach a remote, and why.
# Git history is permanent: a file committed once stays in every clone even after it is deleted.
# So the guard has to be here, before the first commit, rather than in anybody's habits.

# 1 · Credentials and anything shaped like a key.
secrets/
*.zip
*.pem
*.key
*.p12
*.ovpn
*.session
*.session-journal
id_ed25519*
id_rsa*
.env
.env.*
*.dump
*.sql
*.sql.gz
*.gpg
!vault.tar.gz.gpg

# 2 · Output, not input. Safe to delete at any time.
scratch/

# 3 · macOS
.DS_Store
```

### `README.md`

````markdown
# workspace: everything about <project> that is not code

**Kind:** register · **Owned by:** <session role> · **Last checked:** <YYYY-MM-DD HH:MM timezone>

<One paragraph: who asked for this folder and when, what it holds, and what it was scattered across before.>

## New here? Read in this order

| | file | what it answers |
| --- | --- | --- |
| 1 | [`RESUME-HERE.md`](RESUME-HERE.md) | **The entry point.** Where the project stands and what comes next |
| 2 | [`NEEDS-A-PERSON.md`](NEEDS-A-PERSON.md) | What only the owner can do or decide; what was decided under delegation |
| 3 | [`THIS-MACHINE.md`](THIS-MACHINE.md) | The laptop: paths, versions, the network, the changes we made |
| 4 | [`servers/`](servers/README.md) | Every server, and what this project may do there |

## Where a file belongs

<The table from WORKSPACE-STANDARD.md §4, keeping only the rows this project uses.>

## Rules

1. **No secret ever lands here in plaintext.** Name where a secret lives instead.
2. **Stage explicit paths.** Never `git add -A`, `git add .` or `git commit -a`.
3. <Project-specific rules, each with the incident or reason behind it.>

## Where this folder sits

`<absolute path>`. <Git: "its own repository, remote `<owner>/<name>`, private, since <date>" OR "not a git
repository yet; see NEEDS-A-PERSON #<n>".> The code repositories are `<paths>`; this folder links to them and never
copies them.
````

### `RESUME-HERE.md`

````markdown
# Resume here

**Kind:** register · **Owned by:** <session role> · **Last checked against reality:** <YYYY-MM-DD HH:MM timezone>, by
<the commands run> · Budget: about 150 lines; adding a block means archiving an older one.

## Standing facts

- <fact that outranks everything below> — **ends when:** <event>.

## Where the project stands

<Phase in one line. Decisions so far, each linked to its record.>

## Running now

<!-- Delete this section when nothing runs. -->

| run | what it is doing | started | newest transcript mtime (checked at) | args file | writes to | resume call |
| --- | --- | --- | --- | --- | --- | --- |

## Resuming on another machine

1. Clone <repositories> side by side under <folder>. Install <toolchain>. Run `tools/sync-claude-memory.sh to-claude`.
2. Lives outside git: <path>: <why>. Its backup is <where>, or re-create it from <source>. Secrets: re-create
   each from <where>.

## Next, in order

1. <checkable step> — size: <estimate>

## Traps that already cost something

- **<date>: <what went wrong>.** Rule: <the rule>. See `<record or lesson>`.
````

### `NEEDS-A-PERSON.md`

````markdown
# Needs a person

**Kind:** register · **Owned by:** <session role> · **Last checked:** <YYYY-MM-DD HH:MM timezone>

Things no agent can decide or verify. Each item says **why**, so it is clear who can unblock it.

| reason | why it blocks an agent |
| --- | --- |
| **business decision** | the answer is the owner's choice about money, law, product or direction |
| **owner's account** | it needs a registration, a payment or a login that only the owner holds |
| **owner's call by rule** | spending, publishing, deploying, merging, pushing, deleting, changing the owner's machine |
| **needs a network or device** | <e.g. the laptop's VPN exits abroad and some sites refuse it> |

<!-- Only if the owner profile asks for it: a summary in the owner's language, numbered like the table below. -->

## Open

| # | item | reason | since |
| --- | --- | --- | --- |
| 1 | **<item>** <context>. <For a provisional row: "Provisional: adopted <answer>; alternative <…>; cost to reverse <…>". For a reminder: "Reminder: raise at <trigger>; raised <dates>".> | <reason> | <date> |

## Decided under delegation

<The delegation, recorded as the profile allows, with its date and what it excludes.>

| # | decision | reason | cost to reverse | date |
| --- | --- | --- | --- | --- |

## Closed

| item | outcome | date |
| --- | --- | --- |
````

### `THIS-MACHINE.md`

````markdown
# This machine

**Kind:** register · **Measured:** <YYYY-MM-DD HH:MM timezone> · A description, not a standard: re-measure before
trusting a row.

| | value | measured with |
| --- | --- | --- |
| OS | <version> | `sw_vers -productVersion` |
| <tool> | <version, location> | `<command>` |
| network exit | <country, ASN> | `curl -s https://ipinfo.io/json` |

**Paths:** <workspace, repositories, memory directory>

**Quirks:** <each one dated, with its consequence, e.g. "a failed fetch from here is not evidence a service is down">

## Changes we made here

| date | what | where | why | still in place? | undo | comes off |
| --- | --- | --- | --- | --- | --- | --- |
````

### `DEPLOYED-NOW.md`

````markdown
# Deployed now

**Kind:** register · **Measured:** <YYYY-MM-DD HH:MM timezone>, by running "How to re-measure" whole · A row older
than a few days is re-measured before it is believed. If this disagrees with the machine, the machine is right.

| machine | what | version | since | measured with |
| --- | --- | --- | --- | --- |

## How to re-measure

```bash
<one block that refreshes every row above>
```
````

### `servers/<name>-<ip>/README.md`

````markdown
# <name> (<ip>)

**Kind:** server · **Last surveyed:** <YYYY-MM-DD> · ssh alias `<alias>`

**What it is:** <provider, location>, `ssh <user>@<ip>` with `<key name>`. <What else runs there; who owns it.>

## What this project may do there

- **Yes:** <explicit list>
- **No:** <explicit list, each with its reason>

## Known behaviour

- <dated observation, with how it was measured>

## Change log

| date | change | undo |
| --- | --- | --- |
````

### `reports/<date>-<topic>/README.md`

````markdown
# <report title>

**Kind:** report · **Date:** <YYYY-MM-DD> · A report, not a decision; the decision is NEEDS-A-PERSON #<n>.

## Question
## Verdict
<numbered; the first thing the reader sees>
## Why
<reasons, each with its source or evidence file>
## Numbers
<tables; every number with its source and date>
## What is uncertain
## Evidence
| file | contents |
| --- | --- |
## Method
<what ran: agents, run ids, tools; what failed and how it was worked around>
````

### `records/<date>/<event>.md`

````markdown
# <YYYY-MM-DD>: <event>

**Kind:** record · never rewritten; a correction is a new record that links this one.

**What was asked / what happened:** <recorded as the owner profile allows>
**What was run:** <commands, run ids, durations>
**Numbers:** <each with command and time>
**Verified vs not:** <explicit>
**Outcome:** <and what would change it>
````

### `tools/sync-claude-memory.sh`

```zsh
#!/bin/zsh
# Usage: tools/sync-claude-memory.sh to-workspace | to-claude
#   to-workspace  copy the live Claude memory (*.md only) into claude-memory/ (run before a commit)
#   to-claude     restore claude-memory/ into the live memory folder (on a new machine, into an empty folder only)
# The live folder is derived from the project root (this workspace's parent), the directory sessions start in.
# If sessions start elsewhere, set CLAUDE_MEMORY_DIR. Verify the printed path with: ls ~/.claude/projects/
set -eu
HERE=${0:A:h:h}
ROOT=${HERE:h}
LIVE=${CLAUDE_MEMORY_DIR:-$HOME/.claude/projects/${ROOT//[^A-Za-z0-9]/-}/memory}
COPY="$HERE/claude-memory"
case "${1:-}" in
  to-workspace)
    if [[ ! -f $LIVE/MEMORY.md ]]; then
      echo "refusing: no MEMORY.md in $LIVE; a sync from an empty or wrong folder would empty the copy" >&2; exit 1
    fi
    if ! "$HERE/tools/scan-secrets.sh" "$LIVE" >/dev/null; then
      echo "refusing: something key-shaped is in the live memory; run tools/scan-secrets.sh $LIVE" >&2; exit 1
    fi
    for f in $LIVE/*(N.:t); do
      [[ $f == *.md ]] || { echo "skipped, not memory: $f" >&2; continue; }
      [[ $f == MEMORY.md ]] || grep -qF "($f)" "$LIVE/MEMORY.md" || echo "note: $f is not indexed in MEMORY.md" >&2
    done
    mkdir -p "$COPY"
    rsync -a --delete --exclude 'README-THIS-IS-A-COPY.md' --include '*.md' --exclude '*' "$LIVE/" "$COPY/" ;;
  to-claude)
    if [[ -d $LIVE && -n $(ls -A "$LIVE") ]]; then
      echo "refusing: $LIVE already has files; restoring would replace newer memory. Move them aside first." >&2; exit 1
    fi
    mkdir -p "$LIVE"; rsync -a --exclude 'README-THIS-IS-A-COPY.md' "$COPY/" "$LIVE/" ;;
  *) echo "usage: $0 to-workspace | to-claude" >&2; exit 2 ;;
esac
echo "done: $1 ($LIVE)"
```

### `tools/scan-secrets.sh`

```bash
#!/bin/bash
# Usage: tools/scan-secrets.sh <path>...     list files holding something key-shaped, as "<file>: <count>"; exit 1 if any
#        tools/scan-secrets.sh --self-test    prove the scan can fail: plant fakes in a temp dir, expect each caught
# Prints counts only, never the matching text: a "masking" step that prints matching lines is how a key reaches a
# transcript. Project-specific personal-data patterns (phone numbers, national ids, e-mails) go in
# tools/personal-data.patterns, one extended regex per line; blank lines and # comments are ignored.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
KEYS='(^|[^A-Za-z0-9])(sk-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|xox[abprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35})|BEGIN [A-Z ]*PRIVATE KEY|[0-9]{8,10}:[A-Za-z0-9_-]{35}|sshpass[[:space:]]+-p|password[[:space:]]*[:=][[:space:]]*[^[:space:]]{6,}'
EXTRA=$(mktemp); trap 'rm -rf "$EXTRA" ${T:+"$T"}' EXIT
grep -vE '^[[:space:]]*(#|$)' "$HERE/personal-data.patterns" > "$EXTRA" 2>/dev/null || true

count() {
  local n m=0
  n=$(grep -cIE -e "$KEYS" -- "$1" 2>/dev/null) || n=0
  if [ -s "$EXTRA" ]; then m=$(grep -cIEf "$EXTRA" -- "$1" 2>/dev/null) || m=0; fi
  echo $(( n + m ))
}

scan() {
  local hits=0 f n
  while IFS= read -r -d '' f; do
    n=$(count "$f")
    if [ "$n" -gt 0 ]; then echo "$f: $n"; hits=$((hits + 1)); fi
  done < <(find "$@" -type f -not -path '*/.git/*' -print0)
  [ "$hits" -eq 0 ]
}

if [ "${1:-}" = "--self-test" ]; then
  T=$(mktemp -d)
  # The fakes are assembled at run time, so this script never matches its own scan.
  s=sk; g=gh; x=xo; a=AK; z=AI; b=BEG; p=pass; t='123456789:'
  printf '%s\n' "KEY=${s}-proj-AbCdEfGhIjKlMnOpQrStUvWx123" > "$T/1"
  printf '%s\n' "${g}o_AbCdEfGhIjKlMnOpQrStUvWxYz0123456789" > "$T/2"
  printf '%s\n' "${x}xb-1234567890-abcdefghijkl" > "$T/3"
  printf '%s\n' "${a}IAABCDEFGHIJKLMNOP" > "$T/4"
  printf '%s\n' "${z}zaSyAbCdEfGhIjKlMnOpQrStUvWxYz0123456" > "$T/5"
  printf '%s\n' "-----${b}IN OPENSSH PRIVATE KEY-----" > "$T/6"
  printf '%s\n' "${t}AAEhBP0av28dAAAAAAAAAAAAAAAAAAAAAAA" > "$T/7"
  printf '%s\n' "ssh${p} -p hunter22x ssh root@host" > "$T/8"
  printf '%s\n' "db ${p}word = hunter22x" > "$T/9"
  printf '%s\n' "checkout-slow-disk-full; the task-runner; gh_pages; ask-me" > "$T/clean"
  out=$(scan "$T"); ok=1
  for i in 1 2 3 4 5 6 7 8 9; do
    printf '%s\n' "$out" | grep -q "/$i: " || { echo "self-test: fake $i was NOT caught" >&2; ok=0; }
  done
  if printf '%s\n' "$out" | grep -q '/clean: '; then echo "self-test: a clean file was flagged" >&2; ok=0; fi
  [ "$ok" -eq 1 ] && { echo "self-test: 9/9 fakes caught, clean file passed"; exit 0; }
  exit 1
fi

[ $# -ge 1 ] || { echo "usage: $0 <path>... | --self-test" >&2; exit 2; }
for p in "$@"; do  # a scan of a path that does not exist must fail, not report "clean"
  [ -e "$p" ] || { echo "no such path: $p" >&2; exit 2; }
done
scan "$@"
```

### `tools/check-links.py`

````python
#!/usr/bin/env python3
"""Usage: python3 -I tools/check-links.py [workspace_dir]
Reports relative markdown links that do not resolve, in live documents only.
Scope: records/, evidence/, scratch/ and claude-memory/ are skipped (frozen or copies); fenced and inline code are
stripped; links are keyed by path, not basename; links leaving the workspace are reported separately.
Exit code 1 if anything inside the workspace is broken."""
import os, re, sys

root = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), '..'))
FENCE = re.compile(r'^(```|~~~).*?^\1', re.S | re.M)
INLINE = re.compile(r'`[^`\n]*`')
LINK = re.compile(r'\]\(([^)\s#]+)(?:#[^)]*)?\)')
broken, outside = [], []
for dirpath, dirnames, filenames in os.walk(root):
    parts = os.path.relpath(dirpath, root).split(os.sep)
    if parts[0] in ('records', '.git', 'scratch', 'claude-memory') or 'evidence' in parts:
        dirnames[:] = []; continue
    for name in filenames:
        if not name.endswith('.md'): continue
        path = os.path.join(dirpath, name)
        text = INLINE.sub('', FENCE.sub('', open(path, encoding='utf-8').read()))
        for target in LINK.findall(text):
            if re.match(r'^[a-z]+:', target): continue
            resolved = os.path.normpath(os.path.join(dirpath, target))
            where = (os.path.relpath(path, root), target)
            if not resolved.startswith(root + os.sep) and resolved != root:
                outside.append(where + (os.path.exists(resolved),))
            elif not os.path.exists(resolved):
                broken.append(where)
for f, t in broken: print(f'BROKEN   {f} -> {t}')
for f, t, ok in outside: print(f'OUTSIDE  {f} -> {t} ({"exists" if ok else "missing"})')
print(f'broken: {len(broken)}  outside-workspace: {len(outside)}')
sys.exit(1 if broken else 0)
````

---

## 19. Anti-patterns

| don't | because |
| --- | --- |
| answer in chat and "write it up later" | the compaction comes first |
| let a register keep every update, with "the newest block wins" | it becomes a log nobody reads, with stale "now" sections under live headings |
| prepend history above a table you leave alone | the file then gives two answers to the same question |
| banner a file as retired but leave the links to it | it keeps being read as current |
| keep a second reading list (in a move guide, a memory note) | it drifts from the README's |
| name a folder after a day's activity (`checks/trust-pass-0915/`) | nobody looking for "how we build" opens it, and every citation points at the wrong name |
| dissolve a folder without fixing what instructs sessions | it grows back with new entries |
| tick done items | the register fills with history; delete them, and keep history in records |
| copy a runbook, a command or a plan out of a repository | the copy goes stale silently |
| stage code in the workspace "until it is copied into the repo" | it is unreviewed and drifts from the real code |
| rewrite or move a record to tidy up | it rewrites what was known when a decision was taken |
| put dated files outside `records/`, or keep a second records tree | history scatters, and nobody can find what happened when |
| report a number without its command and time | nobody can re-check it |
| compare a before and an after measured by different methods | a method change dressed as an improvement |
| `git add -A` / `git commit -a` in a shared checkout | it sweeps in other sessions' work |
| put a credential in a file here "just temporarily" | history is permanent |
| "mask" a secret with a command that prints the matching lines | the mask is how it leaks |
| ask a blocking question while the owner is away | the whole session stops, not just the decision |
| open many SSH connections in parallel to one server | rate limits lock you out; use one multiplexed connection |
| commit binary exports and screenshots by default | the repository grows by hundreds of megabytes of files no verdict cites |
| paths with spaces, or names that differ only by case | scripts and links break on them |
| create empty scaffolding folders "for later" | structure without content looks like information |
| delete a source after extracting a record from it, without reading the record | an empty search result becomes an empty record, and the only copy is gone |
| leave a git-ignored run folder only on the laptop | when the machine goes, the run's rulings go with it |
| keep a tool's run folder out of git only through `.git/info/exclude` or the tool's own self-ignoring `.gitignore` | neither survives a clone, and the folder restored by hand is unguarded |

---

## 20. Changelog

When a rule here turns out wrong, change it, add a dated line below, and record the incident that changed it.

| date | change |
| --- | --- |
| 2026-10-11 | version 1 |
| 2026-10-11 | version 2: after a full review of one long-running workspace (4,559 files) and its method pack, against v1. **Fixed:** the memory sync could overwrite newer memory and could empty the copy; the secret scan missed whole token families and printed nothing to prove it could fail; quoting the owner verbatim is now a profile setting, default paraphrase. **Added:** register budgets and kind headers; one place per present fact; retiring by move; standing facts; run arguments, liveness and stop records; queue counted from every source; working with the owner (never block, rulings under delegation); multi-session authority and shared-resource locks; topic, integration, deliverable and ledger folders; irreversible-operation runbooks; Claude settings as a secret store and `claude-setup/`; memory-lesson format; personal-data scans; sharing as a pack; `scan-secrets.sh` |
| 2026-10-11 | §0.2: personalise through a private personal layer (profile, memory seed, shared servers, personal tools) and one local entry file, never by editing the standard; an `OWNER-PROFILE.md` template in §18 |
| 2026-10-13 | version 2.1. **Added:** where a run writes, because a session can end at any moment; stop records that cover every related repository and the files outside git, and say whether resuming needs the owner; a planned machine move (**Resuming on another machine**); reading an extract before deleting its source; two anti-patterns |
| 2026-10-13 | §2, §5, §9, §17, §19: an ignore rule that lives on one machine (`.git/info/exclude`, a global excludes file, a tool's self-ignoring `.gitignore`) does not travel with a clone. Tool run folders inside a repository are ignored in its committed `.gitignore`; the machine-move block lists the local-only rules; a checklist item proves it after a clone. Found in a review after a machine move |
