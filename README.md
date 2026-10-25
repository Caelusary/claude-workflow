# Claude Code Workflow

A reusable setup for [Claude Code](https://claude.com/claude-code): skills that change how it works, audit agents, safety hooks, and a place for what it learns across projects. Take what you want, leave the rest.

---

## Quick start

```bash
git clone https://github.com/Caelusary/claude-workflow.git
cd claude-workflow

cp -r skills agents hooks lessons ~/.claude/
cp CLAUDE.template.md ~/.claude/CLAUDE.md
```

Then:

1. Edit the **About me** section in `~/.claude/CLAUDE.md`.
2. Merge the `hooks` block from `settings.example.json` into `~/.claude/settings.json`.
3. Optional: use the git hooks everywhere with `git config --global core.hooksPath <path-to>/githooks`.

Hooks assume Git Bash and `python` on your PATH.

---

## What's inside

| Folder | What it holds |
|---|---|
| `skills/` | 20 skills, one folder each with a `SKILL.md` |
| `agents/` | 6 audit subagents |
| `hooks/` | 5 Claude Code hooks that guard deploys and context |
| `githooks/` | Git hooks: commit-message rules and a secrets scan |
| `lessons/patterns/` | Cross-project patterns learned over time |
| `scheduled-tasks/` | Weekly memory cleanup prompt |
| `memory/` | Memory file format and two examples |
| `CLAUDE.template.md` | Starting point for your global instructions |

---

## Skills

### Thinking before building

| Skill | What it does |
|---|---|
| `clarify` | Asks until no decision is open before any feature or multi-file change |
| `ideate` | Finds grounded product ideas, then maps one idea's needs and scope |
| `project-blueprint` | Turns an approved idea into a production-ready plan |
| `project-init` | Sets up a new project's foundation: gitignore, env split, tests, CI |
| `brain-dump` | Turns a messy, many-threaded message into themes, decisions and one next step |

### Writing code well

| Skill | What it does |
|---|---|
| `frontend-engineering` | React 19 and Next.js 16 structure, state, data fetching |
| `architecture` | Where files belong, when to extract, module boundaries |
| `algorithms` | Picks the right data structure and catches N+1 and quadratic traps |
| `performance` | Rendering, caching, bundle size, Core Web Vitals |
| `debugging` | Reproduce, one hypothesis, one change, confirm |
| `testing-standards` | What to test and how, without brittle tests |
| `secure-and-compliant` | Security, privacy and legal cover a site actually needs |

### Shipping and sharing

| Skill | What it does |
|---|---|
| `git-workflow` | One commit per file, past tense, plus repo health checks |
| `readme` | Writes READMEs from what the code actually does |
| `defense-deck` | Plans and rehearses a presentation that survives questions |
| `summarize` | Project status in a fixed three-table format |

### Working with Claude

| Skill | What it does |
|---|---|
| `orchestrator` | Say "orchestrator on" and it picks the right skills and agents for the session |
| `observer` | Logs patterns that hold in any app and applies them as quality checks |
| `session-state` | Keeps a `.claude/STATE.md` so the next session resumes without re-explaining |
| `mentor` | Explains why a choice matters and what a real team would do |

---

## Agents

Each one audits a whole codebase. When several run at once, make them report-only.

| Agent | Looks at |
|---|---|
| `security-engineer` | Auth, injection, secrets, dependencies, privacy |
| `qa-engineer` | Test coverage, error handling, edge cases, race conditions |
| `performance-engineer` | Queries, caching, bundle size, Core Web Vitals |
| `code-architect` | Dead code, duplication, file organization, tech debt |
| `devops-engineer` | Build pipeline, deploy safety, logging, git hygiene |
| `journey-auditor` | Drives the running app in a browser as every role, on desktop and phone |

---

## Hooks

### Claude Code hooks (`hooks/`)

| Hook | When it runs | What it does |
|---|---|---|
| `deploy-guard.sh` | Before a Bash command | Blocks `vercel --prod` when the tree is dirty or unpushed |
| `quality-bar.sh` | Session start | Prints a one-line count of open quality patterns |
| `state-load.sh` | Session start | Loads the project's `STATE.md` |
| `pre-compact-snapshot.sh` | Before compaction | Saves a snapshot so nothing important is lost |
| `pre-commit-secrets.sh` | Before a commit | Scans staged files for keys, tokens and connection strings |

### Git hooks (`githooks/`)

| Hook | What it does |
|---|---|
| `commit-msg` | Requires `type(scope): past-tense description` and rejects AI attribution lines |
| `pre-commit` | Blocks secret-looking strings and real `.env` files |

---

## How the pieces fit

```
CLAUDE.md          the always-on rules and tone
   |
skills/            loaded on demand for a kind of task
   |
agents/            run at the gate, before committing a batch
   |
hooks/             enforce the rules even when nobody remembers
   |
lessons/patterns/  what each project taught, fed back into the checks
```

---

## Notes

- The `design-taste` skill I use is third-party (MIT/Apache) and isn't included. Install the original.
- Skills reference each other by folder name, so keep the names.
- Everything here is written to be project-agnostic. Nothing is tied to one app.
