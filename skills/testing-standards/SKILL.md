---
name: testing-standards
description: What to test and how: choosing worthwhile cases, assertions that catch regressions, React component and async tests, avoiding brittle tests, the Playwright e2e scaffold, per-role access tests. Use when adding or reviewing tests, setting up a suite, deciding if something needs a test, or when a test is flaky. Coverage audit: qa-engineer.
---

# Testing Standards

A test earns its place by catching a regression someone would otherwise ship. Everything here follows from that.

## What to test

Rank by what breaking would actually cost:

1. **Logic with branches** — parsing, filtering, sorting, formatting, validation, anything with edge cases. Cheapest to test, highest catch rate.
2. **Critical user paths** — the two or three flows that, if broken, make the app pointless. For a search app: query → results rendered; empty result → empty state, not an error.
3. **Bug fixes** — every fix gets a test that fails without it. This is the highest-value test you will ever write, because it's proof the bug was real and stays fixed.
4. **Contracts at boundaries** — what happens when the API returns a shape you didn't expect, or nothing at all.

**Don't test:** framework behavior, third-party libraries, implementation details, or trivial pass-throughs. A test asserting that React renders a prop tests React.

## Coverage is not proof

- Coverage measures **execution, not verification**. A line can be fully covered by a test that asserts nothing meaningful. Require a real assertion or an observable outcome.
- Chasing a coverage number produces tests that assert whatever is easy — which is exactly the code least likely to break.
- A slow test that uniquely protects a critical path is high-value. A fast test that proves framework behavior is not. Judge by what it catches, not what it costs.

## Shape of a good test

- **Name it after the behavior**, not the function: `returns empty state when no books match` beats `test search`.
- **Assert on the outcome the user or caller observes**, not internal state. Tests bound to internals break on every refactor and catch nothing.
- One reason to fail per test. When a test can fail three ways, a failure doesn't tell you which.
- **Arrange–act–assert**, visibly separated. If setup dwarfs the assertion, extract a factory or fixture.
- Prefer real inputs over mocks. Mock at the network boundary; mocking your own modules mostly asserts that you wrote the mock correctly.

## React components

- Query the way a user finds things — role, label, visible text. Test IDs are a fallback, not a default; selecting by class or DOM structure is the brittlest option.
- Test the states that actually render: loading, error, **empty**, and success. Empty is the one most often missed and most often broken.
- Interactions go through user-facing events, and assert the resulting visible change.
- Accessibility is testable — roles, labels, and focus behavior are assertions, not manual review.

## Async and flakiness

- Await the assertion, don't sleep. A fixed timeout is a race that passes on your machine.
- A flaky test is a real signal — it's either a genuine race in the code or an untrustworthy test. **Never** fix flakiness by retrying until green; separate a nondeterministic product bug from a badly written test.
- Reset shared state between tests. Order-dependent tests fail in CI and pass locally.
- Cancellation and out-of-order responses are testable: assert that a superseded request doesn't overwrite newer state.

## Maintaining the suite

- Deleting a test requires proof its basis is obsolete or that something else covers the behavior as well. Regression guards and the only proof of a rare edge case are never deletion candidates just for looking low-value.
- Merging tests must preserve distinct failure scenarios and keep failures localized — a bigger test is not a better one.
- If the project has no tests yet, don't build a grand suite. Add the runner plus three to five tests on the critical path, and grow from real bugs.

## End-to-end tests

For browser journeys, use the reusable scaffold in `reference/e2e-scaffold.md`: the suite owns its server, applies production headers, fails on console/CSP errors, mocks the backend (including server-side calls), runs every role at desktop and 375px, repeats mutation journeys with `--repeat-each`, and scans accessibility only after fetched content is on screen. Pair with the `journey-auditor` agent, which explores live and writes specs into this structure.

## Access and failure tests

- **Per-role API tests:** for each protected endpoint call it as every role (and unauthenticated) and assert refusal where it should refuse. A viewer who may not see a field must get a response without it. The UI hiding something is not a test of access.
- **Failure paths:** force the backend to fail and assert an error with a working retry, never the empty state.
- **Flaky tests are bugs:** reproduce with repeats and find the cause with the `debugging` skill; do not add retries.
- End-to-end details: `reference/e2e-scaffold.md`.
