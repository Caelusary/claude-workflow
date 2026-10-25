#!/usr/bin/env bash
# Git pre-commit: blocks commits that add secret-looking strings or real .env files.
# Intended home: ~/.githooks/pre-commit (global core.hooksPath), chains to the repo's own hook.
# Opt out for one line with a trailing comment:  allow-secret
# Opt out for one commit:  SKIP_SECRET_SCAN=1 git commit ...

# One file per commit. Exempt: merges, cherry-picks, rebases, the repo's first commit, ALLOW_MULTI_FILE=1.
gitdir=$(git rev-parse --git-dir)
if [ -z "$ALLOW_MULTI_FILE" ] && [ ! -f "$gitdir/MERGE_HEAD" ] && [ ! -f "$gitdir/CHERRY_PICK_HEAD" ] \
   && [ ! -d "$gitdir/rebase-merge" ] && [ ! -d "$gitdir/rebase-apply" ] && git rev-parse --verify -q HEAD >/dev/null; then
  changes=$(git diff --cached --name-status -M)
  count=$(printf '%s\n' "$changes" | grep -c .)
  if [ "$count" -gt 1 ]; then
    echo "pre-commit: $count files staged, but the rule is one file per commit:" >&2
    printf '%s\n' "$changes" | head -10 | sed 's/^/  /' >&2
    echo "  Commit each separately:  git add <file> && git commit -m \"type(scope): message\" -- <file>" >&2
    echo "  Deliberate exception:    ALLOW_MULTI_FILE=1 git commit ..." >&2
    exit 1
  fi
fi

if [ -z "$SKIP_SECRET_SCAN" ]; then
  found=0

  # 1) Real env files (examples/templates are fine).
  while IFS= read -r f; do
    case "$f" in
      *.example|*.sample|*.template|*.dist) ;;
      .env|*/.env|.env.*|*/.env.*)
        echo "pre-commit: refusing to commit env file: $f" >&2; found=1 ;;
    esac
  done < <(git diff --cached --name-only --diff-filter=AM)

  # 2) Secret-looking content in added lines only.
  patterns='AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{40,}|xox[baprs]-[A-Za-z0-9-]{10,}|sk-[A-Za-z0-9_-]{20,}|sk_live_[A-Za-z0-9]{16,}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----|mongodb(\+srv)?://[^[:space:]:@/]+:[^[:space:]@]+@|postgres(ql)?://[^[:space:]:@/]+:[^[:space:]@]+@|eyJ[A-Za-z0-9_-]{15,}\.eyJ[A-Za-z0-9_-]{15,}\.[A-Za-z0-9_-]{15,}|(api[_-]?key|secret|token|passw(or)?d|service[_-]?role)[A-Za-z0-9_]*["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"'[:space:]]{16,}["'"'"']'

  hits=$(git diff --cached --no-color -U0 --diff-filter=AM \
    | grep -E '^\+[^+]' | grep -v 'allow-secret' | grep -E -i "$patterns")

  if [ -n "$hits" ]; then
    echo "pre-commit: possible secret in staged changes (values masked):" >&2
    echo "$hits" | cut -c1-200 | sed -E 's/([A-Za-z0-9_+\/=-]{6})[A-Za-z0-9_+\/=.-]{8,}/\1…[masked]/g' | head -10 >&2
    found=1
  fi

  if [ "$found" -ne 0 ]; then
    echo "  Fix: remove it, rotate it if it was ever pushed, load it from the environment instead." >&2
    echo "  False positive? add the comment 'allow-secret' on that line, or SKIP_SECRET_SCAN=1 for one commit." >&2
    exit 1
  fi
fi

local_hook="$(git rev-parse --git-dir)/hooks/pre-commit"
[ -x "$local_hook" ] && exec "$local_hook" "$@"
exit 0
