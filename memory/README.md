# Memory

Claude Code keeps per-project memory in `~/.claude/projects/<project>/memory/`. Each memory is one small file with frontmatter, and `MEMORY.md` in the same folder is a one-line-per-memory index.

Real memories are specific to my projects, so they are not published here. This folder holds the format and two generic examples (`examples/`). The cross-project layer lives in `../lessons/patterns/`, written by the `observer` skill, and `../scheduled-tasks/weekly-memory-consolidation/` is the weekly cleanup pass.

## File format

```markdown
---
name: short-kebab-case-slug
description: one-line summary used to decide relevance
metadata:
  type: user | feedback | project | reference
---

The fact. For feedback and project memories, follow with:

**Why:** the reason or incident behind it.
**How to apply:** when and how it should change behavior.
```

## Index format (`MEMORY.md`)

```markdown
- [Title](file.md) - one-line hook
```

One line per memory, no frontmatter, no memory content in the index.
