---
name: project-init
description: "Set up a new project's foundation locally (no git or deploy): project CLAUDE.md, gitignore, env split, tests, CI, security baseline, STATE.md, using clarify first. Use when starting, scaffolding or bootstrapping a project or adopting an existing folder."
---

# Project init

Goal: a new project starts with the lessons of the old ones already applied, and with no need to re-explain preferences. This skill writes **files only**. Git init, repo creation, pushing and deploying stay separate steps that each need explicit approval.

Order of related skills: `ideate` (if the idea is open) → `project-blueprint` (spec, architecture, schema) → **`project-init`** (foundation) → build features with `clarify`.

## Step 1: Clarify (required, via `clarify`)

Run the full loop. Facts to settle, each with an "I don't know" option:

- Project name, one-line purpose, solo or team (and teammates' roles).
- Stack: framework, language, styling, backend/database, auth. If undecided, use the blueprint or offer 2-3 options with tradeoffs.
- Platforms and roles (who uses it, what each can do).
- Where it will run: hosting for client, API, database; production branch name; deploy from Git.
- Data: personal data? payments? minors? uploads? (feeds `secure-and-compliant`)
- Repo visibility (public/private) and license intent.
- Tests: end-to-end now or later; CI now or later.
- Standing preferences to carry over: read `~/.claude/projects/*/memory/` index files of the user's recent projects and `~/.claude/CLAUDE.md`, list the preferences found (commit style, push policy, design stance, report style, nav rules), and ask which apply here. Do not assume a project-specific preference (such as a theme) applies to a different project.

## Step 2: Present the plan

List every file to create, with a one-line purpose, and the commands that will be run. Wait for approval. Never overwrite an existing file; if one exists, show a diff proposal instead.

## Step 3: Scaffold (local files only)

| Item | Contents |
|---|---|
| `CLAUDE.md` (project) | Purpose, stack, run/build/test commands (verified by running), folder map, conventions, roles, standing preferences chosen in Step 1, "never do" list (no real data in dev, no secrets in repo), pointers to skills (`clarify`, `design-taste`, `secure-and-compliant`, `debugging`, `session-state`). Short; facts only. |
| `.gitignore` | Stack-appropriate. Ignores `.env`, `.env.*` except `!.env.example`, build output, `.claude/settings.local.json`, `.claude/STATE.md`. Keep `.claude/launch.json` tracked. |
| `.env.example` | Variable names with placeholder values and a comment each. Separate dev and prod values by design: dev keys, dev database, so running dev cannot reach production data. |
| `.claude/launch.json` | How to start the dev server(s), with ports. |
| `.claude/STATE.md` | Initial goal, decisions from Step 1, first next steps (format in `session-state`). |
| Tests | Unit test runner per stack. E2E scaffold from the `testing-standards` skill (own server, production headers, mock backend, role fixtures, axe) if chosen. |
| CI | `.github/workflows/ci.yml` using real scripts, per `git-workflow` repo-health rules. Only if chosen. |
| Security baseline | Output of the `secure-and-compliant` profile: documents needed, security headers config, auth/rate-limit decisions recorded in CLAUDE.md. |
| README stub | Only a title and one-line description; the `readme` skill writes the real one once code exists. |

Do not install large dependency sets beyond what the stack needs. Prefer fewer, maintained packages.

## Step 4: Quality bar

The SessionStart hook prints open Observer checks. Walk the five dimensions (security, ui-planning, theme-feel, speed, navigation) once and record in the project CLAUDE.md the 5-8 checks that apply to this project's shape, phrased as the standard. Raise gaps as standards, never as copying a past project.

## Step 5: Verify and hand off

Run the install, build, lint and test commands that now exist; report real results. Write the initial STATE.md. Then say what is **not** done and needs separate approval: `git init`, first commit (per `git-workflow` rules), creating the GitHub repo, deploy.

## Adopting an existing folder

Inventory first (read manifest, structure, existing CLAUDE.md, README, tests). Propose only the missing pieces. Never restructure or rename existing code as part of init.
