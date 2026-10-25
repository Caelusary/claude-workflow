#!/usr/bin/env bash
# SessionStart hook (all sources, incl. "compact"): prints the project's .claude/STATE.md into context
# so a new or compacted session resumes without re-explaining. Silent if the file is absent.
# Only reads STATE.md from the session's own working directory (or its git root).

input=$(cat)
cwd=$(printf '%s' "$input" | python -c 'import sys,json;print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null)
[ -n "$cwd" ] || cwd="$PWD"
root=$(cd "$cwd" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || echo "$cwd")

f="$root/.claude/STATE.md"
[ -f "$f" ] || exit 0

echo "Project state (from $f, written by Claude at the end of earlier work; verify against the repo before relying on it):"
head -c 6000 "$f"
