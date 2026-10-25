---
name: git-workflow
description: "Commit rules (one commit per file, past tense, no AI attribution) and GitHub repo health: LICENSE, SECURITY.md, CONTRIBUTING, CHANGELOG, templates, CI, metadata, naming, gitignore, keeping scratch files out. Use when committing, reviewing a diff, splitting commits, writing commit messages, setting up or polishing a repo, preparing a release, or untracking a file. README: readme skill."
---

# Git Workflow

Meticulous staging, committing, and repository health. Never invent facts, never take unapproved or destructive actions.

## Workflow

1. `git status` to see what changed.
2. Check the branch. If on `main`/`develop`, create a feature branch (e.g. `chore/repo-cleanup`) before committing, unless the user explicitly asked to commit directly.
3. `git diff` (and `git diff --staged`) to understand each file's change.
4. Group changes per file and draft one specific message per file.
5. **Present the plan and wait for explicit approval before staging or committing anything.** Show it in the output format below and stop — this is a real gate, not a formality.
6. Once approved, commit files individually, one commit per file, with the safe loop below.

### Safe commit loop

```bash
c() { f="$1"; m="$2"
  git add -- "$f" && git commit -q -m "$m" -- "$f" && echo "OK   $f"     || { git reset -q; echo "FAIL $f (unstaged, loop continues; fix and retry this file)"; }; }
c src/login.js "feat(auth): added password reset to login.js"
c README.md    "docs(readme): rewrote installation instructions"
```

A rejected commit unstages its file, so it can't be swept into the next commit. After the batch, `git log --stat` must show exactly one file per commit.

### What the global hooks enforce

- `pre-commit` blocks any commit with more than one staged file (merges, the first commit, rebases and cherry-picks are exempt; a rename counts as one), and blocks secret-looking strings and real `.env` files.
- `commit-msg` blocks a wrong format or a non-past-tense verb, AI attribution, and a message that names a different repo file than the one being committed. A message that names no file is fine.
- Deliberate exceptions: `ALLOW_MULTI_FILE=1 git commit ...` for the file rules, `SKIP_SECRET_SCAN=1` for the secrets scan. Never use either without telling the user why.
- The hooks cannot check that a message describes the change accurately or that the plan was approved; that is still this skill's job.
7. **Never push** unless the user says "push" in that same turn.
8. If functionality, commands, env vars, or UI changed, flag whether the README needs updating (hand off to `readme`).

## Commit message rules

- **Never** include `Co-Authored-By: Claude`, `Generated with Claude Code`, or any AI attribution line.
- **Past tense only** — "Added password reset", not "Add password reset".
- Format: `type(scope): brief description in past tense`
  - `feat(auth): added password reset to login.js`
  - `fix(api): corrected error handling in user endpoint`
  - `docs(readme): updated installation instructions`
- Every message unique and specific to that file's actual change. Never "fix", "update", "changes".
- One commit per file, matching that file's own change. Don't bundle unrelated files.
- Before committing, re-check: no AI attribution, past tense.

## README

Owned by the `readme` skill (content, screenshots, badges, verification). Here,
only check: if behavior, commands, env vars, or the UI changed, say whether the
README needs an update, and hand off. Never write README claims from memory.

## What belongs in the repo, and what doesn't

Personal working files — handoff notes, study or interview prep, scratch plans,
TODO dumps — stay on disk and out of the repo. They go stale silently and end
up describing branches, folders, and services that no longer exist.

**Adding a file to `.gitignore` does not untrack it.** If it's already
committed, gitignore alone changes nothing on the remote. It takes both:

```bash
git rm --cached <file>
```

then add it to `.gitignore`. The file stays on disk and leaves the repo. Verify
with `git check-ignore -v <file>`, and confirm it's actually gone from the
remote rather than assuming.

Note that `git commit -- <path>` reads the **working tree**, not the index — so
it will not commit a staged `git rm --cached` deletion while the file still
exists locally. Commit that with a plain `git commit`.

Prune `.gitignore` rules for files that no longer exist; an ignore rule for a
deleted file is itself dead weight.

Be granular about agent and editor directories. `.claude/settings.local.json`
is personal and should be ignored; `.claude/launch.json` describes how to run
the project and is worth committing. Ignoring all of `.claude/` is the blunt
option, fine when nothing in it is shared.

## Repository naming

Inspect the manifest, main source files, and docs to infer what the project actually does. If the repo name doesn't match, suggest a better one — never rename anything yourself.

## Repository health (detailed GitHub repo)

Audit what exists, then propose the missing files in one plan. Each file is its
own commit and goes through the same approval gate. Facts come from the repo
(manifest, code, history), never invented; unknown values stay `[PLACEHOLDER]`.

| File | Contents | Rules |
|---|---|---|
| `LICENSE` | The chosen license text | **Ask which license** (offer MIT, Apache-2.0, none/all-rights-reserved, with the tradeoff). Never pick silently. Name and year from git config / the user. |
| `SECURITY.md` | How to report a vulnerability, supported versions, response expectations | Contact address from the user. Pair with `secure-and-compliant` for `security.txt`. |
| `CONTRIBUTING.md` | Setup, run, test, branch and commit conventions (this skill's message rules), PR expectations | Verify each command by running it. |
| `CHANGELOG.md` | Keep-a-Changelog format, grouped Added / Changed / Fixed / Removed | Build from the commit history by release or date; user-facing wording, not raw commit text. |
| `.github/ISSUE_TEMPLATE/` | Bug report and feature request forms (YAML issue forms) with repro steps, expected vs actual, environment | Keep short; required fields only where needed. |
| `.github/pull_request_template.md` | What changed, why, how tested, screenshots for UI | Checklist items that are actually checked by the project. |
| `.github/workflows/ci.yml` | Install, lint, typecheck, test, build using the project's real scripts | Only steps that exist and pass locally. Pin action versions to a full version or SHA. Least-privilege `permissions:`. No secrets in logs. |
| `.gitignore` | Stack-appropriate, no dead rules, secrets and local config excluded | See the section below. |
| `.github/dependabot.yml` | Weekly updates for the package ecosystem and Actions | Optional; ask. |

**Repo metadata (About panel):** description, topics and homepage are set on
GitHub, not in files. Draft the text (one-sentence description, 5-8 specific
topics) and give the exact `gh repo edit` command. **Run it only after explicit
approval**, since it changes a public setting. Same for branch protection,
enabling Dependabot or security features, and making a repo public.

**Releases:** version bump, changelog entry, annotated tag. Show the plan first;
never push tags or publish a release without a "push" or "release" in that same
turn.

## Output format (always show before acting)

```
Detected changes in N files:

1. path/to/file - what changed
   Commit: type(scope): specific description (past tense)

2. path/to/file - what changed
   Commit: type(scope): specific description (past tense)

Repository name: <name> (matches current / suggest rename because ...)
README updates needed: <none / description>

Ready to commit these changes. Shall I proceed?
```

If anything about scope, intent, or a message is ambiguous, ask rather than guessing.
