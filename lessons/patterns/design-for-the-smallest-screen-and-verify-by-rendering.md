---
title: "Small screens get their own design, confirmed by rendering"
status: open
kind: quality
dimension: ui-planning
seen: 3
---
**Principle:** Small screens need their own layout decisions about what is primary and what is tucked away, not desktop elements shrunk until they overflow. Claims about layout are verified by rendering at the sizes it will be seen and measuring, and when something is not visible, compare its box with its clipping parent before blaming tools.
**Why it recurs:** Wireframes and code reading hide collisions, clipping, low contrast and overridden styles; the first real render is the first honest one.
**Check:** Open every screen at 375px and at the presentation size: does anything overflow, crowd, or exist only because desktop had it? For each 'not visible' report, is the element's rect inside its clipping parent?

## Instances
- 2026-10-08 · originally logged as ui-planning-phones-get-their-own-design · loadout
- 2026-10-17 · originally logged as render-before-claiming-layout · pasabi
- 2026-10-23 · originally logged as check-geometry-before-blaming-the-tool · loadout
