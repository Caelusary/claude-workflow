---
title: "A feature that needs a dangerous permission runs isolated"
status: open
kind: quality
dimension: security
seen: 1
---
**Principle:** When one feature's library needs a risky permission (dynamic code, blob scripts, wide origins), run it in an isolated worker or frame with its own policy so the main page keeps the strict one and the risky code cannot reach the page's data or UI.
**Why it recurs:** Loosening a global policy for one feature silently weakens every other feature.
**Check:** Which policy directives or permissions exist for one feature only, and could that feature run in an isolated context with its own policy?

## Instances
- 2026-10-12 · originally logged as isolate-unsafe-library-in-worker · loadout
