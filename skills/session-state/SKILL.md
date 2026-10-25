---
name: session-state
description: "Keep a project's .claude/STATE.md current so the next session resumes without re-explaining. Use at the end of substantial work, before compaction, when context is heavy, when switching tasks, on 'save state', 'checkpoint' or 'continue later', and to read state at the start of work."
---

# Session state

Hooks load `.claude/STATE.md` at session start and append mechanical git facts before compaction. They cannot write meaning. This skill is the meaning: what is done, what was decided, what is next, what is open.

## Where

`<project root>/.claude/STATE.md`. Create `.claude/` if missing. Add `.claude/STATE.md` to `.gitignore` unless the user says the repo should carry it (ask once, via `clarify`).

Lasting facts about the user or project conventions go to memory, not here. STATE is for in-flight work and goes stale on purpose.

## When to write

- End of a substantial task (feature, fix, audit, deploy).
- Before stopping with work unfinished.
- When a long session passes many tool rounds or large outputs, before compaction.
- On a topic switch inside one session.

Update in place. Never append a second copy.

## Format (keep it under ~60 lines; the loader reads the first 6000 characters)

```markdown
# State — <project> — updated YYYY-MM-DD

## Goal
One or two sentences: what this work is for.

## Done
- Verified items only, newest first. Name the file or command that proves each.

## Decided
- Decision — reason. (Include the user's "I don't know, you decide" delegations and what I picked.)

## Next
1. Concrete next step, with the file or command to start from.

## Open questions
- Anything needing the user's decision (use clarify at the next turn).

## Gotchas
- Traps hit: port clashes, env quirks, flaky tests, things not to touch.
```

The pre-compact hook maintains an `auto-snapshot` block at the bottom. Leave it alone.

## Rules

- **Verified over remembered.** Only list as done what was actually run or read. Mark unverified items "unverified".
- **No secrets, tokens, credentials or personal data.** Name where a secret lives, never its value.
- **No history.** Delete finished items after they are committed or irrelevant; this is a handoff note, not a log.
- **At the start of work:** read STATE.md, then check it against `git status`, `git log`, and the files it names. Where they disagree, trust the repo and fix the note.
- Report in one line when updated: "State saved: N done, M next."
