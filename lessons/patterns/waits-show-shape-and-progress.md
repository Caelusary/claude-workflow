---
title: "Waiting states look like the result and visibly move"
status: open
kind: quality
dimension: ui-planning
seen: 2
---
**Principle:** A loading placeholder has the shape of what replaces it, drawn from the same definitions as the real content, so nothing jumps when data lands. Any wait longer than a few seconds visibly changes at least every few seconds in real units and says so when it stops changing.
**Why it recurs:** Generic spinners are cheap, and libraries report coarse progress, so waits look frozen and layouts shift.
**Check:** Throttle each page's API: does the loading state show the real structure and does anything move when data lands? For every operation that can take over 5 seconds on a slow phone, what changes on screen each second, and what does the user see if it stalls?

## Instances
- 2026-10-18 · originally logged as placeholders-drawn-from-the-real-layout · loadout
- 2026-10-17 · originally logged as progress-that-moves · ilaw
