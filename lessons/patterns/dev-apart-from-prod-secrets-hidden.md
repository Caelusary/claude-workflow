---
title: "Development cannot touch production; secrets never surface"
status: open
kind: quality
dimension: security
seen: 1
---
**Principle:** Development should be physically unable to reach production data by accident, and secrets are never printed, logged or pasted, not even to check them.
**Why it recurs:** Convenience (one shared key, one shared database, echoing a value to confirm it) is the path of least resistance, and the damage is permanent once a secret appears in output or history.
**Check:** If I run the dev command by mistake, can it reach live data? Is any secret visible in logs, output or the repo?

## Instances
- 2026-10-08 · originally logged as security-live-secrets-apart · loadout
