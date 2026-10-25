---
title: "Only the party who observes a change may assert it"
status: open
kind: quality
dimension: security
seen: 2
---
**Principle:** Integrity means nobody can claim something they could not have observed. Assign every status transition to the party who actually sees it happen, give the rest a timed fallback, and when the change belongs to a third party, wait for observable evidence before asking the user to confirm.
**Why it recurs:** Flows are designed from the happy path where everyone is honest and informed; the permission model then lets the wrong party declare an outcome.
**Check:** For each status in the flow: who could lie here, who actually causes it, and what observable evidence does it leave before the UI accepts it?

## Instances
- 2026-10-08 · originally logged as security-whoever-can-see-it-owns-it · loadout
- 2026-10-17 · originally logged as status-owned-by-someone-else · ilaw
