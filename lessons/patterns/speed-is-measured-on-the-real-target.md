---
title: "Measure against a baseline on realistic devices, then scale work down"
status: open
kind: quality
dimension: speed
seen: 2
---
**Principle:** Fast on a good laptop is not fast. Detect weak devices (memory, cores, data saver, measured frame rate) and scale work down. Before treating a cost as a problem, measure a trivial page under the same setup, and remember synthetic tools may render GPU work on the CPU and overstate it.
**Why it recurs:** Measurements are taken on the developer's machine, or on a tool whose artifacts get blamed on the app.
**Check:** How does this feel on a 2-core phone with data saver on? For each speed finding, what does a bare page score under the same throttling, and is the cost one a real device would pay?

## Instances
- 2026-10-08 · originally logged as speed-measure-and-degrade-gracefully · loadout
- 2026-10-12 · originally logged as calibrate-before-optimising · loadout
