---
title: "Unhappy paths are designed, and errors name their real cause"
status: open
kind: quality
dimension: ui-planning
seen: 4
---
**Principle:** A screen is not designed until its empty, zero-result, error, loading and per-role versions are. A failed load is never shown as 'no data'. Every failure maps to a message naming its actual cause and the fix, matched on the error's type or code from the documented set, never on a loose word.
**Why it recurs:** The happy path is built first and the rest falls through to defaults: a swallowed error becomes an empty state, a catch-all message, or a wrong explanation.
**Check:** For each screen: what does each role see with no data, bad input, or a failed request? For each error shown, which exact code triggers its message, and is there a test that fails the backend and asserts an error with a working retry rather than the empty state?

## Instances
- 2026-10-08 · originally logged as ui-planning-every-role-every-state · loadout
- 2026-10-10 · originally logged as failed-fetch-is-not-empty · trip-planner
- 2026-10-10 · originally logged as errors-name-real-cause · bantay-buhay reference check
- 2026-10-17 · originally logged as errors-by-code-not-substring · ilaw
