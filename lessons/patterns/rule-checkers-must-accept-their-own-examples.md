---
title: "Automated rule checks are tested against the rule's own examples"
status: applied
kind: workflow
seen: 1
---
**Principle:** A hook or linter that enforces a style rule must pass the rule's own documented examples and common legitimate forms. When it rejects a valid case twice, fix the checker structurally rather than rewording around it each time.
**Why it recurs:** Checkers encode a narrow approximation of the rule and nobody tests them against real usage until they block work.
**Check:** Has this checker been run against the rule's own examples and the last month of real inputs? How many times has it blocked valid work?

## Instances
- 2026-10-08 · originally logged as commit-hook-irregular-verbs · twogether
- 2026-10-25 · commit-msg hook already carries the irregular-verb list; fixed before this review · twogether
