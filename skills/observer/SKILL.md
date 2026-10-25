---
name: observer
description: Cross-project learning: log recurring patterns (not incidents) to ~/.claude/lessons/patterns and apply the quality checks. Use after a substantial task, when they correct something in a way that applies generally, when a rule or skill is broken, when starting a project or significant feature (run the quality bar), or when asked to review or consolidate lessons.
---

# Observer

Carry the **quality bar** between projects, never the projects themselves. A lesson is a pattern that would hold in a totally different app. An incident log is not a lesson.

## The abstraction test (every entry must pass)

Before writing, rewrite the observation until all four are true:

1. **No project nouns.** No app name, screen name, library, endpoint, file, table, or person. "The leaderboard double-paid on retry" → "any reward or counter changed by a retryable action must be idempotent".
2. **Domain swap.** Imagine a clinic scheduler, a game, an inventory tool. Does the sentence still make sense and still apply? If not, go up one level of abstraction.
3. **It names a mechanism**, not an event. Not "X broke", but "what makes this class of thing break, and what structurally prevents it".
4. **The check is a question** a stranger could answer by looking at a new project, with no knowledge of the original.

If you can only state it with the original nouns, it isn't a pattern yet. Park it as a one-line instance on the closest existing pattern, or skip it. Do not log verbatim.

## What to watch for

- **Lifted the bar** on one of five dimensions: security, ui-planning, theme-feel, speed, navigation. Record the general principle.
- **The user corrected something** in a way that generalises ("don't do X in any project").
- **A rule was broken** (CLAUDE.md or a skill). First break: log as an instance. Second break of the same rule: propose a structural barrier (hook, lint, default), not louder wording.
- **A repeated workflow** they call out ("I always do it this way"): candidate for a skill.

Skip: one-off fixes, anything already captured, anything only meaningful with client secrets.

## Logging: match first, create second

Patterns live in `~/.claude/lessons/patterns/<slug>.md`. Slug is the mechanism, kebab-case, no project words.

1. `grep -il` the patterns folder (and read titles) for the same mechanism. Synonyms count.
2. **Match found:** append one line to its `## Instances` (date, 8 words of context, project tag), bump `seen:`. If the new case reveals a wider or sharper principle, rewrite the Principle, don't just append.
3. **No match:** create a new pattern from the template. Needs to pass the abstraction test.
4. **Two patterns that turn out to be one mechanism:** merge them, keep the better slug, move instances over.

Write in the same turn the observation happens, without interrupting the task.

```markdown
---
title: "Mechanism in plain words"
status: open        # open | applied | dropped
kind: quality       # quality | correction | violation | workflow
dimension: security # security | ui-planning | theme-feel | speed | navigation (quality only)
seen: 1
---
**Principle:** the standard, stated so it holds in any app.
**Why it recurs:** the mechanism that keeps producing this problem.
**Check:** one question to ask of a new project.

## Instances
- 2026-10-25 · short context · project-tag
```

Instance lines may carry project tags. Principle, Why and Check never do.

## Applying the bar

The SessionStart hook prints only a one-line count. When starting a project or significant feature, read the checks for the relevant dimensions:

```bash
grep -h -B0 '^\*\*Check:\*\*' ~/.claude/lessons/patterns/*.md        # all checks
grep -l '^dimension: security' ~/.claude/lessons/patterns/*.md          # patterns for one dimension
```

Then hold the work to them dimension by dimension (read a pattern's Principle for the reasoning). Raise gaps as the standard ("public data should be edge-cached, not yet here"), never as "do what project X did". Suggest, never silently import features.

## Consolidation

When asked, or when `patterns/` passes ~25 files: merge near-duplicates, push project nouns out of Principle/Check, retire `applied` ones that are now enforced by a hook or rule. Archive originals, never delete.

## Don't self-edit

Turning a pattern into a rule in CLAUDE.md, a skill, or memory waits for the user's OK. Mark it `applied` after.

## Report

End of a substantial task, one line: patterns added or incremented this session (titles), or nothing.
