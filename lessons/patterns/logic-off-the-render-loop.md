---
title: "Timed logic ticks on its own clock; rendering only draws"
status: open
kind: quality
dimension: speed
seen: 1
---
**Principle:** Anything with real timings (countdowns, detection windows, simulations) runs on its own steady timer with measured elapsed time. The render loop only draws, so frame rate never changes what happens or when.
**Why it recurs:** Tying logic to frames is the simplest implementation and breaks under throttling, background tabs and slow devices.
**Check:** Throttle the page to 5 fps or run it headless: do timers, countdowns and state changes still happen on schedule?

## Instances
- 2026-10-10 · originally logged as speed-logic-off-the-render-loop · bantay-buhay 3D prototype
