#!/usr/bin/env bash
# Claude Code PreToolUse hook (matcher: Bash). Blocks production deploys that would ship
# the local working tree instead of a pushed commit.
# Rule: what is live must match a commit on the production branch.
# Exit 2 = block, message goes to Claude. Everything else passes silently.

input=$(cat)

parsed=$(printf '%s' "$input" | python -c '
import sys, json
d = json.load(sys.stdin)
print(d.get("cwd", ""))
print((d.get("tool_input") or {}).get("command", "").replace("\n", " "))
' 2>/dev/null) || exit 0

cwd=$(printf '%s\n' "$parsed" | sed -n 1p)
cmd=$(printf '%s\n' "$parsed" | sed -n 2p)

# Only CLI production deploys: `vercel --prod`, `vercel deploy --prod`, `vercel deploy ... --prod`.
printf '%s' "$cmd" | grep -Eq '(^|[;&| ])(npx[[:space:]]+)?vercel([[:space:]]+deploy)?([[:space:]].*)?--prod' || exit 0

[ -n "$cwd" ] && cd "$cwd" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

dirty=$(git status --porcelain 2>/dev/null)
unpushed=""
if git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1; then
  unpushed=$(git rev-list '@{u}..HEAD' 2>/dev/null)
else
  unpushed="(no upstream branch)"
fi

if [ -n "$dirty" ] || [ -n "$unpushed" ]; then
  {
    echo "Blocked production deploy: the tree does not match a pushed commit."
    [ -n "$dirty" ] && { echo "Uncommitted changes:"; echo "$dirty" | head -10; }
    [ -n "$unpushed" ] && echo "Unpushed commits or no upstream: $(echo "$unpushed" | head -3 | tr '\n' ' ')"
    echo "Commit and push first, then deploy from Git (push to the production branch). Ask the user before overriding."
  } >&2
  exit 2
fi
exit 0
