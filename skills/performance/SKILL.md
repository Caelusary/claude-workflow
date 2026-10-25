---
name: performance
description: Make code fast while writing it: React rendering and Compiler, Next.js caching, bundle size, waterfalls, images/fonts, Core Web Vitals, weak-device behavior. Use when building, when something feels slow, or to optimize. Algorithms: algorithms skill; repo audit: performance-engineer.
---

# Performance

Applied while writing, so the code is fast the first time. Two rules govern everything below.

**Measure before claiming.** Define the metric and the threshold *before* you change anything, compare the same workload on both sides, and never move the goalpost after seeing results. "This should be faster" is not a result.

**Fix the class of problem, not the symptom.** A quadratic loop, a request waterfall, and a 400KB dependency are different problems; micro-optimizing the wrong one wastes the effort. Identify which you have first.

## React rendering

- **React Compiler (1.0, stable) memoizes automatically at build time**, including conditionally after early returns, which hand-written hooks can't do. For new code, rely on the compiler and keep `useMemo`/`useCallback` as an escape hatch (for example a memoized value used as an effect dependency). Leave existing memoization in place or test before removing it. The compiler assumes the Rules of React; run `eslint-plugin-react-hooks@latest`, and pin the compiler's exact version if test coverage is thin. In Next.js 16 enable it with `reactCompiler: true` (stable, off by default, slower builds).
- Without the compiler, `memo`/`useMemo`/`useCallback` are for a **measured** problem or an obviously expensive computation. Applied reflexively they add comparison cost, defeat themselves via unstable deps, and hide the real cause. The usual real fix is moving state down or passing `children`, not memoizing.
- State that changes on every keystroke should live in the smallest component that needs it. Lifting it high re-renders the whole subtree per character.
- A new object, array, or arrow function in JSX props creates a fresh identity every render — that's what actually breaks a `memo` boundary downstream.
- Long lists: virtualize past a few hundred rows, or use `content-visibility: auto` for a cheap win. Stable keys from data identity, never array index.
- Derive during render instead of syncing with an effect. An effect that only computes from props/state is a re-render you're paying for twice.

## Network

- **Waterfalls are the biggest real-world cost.** Independent `await`s must be `Promise.all`. A request that depends on a previous response is a waterfall by design — see whether it can be flattened or prefetched.
- Debounce user-driven requests at the source; cancel superseded ones with `AbortController`. Search-as-you-type without this fires a request per keystroke and can render stale results out of order.
- Cache by normalized key. Repeat searches, back-navigation, and re-mounts should not refetch.
- Set explicit loading, error, and **empty** states — empty is not an error, and rendering it as one is both a UX bug and usually an extra request.

## Bundle

- Check real numbers from the build output, not intuition — `vite build` reports chunk sizes.
- Import what you use. A barrel import (`import { x } from '../components'`) can pull the whole barrel into the graph.
- Before adding a dependency for one function, check the cost. Date formatting, deep clone, `uniq`, and class-name joining are usually a few lines or already native (`Intl`, `structuredClone`, `Set`, template strings).
- Route-level `lazy()` + `Suspense` is the highest-leverage split. Split heavy, rarely-used views (editors, charts, modals) rather than micro-splitting everything.

## Assets

- Images: modern format (WebP/AVIF), explicit `width`/`height` to prevent layout shift, `loading="lazy"` below the fold, and *no* lazy on the LCP image — that one needs priority.
- Fonts: `font-display: swap`, preload the one face used above the fold, subset if possible, and cap the number of weights. Every extra weight is another file.
- Externally-hosted images (e.g. cover art from an API) still need fixed dimensions and a fallback for the broken/missing case.

## Core Web Vitals

Targets at the 75th percentile of real users: **LCP <= 2.5 s, INP <= 200 ms, CLS <= 0.1**. INP replaced FID in 2024. Lab tools (Lighthouse) approximate; field data decides.

- **LCP** — usually the hero image or the first text block. Don't lazy-load it, don't block it behind a fetch, don't hide it behind a spinner that waits on non-critical data.
- **CLS** — reserve space for anything that arrives late: images, fonts, async content, banners. Skeletons must match the final dimensions or they cause the shift they were meant to prevent.
- **INP** — keep event handlers cheap. Heavy work on input, scroll, or resize should be debounced, throttled, or deferred.

## Rule library

`rules/` holds 60 granular React and JS performance rules (from Vercel Engineering's react-best-practices, MIT), each with correct/incorrect examples. Next.js/RSC-specific rules have been removed — the Vite + React rules apply everywhere, and the Next.js section below covers what was removed.

| Prefix | Count | Covers |
|---|---|---|
| `rerender-` | 15 | Derived state, memo, functional setState, lazy init, splitting hooks, inline components |
| `js-` | 14 | Set/Map lookups, index maps, early exit, hoisting regexp, cached property access, combined iterations |
| `rendering-` | 11 | `content-visibility`, hoisted JSX, conditional render, resource hints, `useTransition`, SVG |
| `bundle-` | 6 | Barrel imports, dynamic imports, preload, deferring third-party |
| `async-` | 6 | Parallel fetching, deferred await, cheap condition before await, Suspense boundaries |
| `client-` | 4 | Event listeners, passive listeners, localStorage schema, SWR dedup |
| `advanced-` | 4 | Effect-event deps, event handler refs, init-once, use-latest |

Read a specific rule when working in that area — don't load the whole directory. The sections above are the triage layer; these are the details.


## Before declaring something faster

Run it more than once and report the spread — a single fast run is noise. Keep correctness as a hard constraint, not a competing metric. If nothing improved, say so and revert; "no improvement found" is a real, useful answer.

## Next.js App Router (16)

Verified against the Next.js 16 release notes.

- **Server Components by default.** Keep `"use client"` boundaries as low and small as possible; a client boundary pulls its whole import subtree into the bundle. Pass server-rendered children into client components instead of importing server work into them.
- **Caching is opt-in.** All dynamic code runs at request time unless cached. Enable `cacheComponents: true`, then mark what is cacheable with `"use cache"` (file, component or function level) and choose a `cacheLife` profile. Put the dynamic parts behind `<Suspense>` so the static shell streams first (Partial Pre-Rendering).
- **Invalidation:** `revalidateTag(tag, profile)` (the one-argument form is deprecated) gives stale-while-revalidate; `updateTag(tag)` in a Server Action gives read-your-writes so the user sees their change at once; `refresh()` refreshes uncached data only.
- **Request APIs are async:** `await params`, `await searchParams`, `await cookies()`, `await headers()`. Reading them makes that part dynamic; wrap it in Suspense.
- **Fetch in parallel on the server** (`Promise.all`, or start promises early and await later). Sequential awaits in a Server Component are a server waterfall.
- **Images and fonts:** `next/image` with explicit sizes and `priority` only for the LCP image; `images.remotePatterns` (not `domains`); defaults changed in 16 (`qualities` is `[75]`, `minimumCacheTTL` 4 h). `next/font` for self-hosted fonts without layout shift.
- **Prefetching** is incremental with layout deduplication; do not hand-roll it. Heavy client-only widgets use `next/dynamic`.
- Do not cache per-user data in a shared cache. A cached function that reads `cookies()` or user identity is a leak waiting to happen.
- Build output shows where time goes (compile, render); use it before guessing.

## Measure with the real target

Patterns from past projects, applied by default:

- **Weak devices:** detect memory, cores, data saver and measured frame rate, and scale effects down. Check how it feels on a 2-core phone with data saver on.
- **Baseline first:** before calling a cost a problem, measure a trivial page under the same throttling. Headless browsers and Lighthouse may render WebGL on the CPU and overstate it.
- **Idle cost:** no infinite animation under `backdrop-filter` or blur; ambient motion is finite or paused when idle. Verify with paint flashing or the frame meter on an idle page.
- **Don't pay for what isn't used:** speculative preloading fetches and parses data, but never builds heavy runtime (GPU context, worker pool, decoder) before the user asks.
- **Timed logic off the render loop:** countdowns and simulations tick on their own timer with measured elapsed time; rendering only draws. Throttle to 5 fps and confirm behavior doesn't change.
- **Edge cache what is the same for everyone** with stale-while-revalidate; keep sleeping hosts warm so the first visit isn't the slow one.
- **Optimistic sessions** (last-known signed-in state) speed up first paint but must never gate access; guards read confirmed state.
