# Workspace Standard

**How to build, fill and keep a project workspace with Claude Code.** Version 1, 2026-10-11.

This document is self-contained. An agent that reads it can set up a workspace for a new project without seeing any
other project. It was distilled from several long-running workspaces kept with Claude Code in 2026, across products,
servers and parallel sessions. Every rule names the failure it prevents, because most of those failures have already
happened once.

A complete worked example lives in [`example/acme-shop/workspace/`](example/acme-shop/workspace/README.md).

---

## 0. How to use this document

**Owner:** give the agent one line, for example:

> Read `<path>/WORKSPACE-STANDARD.md` and set up a workspace for `<project>` at `<path>`.

**Agent:**

1. Read this whole file before creating anything.
2. Read the **owner profile** if one exists (§0.1).
3. Follow the procedure in [§14](#14-bootstrap-procedure).
4. Ask the owner only those questions in §14 step 1 that you cannot answer yourself, one at a time.
5. Write everything into files first. Summarise in chat afterwards.

Where this standard and a project's own repository disagree, **the repository wins** for anything about its code.
This standard governs only the workspace.

### 0.1 The owner profile

Some choices belong to the owner, not to this standard. Look for them in the owner's `CLAUDE.md`, in Claude's memory,
or in a local wrapper file the owner points you to. If none says, ask.

| setting | examples |
| --- | --- |
| the owner's language for summaries and reports | English, Persian |
| timezone for every timestamp | `+0330`, `UTC` |
| where projects live on disk | `~/projects/<project>/` |
| commit identity, and whether commits carry an AI co-author trailer | `name <email>`, no trailer |
| where remotes go, and their default visibility | private, under the owner's account |
| network constraints and vantage points | "the laptop's VPN exits abroad; use server X, read-only, for local sites" |

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

It is **not** a second copy of the documentation. Specs, plans, ADRs, runbooks and `CLAUDE.md` live in the repository
next to the code they describe, and go through review there. The workspace **links** to them by branch and path and
never copies them, because a copy goes stale silently.

> **The core habit: answer in a file, then summarise in chat. Never the other way round.**

---

## 2. Where it lives

**Preferred:** a project root that holds the repositories and the workspace side by side.

```
<project-root>/
├── workspace/                  ← this standard
├── <repo-a>/                   ← code repositories, cloned; never moved once they exist
└── <repo-b>/
```

**When the code repository already is the project root:** put the workspace inside it as `workspace-<project>/`. Make
it **its own git repository**, and hide it from the code repository with `.git/info/exclude`. That file is local and
never committed, so the two histories cannot mix.

**Never move a repository to make room for the workspace.** Repository paths appear in memory files, shell history
and tool configuration, and a moved path breaks all of them.

---

## 3. The layout

Start with the minimal set. Add a folder only when its first real file arrives. Empty scaffolding is noise that
looks like information.

```
workspace/
├── README.md               register · what this folder is, read order, where each kind of file belongs, rules
├── RESUME-HERE.md          register · THE entry point: state, direction, next steps, traps
├── NEEDS-A-PERSON.md       register · decisions and checks only a human can do, each with its reason
├── THIS-MACHINE.md         register · the laptop: paths, versions, network quirks, measured
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
| `DEPLOYED-NOW.md` | something runs in production | what runs where right now; **every row carries the command that measured it** |
| `NEXT-WORK.md` | owed work outgrows a section of `RESUME-HERE.md` | the queue, in order, each item linked to the file that explains it |
| `MOVING-TO-ANOTHER-MACHINE.md` | the project must survive losing the laptop | what travels, what does not, what must be re-established by hand |
| `PLUGINS.md` | the project depends on Claude Code plugins or skills | each plugin, its real source repository, reinstall commands |
| `reference/<topic>/` | there are runbooks or external documents to read | how to do things; external docs, meeting notes, brand files |
| `deploy/` | there is a release route | facts about deploying, subordinate to the repository's runbooks |
| `snapshots/` | there are restore points or transfer bundles | point-in-time copies; nothing in it is live |
| `secrets/` | a credential must exist on disk | `chmod 700`, git-ignored, never read into a chat (§8) |
| `scratch/` | tools produce output | output, not input; safe to delete without asking; git-ignored |
| `<units>/<slug>/` | the project has parallel units (shops, apps, bots, regional sites) | one folder per unit, so their settings and results never mix |

---

## 4. The kinds of document

Every file is exactly one of these. Choosing the kind decides where the file goes and how it may change.

| kind | says | where | rule | the failure it prevents |
| --- | --- | --- | --- | --- |
| **register** | what is true **now** | top level, **never dated** in the name | edited in place; checked against reality; one owner | a reader trusting a file whose name promises currency after nobody updated it |
| **record** | what **happened** or was **measured** at a moment | `records/<YYYY-MM-DD>/` | **never moved, never rewritten.** A correction is a new record that names the old one | a later tidy-up rewriting what was actually known when a decision was taken |
| **report** | an **investigation** behind a decision | `reports/<YYYY-MM-DD>-<topic>/` | `README.md` holds the verdict and cites `evidence/` by file | a conclusion surviving after its evidence is lost |
| **runbook** | **how** to do a thing | `reference/<topic>/` or `deploy/` | links into repositories; never pastes their commands | somebody following an instruction at 2 a.m. into a path that moved |
| **server** | one **machine** | `servers/<name>-<ip>/` | what it is, who owns it, what this project may and may not do there, dated surveys | an agent doing something on a machine it was never cleared for |
| **tool** | a **script** | `tools/` | a usage line at the top; listed in `tools/README.md` | a working script dying with the session scratchpad it lived in |

**A dated file cannot be current, and a register nobody updates is a record wearing a register's name.** It is more
dangerous than a plainly stale file, because its name invites trust.

---

## 5. The registers

### `README.md`

- What the folder is, in one paragraph.
- A **one-line summary for the owner in the owner's language**.
- The read order, as a numbered table.
- Where each kind of file belongs: the table in §4, adapted.
- The rules: §8, §9 and any project-specific ones.
- Where the folder sits: its path, its git status and its remote.

### `RESUME-HERE.md`: the entry point

Read first after a compaction, a restart or a machine move. It holds:

- **Last updated / last checked against reality:** date, time, timezone, and how it was checked.
- **Where the project stands:** phase, direction and what was decided, each linked to its record.
- **Running now:** every live workflow run or background loop, with its resume call, so a dead one is noticed.
  Delete the section when nothing runs.
- **Next, in order:** numbered and checkable.
- **Traps that already cost something:** short, dated, each with the rule it produced.

Newest block first. When a block stops being true, delete it or move its lasting facts into a record. **Do not
tick; delete.** When several sessions work on the project, each session role keeps its own
`<ROLE>-RESUME-HERE.md` (§11).

### `NEEDS-A-PERSON.md`

Things no agent can decide or verify. **"I could not check this" is an entry, not a silence.** Structure:

1. A **reason legend**: business decision · owner's account · owner's call by rule (spending, publishing, deploying,
   merging, pushing, deleting) · needs a network or device the agent lacks.
2. A **summary in the owner's language**, numbered identically to the table.
3. An **Open** table: `# | item | reason | since`.
4. A **Closed** table: `item | outcome | date`, with the owner's answer **quoted verbatim** in their language.

Numbers are never reused. A closed item moves to Closed; it is not deleted.

### `THIS-MACHINE.md`

The laptop **as a description, not a standard**: OS, toolchain versions and where each lives, paths, the VPN and
what it breaks, and quirks. **Every row is measured and carries the command.** On another machine, re-measure; do not
inherit.

### `DEPLOYED-NOW.md` (when something runs)

One row per running thing: machine, version or commit, since when, and **the command that measured it**. The file
says that a row older than a few days must be re-measured before it is believed. A deploy record is true of a moment;
it is the wrong source for "what is running".

---

## 6. Records, reports, servers, units and tools

### Records: `records/<YYYY-MM-DD>/<what>.md`

One file per event or measurement. Its links stay as they were when written: a stale link inside a record is the
policy working, not a defect. Each record says:

- **what was asked or what happened**, with the owner's words quoted verbatim;
- **what was run**: the commands, workflow run ids, durations;
- **the numbers**, each with the command and the time;
- **what was verified and what was not**;
- **the outcome**, and **what would change the answer**, so a settled question stays settled.

### Reports: `reports/<YYYY-MM-DD>-<topic>/`

- `README.md`: the question, then the **verdict first**, then the reasons, the numbers, what is uncertain, an index of
  the evidence, and the method. Written in the language of whoever decides.
- `evidence/`: everything the verdict rests on, unchanged: structured agent results, fetched pages with an
  `index.tsv` of URL → question, measurement output, and the scripts or workflow files that produced them.
- **Later questions about the same investigation** go into a dated appendix section of the same `README.md`, with
  their own evidence subfolder, plus a record in `records/` on that day.

### Servers: `servers/<name>-<ip>/README.md`

- **What it is**: provider, location, how to reach it (`user@ip`, which key: the key's name, never the key).
- **Who owns it**, and **what else runs there**.
- **What this project may do there**, as an explicit yes/no list. *Example: a server that is production for another
  business may be used for read-only outbound fetches and nothing else.*
- **Known behaviour**, dated. *Example: "rate-limits new SSH connections: six parallel connections → port 22 refused
  for ~60 s."*
- `servers/README.md` holds one row per machine, with a "may host project infrastructure?" column.

### Units: `<units>/<slug>/`

When a project has parallel units (shops, apps, bots, regional sites), give each its own folder. It holds:

- what the unit is;
- its public handle;
- its repository;
- its configuration, described in prose;
- dated sub-records of results, for example `campaigns/<date>-<name>.md`, with spend and outcome measured from the
  platform's own statistics.

**Never file one unit's facts under another.**

### Tools: `tools/`

These are scripts that outlive a session: data fetchers, checkers and the memory sync.

- Each script has a usage comment near the top and a row in `tools/README.md` (`script | usage | what it does`).
- A tool that touches a remote machine states in its header what it may and may not do there.
- A tool that opens SSH connections uses **one multiplexed connection** (`ControlMaster auto`, `ControlPersist`).
  Many servers rate-limit new connections.

---

## 7. Rules for every entry

1. **Answer in a file, then summarise in chat.** A measurement not written down has to be re-taken.
2. **Every number and time comes from a command run at the time**, and carries its date and timezone. Never from
   memory.
3. **Say what was not checked.** "Not verified: X, because Y" is required content, not an admission.
4. **Before you believe a number, ask which result would have been impossible.** A test that cannot fail proves
   nothing when it passes, and a count that cannot come back clean proves nothing when it comes back dirty.
   *Example: a broken-link count taken from `git archive`, which omits ignored files, so links to those files could
   never resolve.*
5. **A settled question stays settled.** Record the measurement **and what would change the answer**.
6. **Every guard names the incident that produced it.** A rule without its story gets removed for being slow.
7. **Link, never copy**, anything a repository owns.
8. **Quote the owner verbatim**, in their language, when recording a decision or an instruction.
9. **Done is deleted, not ticked**, in registers and queues. History belongs in records.
10. **A register is only as good as the moment it was last checked against the thing it describes.** Put that date
    in it.
11. **ISO dates in file names** (`2026-10-11`). Owner-facing text may add a local calendar date alongside.
12. **Compare like with like.** A before/after number measured with a different method on each side is a method
    change dressed as an improvement.

---

## 8. Secrets and personal data

**Git history is permanent.** A file committed once stays in every clone after it is deleted. So the guards come
before the first commit.

- **No secret in plaintext anywhere in the workspace.** That covers passwords, API keys, bot tokens, wallet seeds,
  session strings, private keys, `.env` files and database dumps. Write **where** a secret lives, never its value:
  "the API token is in `/etc/<app>/env` on `<server>`, written by the owner".
- **Ask for access, not secrets.** Never ask the owner to paste a credential into chat, because a chat keeps a
  transcript. Use instead:
  - a key in `~/.ssh`;
  - `~/.pgpass` with mode 600;
  - an env file the owner writes on the host;
  - `gh secret set`, which reads from stdin.

  **Never generate a replacement credential yourself.**
- **Assume any tool can print any URL or value it touched.** Mask before reading a mixed file:
  `sed -E 's/(PASSWORD=)[^ ]*/\1***/'`.
- **Use `secrets/` when a secret must exist on disk.** It is `chmod 700` and git-ignored. Never read it through a pipe
  or heredoc into the transcript.
- **Use a vault when secrets must travel with the workspace.** Make it one encrypted bundle, never per-file, because
  file names alone reveal which credentials exist.

  ```bash
  tar -czf /tmp/vault.tar.gz secrets snapshots
  gpg --batch --yes --symmetric --cipher-algo AES256 --digest-algo SHA512 \
      --s2k-mode 3 --s2k-count 65011712 -o vault.tar.gz.gpg /tmp/vault.tar.gz
  rm -f /tmp/vault.tar.gz
  # PROVE the round-trip before committing: decrypt to a temp file, compare `shasum -a 256`.
  ```

  The owner holds the passphrase. It is never written anywhere in the repository and never asked for in chat.
  A ZipCrypto "password-protected zip" is not protection: it falls to a known-plaintext attack.
- **Personal data** (customers, staff, phone numbers) does not go into a repository, even encrypted. Permanence and
  personal data are a bad combination; use a backup system instead.
- **The memory copy is scanned before every sync** for key-shaped strings, and the sync refuses if it finds one
  (§10).

---

## 9. Git and the remote

- **The workspace is its own git repository**, private unless the owner says otherwise. Creating the remote,
  choosing the account and pushing are **the owner's call**. Record the answer in `NEEDS-A-PERSON.md` → Closed.
- **Commit identity** comes from the owner profile (§0.1). For a pseudonymous project, ask (§12).
- **Stage explicit paths only.** Never `git add -A`, `git add .`, `git add -u` or `git commit -a`.
- **When another session may share the checkout, commit with `git commit --only <paths> -F <msgfile>`.**
  `git add <file>` followed by `git commit` writes the **whole shared index**. In one real case, 743 of another
  session's staged renames went into an unrelated commit, even though only named files had been added.
- **Before every push:** run `tools/sync-claude-memory.sh to-workspace`, then `tools/check-links.py`.
- **Moves are renames** (`git mv`), and relative links are fixed in the same commit, so `git log --follow` survives.

---

## 10. Claude memory and its copy

- **Where it lives.** Claude Code keeps a project's memory at `~/.claude/projects/<encoded-cwd>/memory/`.
  `<encoded-cwd>` is the session's working directory with every `/` (and any other non-alphanumeric character)
  replaced by `-`; for example, `/Users/you/projects/acme` becomes `-Users-you-projects-acme`. **Verify with
  `ls ~/.claude/projects/`** rather than trusting the rule.
- **Sessions started in the same directory share one memory directory.** It has no history, so a whole-file rewrite
  by one session silently wins over another's append. **Append, or replace one paragraph; do not regenerate a memory
  file** unless the fact is your own and recent.
- **The live folder is the source of truth.** `workspace/claude-memory/` is a **copy**:
  - refresh it with `tools/sync-claude-memory.sh to-workspace`;
  - restore it on a new machine with `… to-claude`;
  - never edit the copy;
  - keep a `README-THIS-IS-A-COPY.md` in it.
- **Memory and workspace hold different things.** Memory holds what future sessions need in order to *behave*
  correctly: the owner's preferences, constraints, and pointers into the workspace. The workspace holds the facts.

---

## 11. Several sessions, several projects

- **One `RESUME-HERE` per session role** (`SHOP-RESUME-HERE.md`, `CRM-RESUME-HERE.md`) when two or more sessions
  work in the same workspace. A shared register is how one session's half-written files end up in another's commit.
- **"I am clear of the workspace" is a commitment, not a status report.** Once another session acts on it, going back
  in needs a new message first.
- **Split a folder by project only when the second project's material arrives** (`deploy/shop/`, `deploy/crm/`).
  Nesting a single-project folder buys nothing.
- **Never file cross-project knowledge under one project.** Put what is true of both at the folder's top, for
  example `deploy/LAWS.md`. Otherwise it is invisible on the day the other project needs it.
- **Never assume one project's fact holds for another.** Write the difference down as a table.
- **Not every mixture is a filing error.** A meeting record that covers two projects stays whole.

---

## 12. Pseudonymous projects

Some projects must not be linkable to the owner, for example a publication run under a pen name. Then:

- **Nothing the project publishes** carries the owner's real name, phone number, e-mail, company, domain or
  identifiable servers. That covers content, profiles, ad accounts and public repositories.
- **Nothing about the project is published or shared** (pages, gists, public repositories) unless the owner asks;
  write to the workspace.
- **Never host the project's infrastructure on a server tied to an identifiable business**, even when it is
  convenient. Record this as a "may not" on that server's page.
- **Treat the git remote's account and the commit identity as open questions** (`NEEDS-A-PERSON.md`). The owner's
  usual account may carry their real name. Do not create a remote or push until they are answered.
- **Name every identity-linking step** the project forces (ID checks on payment platforms, card payments, phone
  numbers) as a decision for the owner, with the trade-off stated.

---

## 13. Language

- **Registers, records, server pages and tools are in English**, so any agent can work with them.
- **The owner's view is in the owner's language**: the one-line summary in `README.md`, the summary section of
  `NEEDS-A-PERSON.md`, and the reports the owner decides from.
- **The owner's words are quoted verbatim** in the original language, with a paraphrase where it helps.
- **A folder that is in another language on purpose** (for example, user stories walked in front of a UI in that
  language) says so in its README. Do not "correct" it into English.

---

## 14. Bootstrap procedure

Follow these steps in order. Steps 1–3 are read-only.

1. **Establish the facts.** Find them yourself where possible, and ask the owner only what you cannot find, one
   question at a time:
   - the project root path, and the repositories (local paths, remotes);
   - the servers involved, and for each: who owns it, what else runs there, what this project may do there;
   - whether the project is pseudonymous (§12);
   - whether the workspace gets a git remote now, and under which account (default: local only, and ask);
   - the owner profile settings that are missing (§0.1);
   - existing material scattered elsewhere: chat, session scratchpads, other workspaces, old folders.
2. **Measure the machine** for `THIS-MACHINE.md`: OS version, toolchain versions, the network's exit point
   (`curl -s https://ipinfo.io/json`), and the relevant paths and keys (names only). Record the time.
3. **Find the memory directory** (`ls ~/.claude/projects/`) and read its `MEMORY.md`.
4. **Create the minimal layout** (§3), writing **`.gitignore` first** (§16).
5. **Move material in; don't leave it scattered.**
   - Copy scratchpad outputs that support conclusions into `reports/<date>-<topic>/evidence/`.
   - Copy reusable scripts into `tools/`.
   - Never copy secrets; record where they live instead.
   - Link to old project folders rather than copying them.
6. **Write the registers** from the facts measured in steps 1–5: `README.md`, `RESUME-HERE.md`,
   `NEEDS-A-PERSON.md`, `THIS-MACHINE.md`, `servers/…` and `tools/README.md`.
7. **Write a record** for the day the workspace was created, with the owner's request quoted.
8. **Install `tools/sync-claude-memory.sh`** with the correct live path. Then update the memory (append; one fact per
   file; a pointer line in `MEMORY.md`) so future sessions know the workspace exists, and sync the copy.
9. **Verify** everything in §15.
10. **Git:** run `git init` and make the first commit only if the owner has agreed (§9). Create a remote only on the
    owner's word.
11. **Report in chat:** a short summary, the tree, the entry point and the open questions. The detail stays in the
    files.

---

## 15. Verification checklist

Run each item; do not assume it.

- [ ] `python3 -I tools/check-links.py` reports **0 broken** in live documents. Prove that the checker can fail by
      running it once on a sample with a known broken link.
- [ ] If the workspace is a git repository, `git status --ignored` shows that nothing under `secrets/` and no `.env`,
      key, dump or `.ovpn` file is tracked or staged.
- [ ] A secret scan over the whole workspace returns nothing:
      `grep -rIlE '(^|[^A-Za-z0-9])(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|AKIA[0-9A-Z]{16})|BEGIN [A-Z ]*PRIVATE KEY|[0-9]{8,10}:[A-Za-z0-9_-]{35}|password[[:space:]]*[:=][[:space:]]*[^[:space:]]{6,}' .`
      Prove it can fail too: plant a fake key in a temporary file and check that the scan finds it. Keep the pattern
      tight: a bare `sk-` also matches ordinary words such as "disk-full", and a scan that always fires gets ignored.
      Third-party pages under `evidence/` may need reading by eye rather than by pattern.
- [ ] Every tool runs from its new location (one real invocation each).
- [ ] `tools/sync-claude-memory.sh to-workspace` prints `done`, and `claude-memory/MEMORY.md` matches the live one.
- [ ] `RESUME-HERE.md` carries today's date and the time it was checked against reality.
- [ ] Every open question from the session is in `NEEDS-A-PERSON.md`, numbered, with a reason.

---

## 16. Templates

Copy each template, then replace every `<…>` and delete the guidance comments. The
[example workspace](example/acme-shop/workspace/README.md) shows every one of them filled in.

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

<One paragraph: who asked for this folder and when, what it holds, and what it was scattered across before.>

> **For the owner, in one line:** «<one line in the owner's language, ending with: start from RESUME-HERE.md>»

## New here? Read in this order

| | file | what it answers |
| --- | --- | --- |
| 1 | [`RESUME-HERE.md`](RESUME-HERE.md) | **The entry point.** Where the project stands and what comes next |
| 2 | [`NEEDS-A-PERSON.md`](NEEDS-A-PERSON.md) | Decisions only the owner can make, each with the reason |
| 3 | [`THIS-MACHINE.md`](THIS-MACHINE.md) | The laptop: paths, versions, the network |
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

**Last updated: <YYYY-MM-DD HH:MM timezone>.** Checked against reality by: <the commands run>. Kept current; edit in
place.

## Where the project stands

<Phase in one line. Decisions so far, each linked to its record. Direction from the owner, quoted.>

## Running now

<!-- Delete this section when nothing runs. -->

| run | what it is doing | started | resume call if it dies |
| --- | --- | --- | --- |

## Next, in order

1. <checkable step>

## Traps that already cost something

- **<date>: <what went wrong>.** Rule: <the rule>. See `<record or memory link>`.
````

### `NEEDS-A-PERSON.md`

````markdown
# Needs a person

Things no agent can decide or verify. Each item says **why**, so it is clear who can unblock it.

| reason | why it blocks an agent |
| --- | --- |
| **business decision** | the answer is the owner's choice about money, law, product or direction |
| **owner's account** | it needs a registration, a payment or a login that only the owner holds |
| **owner's call by rule** | spending, publishing, deploying, merging, pushing and deleting are the owner's |
| **needs a network or device** | <e.g. the laptop's VPN exits abroad and some sites refuse it> |

## <Open questions for the owner, in the owner's language>

- **#1 — <short title>:** <the question and its options, in the owner's language>

## Open

| # | item | reason | since |
| --- | --- | --- | --- |
| 1 | **<item>** <context> | <reason> | <date> |

## Closed

| item | outcome | date |
| --- | --- | --- |
````

### `THIS-MACHINE.md`

````markdown
# This machine

The laptop the work is driven from. **A description, not a standard.** Measured <YYYY-MM-DD HH:MM timezone>;
re-measure before trusting a row.

| | value | measured with |
| --- | --- | --- |
| OS | <version> | `sw_vers -productVersion` |
| <tool> | <version, location> | `<command>` |
| network exit | <country, ASN> | `curl -s https://ipinfo.io/json` |

**Paths:** <workspace, repositories, memory directory>

**Quirks:** <each one dated, with its consequence, e.g. "a failed fetch from here is not evidence a service is down">
````

### `servers/<name>-<ip>/README.md`

````markdown
# <name> (<ip>)

**What it is:** <provider, location>, `ssh <user>@<ip>` with `<key name>`. <What else runs there; who owns it.>

## What this project may do there

- **Yes:** <explicit list>
- **No:** <explicit list, each with its reason>

## Known behaviour

- <dated observation, with how it was measured>
````

### `reports/<date>-<topic>/README.md`

````markdown
# <report title>

**Date:** <YYYY-MM-DD>. **Status:** a report, not a decision; the decision is NEEDS-A-PERSON #<n>.

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

**What was asked / what happened:** <owner quoted verbatim>
**What was run:** <commands, run ids, durations>
**Numbers:** <each with command and time>
**Verified vs not:** <explicit>
**Outcome:** <and what would change it>
````

### `tools/sync-claude-memory.sh`

```zsh
#!/bin/zsh
# Usage: sync-claude-memory.sh to-workspace | to-claude
#   to-workspace  copy the live Claude memory into claude-memory/ (run before a commit)
#   to-claude     restore claude-memory/ into the live memory directory (on a new machine)
set -eu
HERE=${0:A:h:h}
LIVE="$HOME/.claude/projects/<encoded-cwd>/memory"     # verify with: ls ~/.claude/projects/
COPY="$HERE/claude-memory"
case "${1:-}" in
  to-workspace)
    # Memory must never hold a secret; refuse if anything key-shaped appears.
    if grep -rIl -E '(^|[^A-Za-z0-9])(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|AKIA[0-9A-Z]{16})|BEGIN [A-Z ]*PRIVATE KEY|[0-9]{8,10}:[A-Za-z0-9_-]{35}|password[[:space:]]*[:=][[:space:]]*[^[:space:]]{6,}' "$LIVE" >/dev/null 2>&1; then
      echo "refusing: something key-shaped is in the live memory" >&2; exit 1
    fi
    rsync -a --delete --exclude 'README-THIS-IS-A-COPY.md' "$LIVE/" "$COPY/" ;;
  to-claude)
    mkdir -p "$LIVE"; rsync -a --exclude 'README-THIS-IS-A-COPY.md' "$COPY/" "$LIVE/" ;;
  *) echo "usage: $0 to-workspace | to-claude" >&2; exit 2 ;;
esac
echo "done: $1"
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

## 17. Anti-patterns

| don't | because |
| --- | --- |
| answer in chat and "write it up later" | the compaction comes first |
| name a folder after a day's activity (`checks/trust-pass-0915/`) | nobody looking for "how we build" opens it, and every citation then points at the wrong name |
| keep a "living list" nobody updates | it is read with the authority of a register |
| tick done items | the register fills with history; delete them, and keep history in records |
| copy a runbook or a command out of a repository | the copy goes stale silently |
| rewrite or move a record to tidy up | it rewrites what was known when a decision was taken |
| report a number without its command and time | nobody can re-check it |
| compare a before and an after measured by different methods | a method change dressed as an improvement |
| `git add -A` / `git commit -a` in a shared checkout | it sweeps in other sessions' work |
| put a credential in a file here "just temporarily" | history is permanent |
| open many SSH connections in parallel to one server | rate limits lock you out; use one multiplexed connection |
| create empty scaffolding folders "for later" | structure without content looks like information |

---

## 18. Changelog

When a rule here turns out wrong, change it, add a dated line below, and record the incident that changed it.

| date | change |
| --- | --- |
| 2026-10-11 | version 1 |
