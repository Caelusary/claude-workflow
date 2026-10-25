---
title: "Production matches a commit on the production branch"
status: open
kind: workflow
seen: 1
---
**Principle:** What is live should match a commit on the production branch. A CLI deploy ships the local working tree, so uncommitted or half-edited files go live and the next push silently replaces them.
**Why it recurs:** Deploying from a local upload is fast and bypasses the record of what was shipped.
**Check:** Before the first deploy, is the working tree clean and pushed? Does the project deploy from Git rather than from a local upload?

## Instances
- 2026-10-09 · originally logged as workflow-ship-what-is-committed · learninghub
