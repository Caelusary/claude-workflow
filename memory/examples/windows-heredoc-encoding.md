---
name: windows-heredoc-encoding
description: Shell heredocs on Windows corrupt non-ASCII characters in files written by scripts
metadata:
  type: feedback
---

Scripted edits via `python - <<'EOF'` in Git Bash wrote `·` and `…` as U+FFFD (bytes ef bf bd). Nothing flagged it; it only showed up later as garbled text in the UI.

**Why:** the heredoc passes through the console code page before Python sees it, so non-ASCII is lost before the UTF-8 write.

**How to apply:** for any string with non-ASCII characters, use the Edit/Write tools, or Python `\u` escapes. After a scripted multi-file edit, grep for `$'\xef\xbf\xbd'` to catch damage.
