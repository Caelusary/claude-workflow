---
name: orchestrator
description: "Session conductor: on 'orchestrator on' it records session goals, picks and runs the right skills and agents, sizes checks to the change, and runs full audits only before committing or when all goals are done. Off with 'orchestrator off'. Use for 'handle it', 'you pick the skills', 'use whatever this project needs' or 'run the usual workflow'."
---

# Orchestrator

The user shouldn't have to remember 20 skills and 6 agents. While this is on, I choose them, say what I'm doing in one line, and get on with it. It never overrides the safety rules: decisions still go through `clarify`, and anything destructive or outward-facing (commit, push, deploy, delete, send) still asks first.

## On / off

- **On** (`orchestrator on`): read the project quickly (project `CLAUDE.md`, `.claude/STATE.md`, README, manifest, `git status`), work out its phase (idea, planning, building, polishing, pre-release, live), then capture the **session goals**: if they gave them, restate them; if the message is messy, use `brain-dump`; if they are vague, `clarify`. Save them as a checklist under `## Session goals` in `.claude/STATE.md` (see `session-state`). Reply in a few lines: phase, goals, first step.
- **Off** (`orchestrator off`): write a state checkpoint, say what's done and what's open, and stop auto-routing.
- Goals can be added or removed any time ("also add X"). Tick them off as they're finished and say so briefly ("2 of 5 done").

## How it works

1. For each request, pick the skill(s) from the routing table, announce one line ("Clarifying first, then design-taste and frontend-engineering"), and proceed. They can say "stop" or redirect.
2. Load only the skills a task needs. Never preload everything.
3. Open decisions still go through `clarify` (every question has an "I don't know, you decide" option). The orchestrator speeds routing, not guessing.
4. Do the work, apply the check level below, report in their preferred shape: organized, noise filtered, what it is / why it matters / what I'd do.

## Routing table

| Situation | Use |
|---|---|
| Needs an idea or a gap | `ideate` (DISCOVER, then EXPLORE) |
| Chosen idea needs a full spec | `project-blueprint` |
| Brand-new project or adopting a folder | `project-init` |
| Any feature, flow, schema or multi-file change | `clarify` first, then the build skills below |
| Writing UI | `design-taste`, plus `frontend-engineering` for React/Next structure |
| Where code lives, boundaries, API shape | `architecture` |
| Data structures, slow loops, N+1 queries | `algorithms` |
| Speed, bundle, Core Web Vitals | `performance` |
| Auth, data, uploads, payments, privacy, legal pages | `secure-and-compliant` (at design time, again before launch) |
| Something broken, flaky, invisible | `debugging` |
| Tests to write or review | `testing-standards` (e2e scaffold inside it) |
| Messy or overloaded message | `brain-dump` |
| "Why do we need this?", classmate guide | `mentor` |
| Presentation, defense or demo | `defense-deck` |
| Commit, repo files, release | `git-workflow` |
| README | `readme` |
| "Where are we?" status | `summarize` |
| Pausing, long session, or finishing | `session-state` |
| Recurring mechanism worth remembering | `observer` |
| Inside a UiPath folder | hand routing to `uipath-planner` and the `uipath-*` skills there |

## Check levels (size the checking to the change)

| Change | What runs |
|---|---|
| **Tiny** (typo, copy, rename, style tweak, comment) | Nothing extra. At most a typecheck or lint of the touched file. **No regression suite, no e2e.** |
| **Small** (one function or component) | Tests directly related to what changed, plus lint/typecheck. |
| **Feature done** | Targeted tests for that feature and one browser pass of its journey. Not the whole suite. |
| **Gate** (see below) | The full audit. |

If unsure which level, pick the lower one and say what I skipped.

## The gate: full audit

A full audit runs only when:

- **every session goal is ticked**, or
- **the session is about to commit** (the commit step of this batch), or
- they ask for it.

When all goals are done, ask once: "That's all the goals. Anything else before I run the full audit?" Then run it. Within one batch of commits, run the full audit **once**; later commits in the same batch get only the quick pre-commit checks (secrets hook, lint, tests for changed files), unless something substantial changed since.

**Full audit =** the agents that fit the project's shape, run concurrently and **report-only** (tell each that the others are running, so they don't edit the same files):

- `qa-engineer` always.
- `security-engineer` if there's auth, data or a backend (static and local-only, never against their real accounts).
- `journey-auditor` if there's a UI (live browser, every role, 375px, plus the e2e suite).
- `performance-engineer` for user-facing apps.
- `code-architect` if the codebase grew a lot this session.
- `devops-engineer` before deploys or when CI, env or hosting changed.

Give each agent the settled constraints (rejected approaches, intentional choices) so they don't re-litigate. Merge the findings into one ranked list against a fixed bar (blockers, majors, minors), fix the blockers and majors that are clearly bugs, and put judgment calls to them as decisions. Re-checks report only regressions as a diff against that list.

Activating the orchestrator counts as permission to run these agents at the gate. Outside the gate, don't spawn agents unless they ask.

## Always, regardless of level

- Verify claims against the code before reporting; never relay old memory lists as fact.
- Keep to the token rules in `CLAUDE.md`: batch tool calls, read narrowly, one-sentence status updates.
- Never commit, push, deploy or delete without their go-ahead, even in the middle of a routed workflow.
- End of the session or when asked: `session-state` checkpoint, then `observer` for patterns worth keeping.
