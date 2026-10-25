---
title: "Deleting a shared resource asks one function who still uses it"
status: open
kind: quality
dimension: security
seen: 1
---
**Principle:** When a resource (file, URL, record) can be referenced from more than one place, removing a reference never means deleting the resource until every holder has been checked. Keep that check in one shared function that every delete path calls.
**Why it recurs:** Each new field that can hold a reference adds a path that forgets the others; ownership logic scattered across handlers drifts.
**Check:** List every field that can reference the resource. Does every delete path ask one shared 'is this still used anywhere?' function, and is there a test with a reference borrowed from a different kind of record?

## Instances
- 2026-10-18 · originally logged as shared-file-deletes-check-every-owner · loadout
