---
title: "The server omits what a viewer may not see"
status: open
kind: quality
dimension: security
seen: 2
---
**Principle:** If a field is meant for only some viewers, the server leaves it out of the response for everyone else instead of sending it and letting the UI hide it. Personal details one user needs about another are sent only while the task that needs them is open; when it ends, the response shrinks.
**Why it recurs:** Serialising the whole record is easier than deciding per field and per viewer, and client-side hiding looks identical to protection in a demo.
**Check:** For each field a list or detail endpoint returns, who is allowed to see it, what task needs it, and is there a test that a viewer who is not allowed (or after the task ends) gets a response without it?

## Instances
- 2026-10-11 · originally logged as security-send-only-what-the-viewer-may-see · loadout
- 2026-10-11 · originally logged as access-to-a-person-ends-with-the-task · loadout
