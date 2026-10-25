---
name: debugging
description: Root-cause debugging: reproduce, measure, one hypothesis, one change, confirm. Use when something is broken, flaky, slow, invisible or not rendering, fails only in CI or on a device, shows a layout or visual bug, when a fix didn't work or a test fails intermittently, or before blaming a tool, library or browser.
---

# Debugging

The failure mode: guessing at causes, changing several things, and declaring victory when the symptom moves. This skill replaces guessing with a loop.

## The loop

1. **State the symptom precisely.** Expected vs actual, where, for whom, since when. One sentence. If the report is vague, ask via `clarify` before touching code.
2. **Reproduce it.** A command, test or click path that shows it on demand. No reproduction means no confirmed fix. For intermittent bugs, loop it (`--repeat-each 20`) until it fails and record the failure rate. If it can't be reproduced, say so and gather evidence instead of fixing.
3. **Shrink it.** Remove inputs, components, and steps until the smallest case still fails.
4. **Measure, don't infer.** Read the real error, the real value, the real network response, the real bounding box. Add logging at the boundary where correct turns into incorrect. Check a baseline: does a trivial case behave the same?
5. **One hypothesis.** Write it down: "X causes Y because Z." Pick the cheapest observation that would disprove it.
6. **Change one thing.** Then rerun the reproduction. If the symptom persists, revert that change before the next hypothesis. Never stack speculative fixes.
7. **Confirm and guard.** Reproduction now passes, then a regression test (or a documented reason there isn't one). Re-run neighbouring tests. Look for the same mechanism elsewhere.
8. **Say what the cause was**, in one sentence, with evidence. If the real cause differs from the first guess, say that too.

## Checks that catch the usual traps

- **Element not visible but code says it renders:** compare its bounding box with its clipping container's, check `elementFromPoint` at its centre, look for an overriding class or `overflow`, then z-index and transforms. Blame the tool last.
- **Layout claims:** render at 375px and the real target size and look; measure contrast from pixels. Wireframes and code reading lie.
- **Performance:** measure a trivial page under the same setup first. Synthetic and headless tools may run GPU work on the CPU and overstate cost. Profile before optimising.
- **Works locally, fails elsewhere:** diff the environments (versions, env vars, headers, case-sensitive paths, timezone, data), not the code.
- **Passes alone, fails in suite:** shared state, order dependence, a port already used by another project's server.
- **Stale UI after a change:** reproduce with many repeats; suspect caching, loading boundaries and optimistic state before the mutation itself.
- **Data bug:** read the actual row or payload, not the type definition.
- **"It worked yesterday":** `git bisect` or compare lockfile and env changes before theorising.
- **An error you don't recognise:** match on the exact error name or code, not a keyword in the message. Search the exact text.

## Rules

- No fix without a reproduction or stated evidence. No "should work now" without running it.
- Never delete or weaken a test to make it pass. Never silence an error to hide it.
- Don't widen scope: note unrelated bugs found, fix them separately.
- After two failed hypotheses, stop, re-read the evidence from step 4, and question the assumption shared by both.
- Use the built-in browser for UI bugs: console, network, DOM and a screenshot beat speculation. See `journey-auditor` for a whole-app pass.
- Log a recurring mechanism to Observer, not the incident.
