---
title: "Cache what is the same for everyone and keep hosts warm"
status: open
kind: quality
dimension: speed
seen: 1
---
**Principle:** The fastest request is the one the backend never sees. Cache public, non-personal data at the edge with stale-while-revalidate and keep sleeping hosts warm so the first visit is not the slow one.
**Why it recurs:** Responses default to uncacheable and idle hosts go cold, so the first visitor pays for everyone.
**Check:** Which responses are the same for everyone, and are they cached? What does the first load cost after an hour of no traffic?

## Instances
- 2026-10-08 · originally logged as speed-cache-at-the-edge-keep-it-warm · loadout
