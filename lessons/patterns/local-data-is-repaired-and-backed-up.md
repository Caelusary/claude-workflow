---
title: "Browser-only data loads through a repairing, backed-up path"
status: open
kind: quality
dimension: ui-planning
seen: 1
---
**Principle:** When the only copy of user data lives in the browser, load it through one versioned sanitiser that repairs what it can, copies anything unreadable to a recovery location before writing back, never downgrades data from a newer version, and lets the user download and restore everything.
**Why it recurs:** Schemas evolve and storage gets corrupted; an unguarded parse either crashes the app or silently overwrites the only copy.
**Check:** Seed storage with broken JSON and half-broken rows: does the app still render, keep the good rows, keep the original, and let the user export and restore?

## Instances
- 2026-10-10 · originally logged as local-data-repair-and-backup · budgy
