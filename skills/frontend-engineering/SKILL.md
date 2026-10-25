---
name: frontend-engineering
description: React 19.2 and Next.js 16 structure: component APIs (compound components, explicit variants), state placement and context, data fetching, Server Components and actions, forms, effects. Use when building or refactoring components, deciding where state lives, wiring data, or when a component has piled-up boolean props. Visual craft: design-taste.
---

# Frontend Engineering

The structural half of frontend work: what a component's API looks like, where state lives, how data arrives, and what re-renders. Visual craft belongs to `design-taste` — the two are complementary and often both apply.

## Rule priority

| Priority | Category | Impact | Prefix |
|---|---|---|---|
| 1 | Component architecture | HIGH | `architecture-` |
| 2 | State management | MEDIUM | `state-` |
| 3 | Implementation patterns | MEDIUM | `patterns-` |
| 4 | React 19 APIs | MEDIUM | `react19-` |

Read the matching file in `rules/` for the full explanation with correct/incorrect examples.

## Core rules

**Component architecture (HIGH)**
- `architecture-avoid-boolean-props` — don't add boolean props to customize behavior; compose instead. Two booleans give four states, three give eight, and most combinations are nonsense you still have to handle.
- `architecture-compound-components` — structure complex components with shared context rather than one component taking a large config object.

**State management**
- `state-lift-state` — move state into a provider when siblings need it, not into a common ancestor that then prop-drills.
- `state-decouple-implementation` — the provider is the *only* place that knows how state is managed. Consumers see an interface, so swapping `useState` for a reducer or a server cache touches one file.
- `state-context-interface` — expose a generic `{ state, actions, meta }` interface so the implementation can be injected and tested.

**Implementation patterns**
- `patterns-explicit-variants` — create named variant components instead of boolean modes.
- `patterns-children-over-render-props` — use `children` for composition rather than `renderX` props.

**React 19**
- `react19-no-forwardref` — `ref` is a regular prop now. Use `use()` over `useContext()`.

## Where state belongs

Work down this list and stop at the first that fits — reaching past a level you didn't need is the usual source of over-engineering:

1. **Derived from existing state** — compute it during render. Not state at all. Most "sync these two pieces of state" bugs are this mistake.
2. **Local `useState`** — one component owns it, nothing else reads it.
3. **Lifted to the nearest real owner** — siblings need it. Lift to where it's *owned*, not to the root.
4. **URL** — filters, tabs, pagination, search queries, expanded panels. If a user would reasonably expect to bookmark, share, or reload into that view, it goes in the URL. This is the most commonly missed one.
5. **Context via a provider** — genuinely cross-cutting (theme, session, a shared collection).
6. **External store** — only for real cross-tree, high-frequency, or persisted state.

Server data is not UI state. Cache it, key it, and give it explicit loading/error/empty states rather than mirroring it into `useState` and hand-syncing.

## Data fetching

- Every fetch has four outcomes, not two: loading, error, empty, and success. Empty is not an error and must not render as one.
- Fetch in an effect only when nothing better exists; prefer a router loader or a caching layer. If you do use an effect, handle cancellation — an unmounted component or a superseded request must not write state.
- Race conditions in search-as-you-type are the default, not the exception. Debounce input, and ignore responses that arrive out of order (track the latest request, or use `AbortController`).
- Don't fetch waterfalls: sequential `await`s that don't depend on each other should be `Promise.all`.

## Rendering

- Reach for `memo`/`useMemo`/`useCallback` when there is a measured problem or an obviously expensive computation — not reflexively. Wrapping everything adds its own cost and hides the real issue.
- A key must be a stable identity from the data. Array index as key is a bug the moment the list reorders, filters, or deletes.
- Effects are for synchronizing with something *outside* React. If an effect only computes from props/state, delete it and compute during render.
- Every effect that subscribes, times, or observes needs a cleanup return.

## React 19 and 19.2 APIs

- **Forms and mutations:** `useActionState` for an action's state and pending flag, `useFormStatus` inside a form's children, `useOptimistic` for instant UI that reconciles with the server result. Always render the failure: an optimistic update that fails must roll back visibly with a retry.
- **`use()`** reads a promise or context (and can be called conditionally); pair promises with Suspense boundaries and an error boundary.
- **`useEffectEvent` (19.2):** extract the non-reactive "event" part of an effect so the values it reads don't re-run the effect. Never put an Effect Event in a dependency array; use it only for functions conceptually fired from an effect (a notification on connect).
- **`<Activity mode="visible"|"hidden">` (19.2):** hide UI while keeping its state, unmounting its effects and deferring its updates. Good for tabs and back-navigation state, instead of unmounting and losing state.
- **React Compiler:** rely on it for memoization in new code and keep the Rules of React (pure render, no mutation of props/state, no ref reads in render). Run `eslint-plugin-react-hooks@latest`; its rules flag `setState` in render and unsafe ref access.
- **Error boundaries + Suspense:** every async boundary has a loading fallback shaped like the content and an error fallback with a retry. A failed load is never rendered as empty.

## Next.js App Router (16)

- **Server vs client:** default to Server Components. Add `"use client"` only for state, effects, browser APIs or event handlers, and push it down to the smallest leaf. Server Components can pass server-rendered children and serializable props into client components.
- **Server Actions** are public HTTP endpoints. Each one validates its input with a schema and re-checks authentication and ownership/role itself; never trust that the UI hid the button or that the proxy ran. Return typed results (success, field errors, failure) so the UI shows specific messages.
- **`proxy.ts` replaced `middleware.ts`** (Node runtime; rename the file and export `proxy`). Use it for redirects and coarse gating, not as the only authorization layer. Authorization belongs where data is read or written.
- **Async request APIs:** `await params`, `await searchParams`, `await cookies()`, `await headers()`.
- **Caching:** opt-in via `cacheComponents` and `"use cache"`; after a mutation use `updateTag` (read-your-writes) or `revalidateTag(tag, profile)`; never cache per-user data in a shared cache.
- **Data access layer:** one server-only module per feature owns queries, selects only the fields a viewer may see (omit the rest server-side), and is the only code that touches the database. Mark it `server-only`.
- **Parallel routes** need an explicit `default.js`. `next lint` no longer exists; run ESLint or Biome directly.
- Test against the production build with a mocked backend (server-side calls cannot be intercepted by browser route mocking); see the `testing-standards` e2e scaffold.

## Related skills

`design-taste` (visual craft), `performance`, `architecture`, `testing-standards`, `secure-and-compliant` (authorization, exposure), `debugging`.
