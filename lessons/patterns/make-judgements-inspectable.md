---
title: "Show what was decided, why, and what is being judged"
status: open
kind: quality
dimension: ui-planning
seen: 3
---
**Principle:** Anything that decides (a detector, a rule) or asks a person to decide (verify, grade, approve) must show its inputs, its reasoning with the actual numbers, the cases where it correctly does nothing, and the exact span a human is judging with what is out of scope. If the real interface is invisible to the audience, provide a shared view plus an honest simulator running the same code.
**Why it recurs:** Systems are demonstrated on their triggered path, and review UIs show whole items, so observers and reviewers judge the wrong thing consistently.
**Check:** For each thing this app decides: is there a demo or test where it correctly does nothing, and does the UI explain the decision with real values? Can a reviewer tell from the screen alone what they are verifying against what, and what to ignore?

## Instances
- 2026-10-10 · originally logged as ui-planning-demo-the-should-not-cases · bantay-buhay 3D prototype
- 2026-10-17 · originally logged as audience-sees-the-system · pasabi
- 2026-10-15 · originally logged as scope-the-judgement · bantay-buhay reference check
