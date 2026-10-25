---
title: "Backends are reachable only through their front door"
status: open
kind: quality
dimension: security
seen: 1
---
**Principle:** Nothing should be reachable that doesn't need to be. A backend, bucket or admin route accepts traffic only through the application's own entry point; everything else is refused, while the real caller identity still gets through.
**Why it recurs:** Defaults are open. Each new route or storage location inherits exposure nobody decided on, and the app's own checks give a false sense that the door is closed.
**Check:** Can someone call this backend, storage bucket or admin route without going through the app? If yes, why?

## Instances
- 2026-10-08 · originally logged as security-no-unguarded-doors · loadout
