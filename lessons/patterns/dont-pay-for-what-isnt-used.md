---
title: "Idle and speculative work must cost nothing the visitor didn't ask for"
status: open
kind: quality
dimension: speed
seen: 2
---
**Principle:** Ambient animation should be finite or paused when idle and never stacked under expensive compositing (blur, filters). Speculative warm-up fetches and parses what an optional feature needs but never builds its heavy runtime (GPU context, worker pool, decoder) before the visitor asks, then keeps it alive for repeats.
**Why it recurs:** Each effect or preload looks cheap alone; the cost appears from combination and from paying it for every visitor.
**Check:** With the page idle, are frames still being produced? Which warm-ups run for every visitor, and is each only network and parse, or does it allocate runtime state a visitor who never uses the feature still pays for?

## Instances
- 2026-10-09 · originally logged as speed-no-idle-animation-under-glass · learninghub
- 2026-10-24 · originally logged as preload-data-not-gpu · loadout
