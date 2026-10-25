---
name: architecture
description: Structural judgment while writing code: where files belong, when to extract, module boundaries, coupling, server/client boundaries, API shape. Use when adding files or features, when a file is growing, when deciding to share logic, or when naming and organizing modules. Whole-repo audits: code-architect agent.
---

# Architecture

Structural decisions made while writing, when they're still cheap. The recurring failure mode is not too little structure — it's structure added before it was earned.

## When to extract

- **Duplication is not automatically a problem.** Two similar blocks that change for *different reasons* should stay separate; merging them creates a shared thing that both sides fight over. Extract on the third occurrence, when the reason for change is genuinely the same.
- **An abstraction must absorb real volatility.** If an interface, wrapper, or factory doesn't remove a variation that actually happens, it's indirection with a cost and no benefit. An extension point with no second implementation is debt, not flexibility.
- **Prefer deleting to abstracting.** The cheapest resolution of duplicated logic is often that one copy shouldn't exist.
- A helper used once belongs next to its caller, not in `utils/`.

## Where code belongs

- **Group by feature, not by kind**, once the project is past a handful of files. `books/` containing its component, hook, and API call beats those three living in `components/`, `hooks/`, and `api/` — feature work then touches one directory instead of three.
- Keep the layers honest: fetching in a hook or loader, not inside a presentational component; formatting near render, not in the data layer. When a component both fetches and renders, split it when it needs a second consumer — not before.
- **`utils/` is where unowned code goes to hide.** If something lands there, ask what it's actually *about* and file it under that.
- A file over ~300 lines is a prompt to look, not an automatic split. Split when it holds two things that change independently — a mechanical split at a line count just makes two files you always open together.

## Coupling and boundaries

- Depend on what you need, not on the module that happens to contain it. Importing a whole feature module for one constant couples you to all of it.
- **Import cycles matter when they cost something** — a change ripple, a test you can't isolate, a load-order bug. A cycle that costs nothing today is worth noting, not stopping for.
- Watch direction: shared/low-level code must not import from feature/high-level code. That inversion is what turns a small module into a load-bearing one.
- State a module's contract in its exports. A file that exports everything has no contract, and every internal becomes someone's dependency.

## API and naming

- Name by what it *is or does* for the caller, not how it's built. `useBookSearch` over `useApiWrapper`.
- Booleans that select behavior are a design smell in functions the same way they are in components — a function with `(id, true, false)` at the call site needs named options or separate functions.
- Consistency beats individual preference: one casing convention, one file-naming convention, one error shape. Match what's already in the codebase even when you'd have chosen differently.
- Return shapes should be predictable across similar functions — if one returns `null` on miss and another throws, callers can't be written uniformly.

## Guardrails

- **Modernization needs a present defect or a measurable simplification.** "This is the old way" is not a reason to restructure working code.
- **Naming a pattern is not evidence it helps.** Judge fitness against this project's actual size and needs, not against a canonical example.
- Folder names are not architecture. What imports what is the architecture.
- Leave structure better than you found it in the area you're touching; don't reorganize adjacent code you weren't asked to change.

## Server and client boundaries

- Decide for each piece of logic where it must run: **anything that enforces trust (authorization, validation, pricing, scoring, status transitions) runs on the server**; the client only presents and requests. Duplicating a check on the client for speed is fine, trusting it is not.
- One server-only data-access module per feature owns queries and field selection; UI code never touches the database directly.
- Share validation schemas between client and server so the rules can't drift; the server still validates.
- Keep boundary files thin (routes, actions, proxies): parse input, call a function in the feature, shape the output.

## Record decisions

A non-obvious structural choice gets one line of *why* where the next person will look: the project `CLAUDE.md` for conventions, `.claude/STATE.md` (`session-state`) for in-flight decisions. A decision nobody can find gets re-litigated.

## Related skills

`frontend-engineering`, `performance`, `secure-and-compliant`, `project-init`, and the `code-architect` agent for whole-repo audits.
