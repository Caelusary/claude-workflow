---
title: "Tests exercise the real app, its real headers, its real journey, repeatedly"
status: open
kind: quality
dimension: ui-planning
seen: 6
---
**Principle:** Unit tests prove parts; only a browser test proves a user can finish the job. The end-to-end suite starts and owns its own server on a port nothing else uses, applies the exact headers production sends, treats console errors as failures, mocks server-side backends with a local stand-in so it runs offline without secrets, waits for fetched content before scanning, and repeats mutation journeys many times to catch intermittent staleness.
**Why it recurs:** A test that can pass against someone else's app, without production's policy, on skeletons, or on a single lucky run proves nothing, and the failures it hides are the intermittent ones.
**Check:** Is there one automated test that clicks through the main journey as every role, without touching live data, under production headers, on a server it owns? Does it fail on console/CSP errors and pass or fail consistently under --repeat-each?

## Instances
- 2026-10-09 · originally logged as prove-journeys-in-a-browser · loadout
- 2026-10-09 · originally logged as ui-planning-test-against-your-own-server · learninghub
- 2026-10-10 · originally logged as test-server-applies-deploy-headers · twogether
- 2026-10-10 · originally logged as mock-server-side-backends · trip-planner
- 2026-10-10 · originally logged as loading-boundaries-can-drop-action-refreshes · trip-planner
- 2026-10-18 · originally logged as scan-after-data-loads · loadout
