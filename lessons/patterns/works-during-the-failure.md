---
title: "If the app exists for a failure, it works during that failure"
status: open
kind: quality
dimension: ui-planning
seen: 1
---
**Principle:** When an app exists to help during a failure (outage, lost connection, dead battery, locked account), list what is broken at the moment someone opens it and make the core flow work under exactly those conditions, placing anything that needs the broken thing after the core flow.
**Why it recurs:** Apps are designed and tested in normal conditions, so the one moment of need is the one never exercised.
**Check:** At the moment a user most needs this app, what is unavailable to them, and does the main flow still finish without it?

## Instances
- 2026-10-16 · originally logged as works-during-the-failure · ilaw
