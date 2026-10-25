---
name: summarize
description: "Project status in a fixed three-table format: not done yet (buildable now), tied to deployment, needs their decision. Use on 'summarize', 'summary', 'what's left', 'what's not done', or any status request."
---

# Summarize

When the user says "summarize", produce exactly this format. No other structure, no recap of finished work unless they ask.

## Step 1: work out where the project stands

Check this; don't assume. Projects differ: some have never been committed, others are on GitHub, others are live.

- **Git:** run `git status -sb`, `git log --oneline -5` and `git remote -v`. Note whether there are commits, a remote, and unpushed or uncommitted work.
- **Deployment:** look for deploy config (`vercel.json`, `render.yaml`, `netlify.toml`, `Dockerfile`, `.github/workflows/`, `fly.toml`) and for a live URL in the README, `package.json` `homepage`, env examples or memory. If `gh` is available and there's a remote, `gh repo view --json homepageUrl,url` and `gh run list -L 3` show the live URL and the CI state. A placeholder URL such as `REPLACE-WITH-...` means it isn't deployed.
- Classify the project as one of:
  - **Local only:** no commits or no remote.
  - **On GitHub, not deployed.**
  - **Deployed:** a live URL exists and the config points at real hosts.

Then read the project's `.claude/STATE.md` (if present) and its open-items memory, and verify each item against the current code. Drop anything already done. Don't invent items to fill a table; an empty section gets one line saying "Nothing."

## Step 2: write it

At most one opening line, giving the project's status in a few words, such as "Deployed at <url>, CI passing, 3 commits not pushed." Add a rule they just set if one needs acknowledging. Then three sections, in this order, each a table.

### 1. `## Not done yet, buildable now`

| Section | Item | Notes |
|---|---|---|

- **Section:** the area of the system, such as Checkout, Mobile UI, Speed, Code quality, Tests, Housekeeping, Accounts or Admin. Group rows by section.
- **Item:** a short name.
- **Notes:** one or two factual sentences, giving the concrete gap and numbers where known.
- Only work that can happen locally right now without their input. Anything needing their OK, such as a deletion, still goes here, but say so in Notes.
- **Deployed projects:** say in Notes whether the item also needs a redeploy to reach the live site.

### 2. The deployment section

Its heading and columns depend on the status:

- **Local only, or on GitHub but not deployed:** `## Can only be done once deployed`

  | Item | What's involved |
  |---|---|

  This covers hosting, env vars, external-service setup, live-only checks such as proxy IP and real email delivery, backups, monitoring and real-device testing.

- **Deployed:** `## Live site` — what differs between the code and what's running, and what has to happen on the hosting side.

  | Item | State | What's involved |
  |---|---|---|

  This covers changes not pushed or not yet deployed, failing CI, env vars or services still missing in production, live-only checks not yet run, backups, monitoring, domain and SSL. **State** is a short tag: `not pushed`, `pushed, not deployed`, `CI failing`, `missing in prod`, `not checked live` or `ongoing`.

### 3. `## Needs your decision`

| Item | Options | My take |
|---|---|---|

- **Options:** the actual choices (include open questions from STATE.md and decisions delegated with "I don't know" that they may want to revisit), with the current behavior marked "(current)" if one is already built.
- **My take:** a short recommendation. Never leave it blank or noncommittal.

## Rules

- Tables only inside the three sections; no bullet lists, no extra headings.
- Peer tone and plain language. Define a term of art in one clause on first use.
- No closing paragraph or offer, just the three tables.
- **Git and GitHub items:**
  - Include them only when they're real for this project's status: unpushed commits or failing CI on a GitHub project, a missing remote when deploying depends on one.
  - Don't nag about committing a local-only project unless they raised it or the project's memory says to.
  - Never commit, push or deploy as part of a summary; it's read-only.
