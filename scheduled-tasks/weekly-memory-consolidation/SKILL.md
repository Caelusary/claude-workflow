---
name: weekly-memory-consolidation
description: Weekly reflective pass over Claude memory files and Observer patterns: merge duplicates, fix stale facts, prune indexes, report changes.
---

Run a weekly maintenance pass on the user's Claude memory. Work in ~/.claude. Be non-destructive: archive instead of deleting, and never touch anything outside ~/.claude/projects/*/memory/ and ~/.claude/lessons/.

1. Memory files: for each folder ~/.claude/projects/*/memory/ that has a MEMORY.md, read the index and the files it points to. Merge duplicate or overlapping memories into one file (keep the better name, keep [[links]] valid). Fix facts that are clearly stale or contradicted by another memory or by the filesystem (verify file/path/function claims exist before keeping them). Make sure each MEMORY.md has exactly one line per memory file, no frontmatter, and no dead pointers. Move retired memory files to a sibling folder named _archive inside that memory folder instead of deleting them. Do not change the meaning of preferences or feedback memories; if two conflict, keep both and list the conflict in your report.
2. Observer patterns: in ~/.claude/lessons/patterns/, merge patterns that describe the same mechanism (move instances over, bump seen:), rewrite any Principle/Why/Check that mentions a specific project, app, file or library so it holds in any app, and set status: applied where a hook or rule now enforces the pattern. Move retired files to ~/.claude/lessons/archive/. Do not edit ~/.claude/CLAUDE.md or any skill.
3. Report in a short list: files merged, files archived, facts corrected, conflicts needing the user's decision, and anything you were unsure about. If nothing needed changing, say so in one line.