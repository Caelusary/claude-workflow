---
title: "Anything that awards or counts is paid once per genuine attempt"
status: open
kind: quality
dimension: security
seen: 1
---
**Principle:** Each reward, point, vote, credit or counter change is tied to one genuine attempt, decided server-side. Repeating the action, reaching it after seeing the answer, switching context mid-attempt, or replaying the same content must not pay again.
**Why it recurs:** Handlers are written for one clean request. Retries, parallel calls, revealed answers and re-entry are separate paths nobody listed.
**Check:** For each action that awards or counts something, can it be repeated, reached after seeing the answer, or replayed on the same content? Is there a test for each of those paths?

## Instances
- 2026-10-09 · originally logged as ui-planning-every-reward-paid-once · learninghub
