---
title: "A cached guess about the user never turns them away"
status: open
kind: quality
dimension: speed
seen: 1
---
**Principle:** Showing the last-known signed-in state from device storage removes the 'who am I?' wait, but it is a guess until the server answers. Anything that turns people away or blocks an action must read the confirmed state.
**Why it recurs:** Optimistic UI is wired into guards by reusing the same state the screen renders from.
**Check:** With an optimistic session, clear the session cookie and reload the sign-in page: can you still sign in, and does every guard that redirects read the confirmed state?

## Instances
- 2026-10-21 · originally logged as optimistic-session-never-gates-sign-in · loadout
