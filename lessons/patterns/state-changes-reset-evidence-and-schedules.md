---
title: "New states inform every timer, and closed states discard their evidence"
status: open
kind: quality
dimension: ui-planning
seen: 2
---
**Principle:** When a flow gains a state or a step backwards, every scheduled job that acts on that flow must be told what to do with it. When a state is derived from events in a time window, every count is also bounded by the moment the previous episode closed, and the evidence that opened it is marked spent.
**Why it recurs:** State machines grow by addition while background jobs and windowed counters keep their old assumptions, so they finish unfinished things or re-open closed ones.
**Check:** For each state added or re-entered, which timers and sweeps match it, and which correctly leave it alone? For each derived state, close it and send the next event: does it stay closed, and is there a test for exactly that?

## Instances
- 2026-10-12 · originally logged as new-states-vs-background-jobs · loadout
- 2026-10-17 · originally logged as windowed-counts-reset-at-close · pasabi
