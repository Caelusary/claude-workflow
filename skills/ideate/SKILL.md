---
name: ideate
description: Find and shape product ideas. DISCOVER researches an area on the web and returns 5-8 grounded, non-generic ideas; EXPLORE maps one idea's needs, limits and scope, then hands off to project-blueprint. Use when given a theme or area, or they say 'I need an idea', 'what could I build', 'find a gap', or asks to flesh out, scope, map or stress-test an idea or what it needs.
---

# Ideate

Good ideas rarely start with "revolutionary". They start with a small, repeated annoyance that people have stopped noticing. This skill finds those, then maps the one they pick.

Pair with `clarify` throughout: where a choice belongs to the user (theme boundary, audience, constraints), ask, don't assume.

## Phase 1: DISCOVER

Input: an area or theme. Output: 5-8 ideas, each grounded in evidence.

### 1. Frame (ask first, via clarify)

Pin down: who it's for (or "open"), what they can realistically build and run alone (time, budget, stack), platform (web, mobile, desktop), anything excluded, whether it should earn money or just be useful. Don't research until framed. A wrong frame wastes the whole run.

### 2. Research thoroughly

Use WebSearch (extended mode for niche themes) and WebFetch. Run searches in parallel, and go several layers deep. Sources, in order of value:

- **Complaints and workarounds:** forum and community threads, subreddit posts, review sections (1-3 star reviews of existing apps), "how do I…" questions, Stack Exchange, app-store reviews.
- **Spreadsheets and hacks:** people solving it with a Google Sheet, a Notion template, a group chat, paper. Every hack is a product asking to exist.
- **Open issues and feature requests** on tools in the area: what users keep asking for that maintainers decline or ignore.
- **Adjacent fields** that solved the same problem differently.
- **Existing products** (competitors), their pricing, their gaps, what they bolted on.
- **Recent change** (new regulation, platform shift, new API) that makes an old problem newly solvable.

Keep a running evidence list: claim, source URL, date. Prefer evidence from the last 2 years. If a source can't be fetched, say so, don't invent it. If something is only one person's complaint, label it as one voice.

### 3. Mine for friction

Look for: repeated workarounds, "I wish", things done manually every day, steps everyone skips, tools used for something they weren't built for, tiny costs paid millions of times. Prefer a narrow, sharp pain over a broad vague one.

### 4. Generate, then filter

Draft more ideas than needed (15-20), then cut. Drop an idea if any of these hold:

- An incumbent already does it well enough and there's no wedge.
- It's the category's obvious default (the "AI-powered X", the todo/habit/notes clone, the generic marketplace).
- It needs a network effect, regulatory licence, or large data set they can't get.
- No named person with the pain.
- It only works once the product already has users.

Keep ideas that are small to start, make a specific person's day measurably better, and have a believable first 10 users.

### 5. Present 5-8 ideas

For each idea, in this shape:

```
### <Name> — one-line pitch
Who has it:       specific person, specific moment
The friction:     what they do today instead (the workaround)
Evidence:         2-3 sources with links; mark single-voice claims
Why existing tools miss it:   concrete gap
The wedge:        smallest version that is useful on day one
Why now:          if there's a change making it timely
Risks / kill criteria:   what would prove it wrong
Build size:       days / weeks / months for one person
```

Then a short ranked recommendation with the reason, and what you were unsure about. Offer to run EXPLORE on any one.

## Phase 2: EXPLORE

Input: one chosen idea. Output: a map of what it needs and where it stops. This is not the architecture; that is `project-blueprint`'s job.

Ask via `clarify` before mapping anything undecided. Then produce:

1. **Job to be done:** the one sentence the product must win.
2. **Users and roles:** each role, what they can and cannot see or do.
3. **Core loop:** the repeated action that delivers value, and its time to first value.
4. **Functionality map:** must-have (day one), should-have, later, and explicitly **not** doing (with the reason for each exclusion).
5. **Data:** what is created, stored, shared; who owns it; what is personal; retention and deletion.
6. **Every state:** empty, first-run, loading, error, offline, too-much-data, abuse for each key screen.
7. **Limits and boundaries:** scale, cost per user, rate limits, content limits, what the product refuses.
8. **Dependencies and constraints:** third-party services, platform rules, costs, licences, anything they don't control.
9. **Abuse and failure:** how a bad actor or a cheater uses it, what happens when a dependency is down. Hand details to `secure-and-compliant`.
10. **Legal/privacy triggers:** flags only (accounts? kids? payments? tracking?), details go to `secure-and-compliant`.
11. **Success measures:** what number says it works within 30 days, and what says stop.
12. **Open questions:** anything unresolved, each marked for clarify.

### Handoff

When the map is approved, pass it to `project-blueprint` as its Step 1 input so discovery questions are not repeated. Deliver DISCOVER and EXPLORE results as an Artifact if the user wants to share or reread them; keep the file too.

## Rules

- Never present an idea without evidence. "I think people want this" is not a finding.
- Don't pad to reach 8. Five strong beat eight so-so.
- Be honest about weak evidence and crowded markets. A kill criterion is a feature.
- Never fabricate sources, quotes, or numbers.
