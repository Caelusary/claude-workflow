---
name: audit-agents-report-only
description: Run several audit subagents report-only, and keep security agents to static analysis
metadata:
  type: feedback
---

When running several audit agents against one codebase, tell each one "report only, no edits" and that others are running concurrently. Their definitions allow fixing things directly, and several agents writing the same files at once corrupts the work. Consolidate findings, then apply fixes in the main session.

**Why:** five agents (architecture, QA, security, performance, devops) produced findings that deduplicated cleanly into one ordered list. A security agent that went beyond reading code into live probing (forged requests, repeated failed logins) left entries in real auth logs.

**How to apply:** say up front whether live testing is in scope (default: no), pass each agent the settled constraints (rejected approaches, intentional choices) so it doesn't re-litigate them, and disclose it if an agent probes anyway.
