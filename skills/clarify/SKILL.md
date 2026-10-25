---
name: clarify
description: Resolve every open decision with the user before building. Use before any feature, component, page, flow, schema change or multi-file change, or whenever a gap exists in scope, behavior, data, visuals or security. Asks in rounds; only 'I don't know, you decide' lets Claude decide. Also /clarify.
---

# Clarify

A silent assumption is a decision made without the person who owns it. This skill's rule: **I never fill a gap on my own. Either the user decides, or they tell me "I don't know" and I decide in the open.**

The user's standing preference: keep asking until understanding is real. Guessing to save a round trip is the amateur move; rework costs more than a question.

## When this fires

**Yes:** a feature, page, flow, component, schema or auth change, a design direction, anything multi-file, anything where "I thought you meant X" is plausible.

**No:** a typo, a rename, a bug with a clear repro, a question about existing code, a mechanical step already decided. If the codebase or an earlier answer settles it, that isn't a gap.

For a whole undefined project, run `ideate` then `project-blueprint`, then use this skill per feature.

## The loop

### 1. Read it back (one line)

*"Building X that does Y so a user can Z."* Catches wrong premises that questions never expose.

### 2. List the open decisions (silently, to yourself)

Walk these lenses and write down every decision whose answer would change what gets built:

| Lens | Probe |
|---|---|
| Scope | What is in, what is explicitly out? |
| Users and roles | Who touches it, and what does each role see and not see? |
| States | Empty, loading, error, partial, offline, first-run, too-much-data |
| Data | Source, shape, ownership, retention, what if missing or malformed |
| Behavior | Triggers, side effects, undo, repeats, concurrency |
| Placement and flow | Where is it reached, how many taps, what comes before and after |
| Look and feel | Direction, density, tone, motion, phone vs desktop |
| Security and privacy | Who may do this, what is exposed, what personal data is touched |
| Done | What makes this finished instead of half-built |

Skip anything the codebase, the conversation, or the user's saved preferences already answer. Say so when you skip ("repo already uses X, following it"), so it reads as looked-at, not ignored.

### 3. Ask in rounds

Use AskUserQuestion. Up to 4 questions per round. Rules:

- **Every question carries an "I don't know, you decide" option.** It is the only door through which a decision becomes mine.
- Concrete options, recommended one first and marked. 2-3 real options plus the escape hatch.
- One decision per question. Describe the consequence of each option, not just its name.
- Group by theme and put the decisions others depend on first. Later rounds get shaped by earlier answers.
- Never re-ask what was answered. Never ask what the codebase answers.

### 4. Repeat until nothing is open

After each round, re-run step 2 against the new answers. Answers open new decisions (picking "accounts" opens auth, recovery, deletion). Keep going until a full pass of the lenses yields no open decision. Rounds are not capped; vague answers ("whatever", "up to you") mean ask a sharper question, not stop.

If a question comes back with "Other" text that is itself unclear, ask about that text. Do not interpret it.

### 5. Close with the decision log

Before building, print a short log:

```
Decided by you:   ...
Delegated ("I don't know") → my pick and why:   ...
Out of scope:   ...
```

Delegated picks are the only assumptions allowed, and each states its reason so it can be overturned by reading. Then build.

## Delegation phrases

"You decide", "I don't know", "whatever's best", "just go" = delegation. "Just go" delegates **everything still open at that moment**, log it and build. Delegation never covers destructive, irreversible, outward-facing, or money actions. Those still get a confirm.

## During the build

New decision discovered mid-build that changes behavior, data, UX, or security? Stop at that point and ask (a short round). Purely mechanical choices inside an already-decided design are not decisions.

## Failure modes

- **Fake choices.** Options that lead to the same build waste a round and dull trust in the real ones.
- **Asking to dodge work.** Ask about their intent, never about how I'd implement something they don't care about.
- **Silent assumption.** The failure this skill exists to prevent. If it isn't in the decision log, it wasn't decided.
- **Interrogating a trivial change.** The rule is "every real decision", not "every keystroke".
