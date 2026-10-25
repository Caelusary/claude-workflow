#!/usr/bin/env bash
# PreCompact hook. Cannot write a semantic summary (hooks cannot inject context or call the model),
# so it records only mechanical facts that survive compaction: branch, uncommitted files, recent commits.
# The semantic part of .claude/STATE.md is written by Claude (see the session-state skill).
# Only touches a project that already has .claude/STATE.md; never creates files elsewhere. Always exits 0.

input=$(cat)
cwd=$(printf '%s' "$input" | python -c 'import sys,json;print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null)
[ -n "$cwd" ] || exit 0
root=$(cd "$cwd" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null) || exit 0
f="$root/.claude/STATE.md"
[ -f "$f" ] || exit 0

snap=$(
  cd "$root" || exit 0
  echo "<!-- auto-snapshot:start -->"
  echo "## Auto snapshot (pre-compact, $(date '+%Y-%m-%d %H:%M'))"
  echo "- Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo "- Uncommitted:"
  git status --porcelain 2>/dev/null | head -15 | sed 's/^/  - /'
  echo "- Recent commits:"
  git log --oneline -5 2>/dev/null | sed 's/^/  - /'
  echo "<!-- auto-snapshot:end -->"
)

tmp=$(mktemp)
awk '/<!-- auto-snapshot:start -->/{skip=1} !skip{print} /<!-- auto-snapshot:end -->/{skip=0}' "$f" > "$tmp"
printf '\n%s\n' "$snap" >> "$tmp"
cat "$tmp" > "$f"
rm -f "$tmp"
exit 0
