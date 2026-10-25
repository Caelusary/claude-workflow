---
title: "Bulk and looped writes use a list you built and stop on failure"
status: open
kind: violation
seen: 3
---
**Principle:** Before a bulk write (formatter, codemod, sed, scripted commit loop) build the file list from your own edits and sanity-check its size, never from tool output you have not looked at. A loop must stop or clean up on the first failure so a rejected step cannot be swept into the next. After any scripted edit of structured config (frontmatter, JSON, YAML), validate the result with the strictest parser available, not a lenient regex: a value that merely looks fine can make the loader silently drop it.
**Why it recurs:** Automation amplifies a wrong input: a 10x list or a half-failed step is applied silently to everything after it.
**Check:** Does the bulk command's file count match the number of files actually edited? After a batch of commits, does the log show exactly one file per commit?

## Instances
- 2026-10-10 · originally logged as format-only-named-files · loadout
- 2026-10-10 · originally logged as commit-loop-stops-on-failure · weather-dashboard
- 2026-10-25 · bulk-trimmed skill descriptions; 15 became invalid YAML (unquoted colon) and silently lost their descriptions · setup-overhaul
