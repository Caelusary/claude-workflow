#!/usr/bin/env bash
# SessionStart hook: one-line pointer to the Observer quality bar (full checks are read on demand by the observer skill).
# Counts open quality patterns per dimension in ~/.claude/lessons/patterns.

dir="$HOME/.claude/lessons/patterns"
[ -d "$dir" ] || exit 0

summary=$(awk '
  FNR == 1 { dim = ""; status = ""; kind = "" }
  /^dimension:/ { dim = $2 }
  /^status:/    { status = $2 }
  /^kind:/      { kind = $2 }
  /^\*\*Check:\*\*/ && kind == "quality" && status == "open" { n[dim]++; total++ }
  END { for (d in n) printf "%s %d, ", d, n[d]; printf "|%d", total }
' "$dir"/*.md 2>/dev/null)

total=${summary##*|}
[ -n "$total" ] && [ "$total" -gt 0 ] || exit 0
counts=${summary%|*}
echo "Quality bar: ${total} open patterns in ~/.claude/lessons/patterns (${counts%, }). When starting a project or significant feature, load the observer skill and hold the work to the checks for its dimensions. Raise gaps as standards, never as 'copy project X'."
