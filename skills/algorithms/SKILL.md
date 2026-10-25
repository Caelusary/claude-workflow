---
name: algorithms
description: "Algorithm and data-structure choice, complexity, hot paths, and database-side traps (N+1, indexes, pagination). Use when writing or reviewing code that sorts, searches, groups, dedupes, traverses, caches or loops over user-scale data, when slowness may be the approach rather than the implementation, or when choosing a map, set, array or tree."
---

# Algorithms

Judgment about approach and data structure, applied while writing. Complexity is a design decision, not something to discover in profiling later.

## Pick the structure first

Most "slow code" is the right algorithm on the wrong structure. Before optimizing a loop, ask what the access pattern actually is:

| Access pattern | Structure | Not this |
|---|---|---|
| "Is X present?" | `Set` — O(1) | `array.includes` in a loop — O(n·m) |
| "Get the item with id X" | `Map` keyed by id — O(1) | `array.find` in a loop |
| "Group by category" | `Map<key, T[]>` in one pass | filtering the array once per category |
| Ordered, index access | Array | — |
| Insert/remove at front, repeatedly | Deque or index pointer | `array.shift()` — O(n) each |
| Top-k from a large set | Heap, or partial select | full sort then `slice` |

**The single most common real-world bug:** a `.find` or `.includes` nested inside a `.map`/`.filter`. That's O(n·m) hiding behind clean-looking code. Build a `Map` or `Set` before the loop instead — it's usually a two-line change from quadratic to linear.

## Complexity that actually matters

- State the complexity in terms of **what grows** — number of books, results per page, characters typed. `O(n²)` on n=5 tabs is fine; `O(n log n)` on every keystroke is not.
- **Constants matter at small n.** A linear scan of 20 items beats building a hash map for one lookup. Don't add a structure to avoid a loop that runs twice.
- **Watch the hidden loop.** `spread` inside `reduce` (`{...acc, [k]:v}`) is O(n²) — it copies the accumulator every iteration. Mutate the accumulator or use a `Map`.
- Repeated `sort` inside a render or loop is a common accidental O(n² log n). Sort once, outside.
- Nested data + recursion: know whether the input can be deep enough to blow the stack, and whether the same subproblem is recomputed (memoize if so).

## Hot paths

Code is a hot path if it runs per keystroke, per frame, per item in a large list, or per request. There, prefer:

- Doing work **once outside** the loop rather than per-iteration.
- **Early exit** — `some`/`find` over `filter().length > 0`; return as soon as the answer is known.
- **Not allocating** in the loop when it can be hoisted.
- **Debounce or throttle** at the source rather than making downstream work faster.

For search-as-you-type specifically: debounce the input, cancel superseded requests, and cache by normalized query — that beats any micro-optimization of the matching itself.

## Correctness before cleverness

- The clear O(n log n) beats the clever O(n) you can't explain in a comment. Write the obvious version first; replace it only when the input size justifies it and you can say why.
- Comparison and equality are where subtle bugs live: locale-aware string compare (`localeCompare`) vs. byte order, `NaN` in sorts, `-0`, object identity in `Set`/`Map` keys, floating-point equality.
- A sort comparator must be consistent — return a number, handle ties, and never depend on the original order unless the sort is documented stable.
- Off-by-one lives in pagination, slicing, and binary search bounds. Test the empty case, the single-item case, and the exact-boundary case.

## When asked to make something faster

Identify the complexity class first. If it's quadratic on growing data, fix the approach — no amount of micro-optimization saves a bad one. If it's already linear and still slow, *then* it's an implementation or I/O problem, and belongs to the `performance` skill.

## Where the data lives

The same mistakes happen one layer down. Check these whenever code talks to a database or API:

- **N+1 queries:** a query inside a loop over rows. Fetch the set in one query (join, `in (...)`, or an RPC) and index the result with a `Map`.
- **Filter, sort and paginate on the server**, not after downloading everything. Return only the columns a viewer needs.
- **Indexes:** every column used in a `where`, `order by` or join on a large table; foreign keys; columns referenced by row-level security policies.
- **Unbounded results:** every list endpoint has a limit. Prefer keyset (cursor) pagination over large `offset`.
- **Counting and aggregation:** let the database do it; don't fetch rows to count them.
- **Idempotency and races:** a read-then-write sequence needs an atomic update or a unique constraint, not an in-memory check.
