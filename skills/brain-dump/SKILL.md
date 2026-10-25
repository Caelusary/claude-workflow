---
name: brain-dump
description: Organize the user's messy, many-threaded messages into themes, decisions, next steps and a parked list, naming one next step. Use for stream-of-consciousness messages, many ideas at once, 'brain dump', 'help me organize', 'what should I do first', or when they seem overloaded.
---

# Brain dump

The user's mind moves fast and branches. That's a strength (fresh angles) and a cost (threads get lost, everything feels urgent). This skill catches every thread, sorts it, and hands back calm structure. Tone: a friend who listened properly, not a project manager.

## Principles

- **Catch everything, drop nothing.** Every idea gets a home, even if the home is "parked". Never silently skip a thread.
- **Don't chase tangents.** A side idea gets noted and parked, not built.
- **Don't interrogate first.** Organize what's there, then ask only what blocks the sorting.
- **One next step, clearly marked.** Overload shrinks when the next move is obvious and small.
- **Short.** Fit the whole answer on roughly one screen. Details expand only on request.

## Process

1. **Mirror in one line.** What I heard in plain words ("You've got a project deadline, a new app idea, and a worry about standing out"). Acknowledge the load if it's heavy; don't over-comfort.
2. **Sort** into these buckets (omit empty ones):
   - **Doing now** (has a deadline or is already in flight)
   - **Decisions waiting on you** (each phrased as a question with my recommended answer and a one-line "what that means for you")
   - **Next steps** (concrete, small, ordered)
   - **Ideas worth keeping** (with one line on why they matter, candidates for `ideate`)
   - **Parked** (interesting, not now)
   - **Worries or blockers** (what's actually in the way, and the smallest fix)
3. **Name the one next step** and why it's first (deadline, unblocks others, or cheapest win). Offer a 10-25 minute version if it's big.
4. **Offer follow-ups, not obligations:** "Want me to turn the app idea into a researched shortlist (`ideate`)?" "Want this saved as state for next time?"

## Output template

```
Heard: <one line>

Now:        ...
Decide:     1. <question> → my pick: <X> (means: <plain consequence>)
Next steps: 1. ... 2. ...
Keep:       ...
Parked:     ...
Blocked by: ...

Start with: <one step> — because <reason>.
```

## Rules

- Never reorder their priorities silently: if a deadline conflicts with what they seem excited about, say it plainly and let them choose.
- If a thread is really a decision about a build, hand it to `clarify`; if it's an idea, to `ideate`; if it's a bug, to `debugging`.
- Save the sorted result to `.claude/STATE.md` (see `session-state`) when work is in a project, and the parked list to a `PARKED.md` only if they ask.
- Don't add structure they didn't need: if the message is one clear request, just do it.
- No productivity-guru language, no guilt, no "you should have".
