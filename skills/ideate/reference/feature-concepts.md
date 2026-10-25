# Feature concepts library

Ideas worth reusing, harvested from past builds and stripped of the products they came from. Each is a **concept**: what it is, when it earns its place, and what to watch for.

## How to use

- Use during EXPLORE (what the idea needs) and design. Pick **3-5** that fit the product's one core loop. A library is not a shopping list; a product with 15 of these has no focus.
- Adapt, never copy. For each concept ask: does it serve this product's users and its core loop? What would it look like in this domain?
- If it adds a state, a role or a data field, run it through `clarify` before building.
- Add new concepts here after a project teaches one (concept only, no project names).

---

## 1. Trust and integrity

1. **Proof-gated completion.** Something counts as done only when evidence is attached (file, link or text), and a reviewer accepts or rejects it. A rejection needs a written reason. *Use when:* people self-report work and others depend on it. *Watch:* validate links and file types on the server, and decide who reviews their own work (flag it in the log).
2. **Append-only activity log.** Every state change adds an entry; history is never overwritten. *Use when:* disputes, grading or audits are plausible. *Watch:* log inside the same transaction as the change.
3. **Shareable read-only view with revocable links.** A public page for an outsider (professor, client, auditor) behind random tokens the owner can revoke one by one. An unknown or revoked token shows nothing, not an error that confirms it existed.
4. **Only the witness sets the status.** Each status transition belongs to the party who actually observes it; others can't declare it. Add a timed fallback so a missing update doesn't hang the flow forever (auto-complete after N days).
5. **Fairness judged by submission time.** Measure on-time or late from when the work was submitted, not when it was reviewed, so a slow reviewer never makes someone late.
6. **Hand-off windows.** Requests to swap or release responsibility close N hours before a deadline, and a request that has gone stale (work already submitted, window now closed) cannot be approved. The clock keeps moving while a screen is open, so re-check on confirm.
7. **Undoable admin actions.** Every privileged action is logged and reversible only if nothing changed since; irreversible ones are marked final up front.
8. **Archive instead of delete.** Anything referenced by history is unlisted, not removed. Records keep a snapshot of the name and price at the time.
9. **Server decides money.** The client sends ids and quantities; prices and discounts are computed on the server, once, by one function shared by the preview and the final order so they can't disagree.
10. **Last-unit safety.** Reserve stock and claim limited-use codes with conditional atomic updates; one failure rolls back the whole checkout so two buyers can't both get the last item.
11. **Race-proof status changes.** Updates carry the expected current status in their condition, so a cancel and a ship arriving together can't both win.
12. **Rules in one place, enforced at every level.** One module says who may do what; the screen uses it to hide actions, the page re-checks on load, the action layer refuses, and the database checks again. Typing a URL or double-clicking can't get around it.

## 2. Data shape and discovery

13. **Structured attributes, not prose.** Store each spec as data and every attribute becomes a filter, a comparison row and a visual input. *Use when:* products or items have comparable properties.
14. **Visuals derived from the data.** Render a picture or 3D view from the same attributes the filters use, with a generated fallback, so the visual can never disagree with the facts.
15. **Category-aware search.** Starter chips and suggestions change with the selected category. Match word by word (not phrase), start-of-word, accent-folded, and ignore joining words like "by". Treat a wildcard as a retry when exact results are thin, not as the default.
16. **Field-scoped search.** Let people search titles only, authors only, or everything, and make the local filter use the same scope so the search and its own filter never disagree.
17. **Back to exactly where you were.** Every link into a detail page carries the search it came from, so Back restores that result set, scope and sort. A pasted link with no origin falls back to home.
18. **Autocomplete done right.** Debounce typing, cache responses per prefix so backspacing is instant, abort superseded requests, and make the newest search always win.
19. **Merge two sources in parallel.** When no single endpoint has the whole record, fetch both at once and compose one view.
20. **Show what the user chose, not what the provider resolved.** If an API snaps a place to the nearest station, display the name the user picked.

## 3. Flow and interaction

21. **Skeletons that keep layout.** Placeholders shaped like the final content so nothing jumps when data lands.
22. **Canonical units, converted at display.** Fetch in one unit system and convert in the UI; switching units never refetches or shows a stale value.
23. **State in the URL.** The active view lives in the address so every screen is linkable and works on a static host.
24. **Explain in place.** A small info control beside any number says what it means, what today's value implies, and one practical tip.
25. **Derived insights from data already fetched.** A "best time to go out" or "cheapest day" line computed from existing results, with no extra requests.
26. **Ask permission when the reason is obvious.** Request location on first use of the feature that needs it, not on page load. Degrade quietly if refused.
27. **Arrow for direction, colour for judgement.** One encoding rule everywhere: the arrow shows which way a number moved; the colour says whether that's good for the user.
28. **Default scope matches the question.** Each page opens on the period that answers its question (all time for a list, current month for a monthly limit). Label lifetime figures as lifetime.
29. **Recurring rules with idempotent catch-up.** On load, post anything that came due while away; dedupe on (rule, date), write results before advancing the watermark, clamp "31st" to the month's last day, and when a paused rule resumes, start from the resume date, not months back.
30. **Local-first with a way out.** For browser-only data: repair on load, keep a recovery copy, never downgrade newer data, and offer export. Neutralise leading `=`, `+`, `-`, `@` in CSV exports.
31. **Demo mode with the same UI.** Pages read from a store interface; one provider keeps a demo in memory, another talks to the backend. Demos and real use share every screen.
32. **Zero-install development.** If no database URL is set, start an in-memory database and seed it, with demo accounts for every role listed up front.
33. **One-time intro.** A short opening animation on the first visit only, remembered by a flag.
34. **One state drives the whole mood.** A single selection changes colours, particles and copy together, so the product feels alive without extra controls.
35. **Distinctive navigation.** A single control that opens a radial or compact menu, labelling only the current or hovered item, can replace a bar when the product has few destinations. Keep a plain fallback for keyboard and assistive tech.
36. **Hero that is a picker.** Make the first screen choose a category (one visual per category, search below) instead of a product carousel.
37. **Phone gets a different arrangement.** Swipeable carousel on phones, grid on laptops; sidebar on desktop, bottom bar on phones.

## 4. Learning and engagement

38. **Predict, then reveal.** Ask the learner to call the outcome first, then walk through the steps that produce it.
39. **Practice in the exam's format.** Offer the same layout and notation the real test uses, with every cell marked and the correct version shown after.
40. **Mistakes deck.** Every wrong answer goes into a pile that is re-dealt until each is right; redos clear the pile but earn no points.
41. **Mixed review.** One question from every topic, scored, with points going to each topic.
42. **Printable worksheet** with the answer key on its own page.
43. **Honest gamification.** Streaks, a daily goal, badges that show progress toward them, an activity heatmap. Progress is earned once per genuine attempt.
44. **A character with opinions.** A small mascot reacts to answers, level-ups and streaks with short lines, giving personality to feedback.
45. **Installable and offline.** Phone-first, works as an installed app, keeps progress on the device with no account.

## 5. Collaboration and sharing

46. **Pair or group by short invite code.** Whoever creates the space gets a code to share; joining with the code links the accounts. One account can belong to several groups.
47. **Private scope by construction.** Each pair or group's data is isolated at the database level, so other groups can't see it even by guessing ids.
48. **Cheap "live" without realtime.** Poll the other side's state every few seconds while the tab is visible; switch to subscriptions only when needed.
49. **Claim from a pool.** Open work sits in a shared pool anyone can take ("call dibs"), alongside a view of your own items.
50. **Shared gallery.** Resize images in the browser before upload, store in a private path scoped to the group, and show through short-lived links.

## 6. Commerce and operations

51. **One checkout, one order per seller.** Split the cart by seller so each fulfils their own items; share the discount proportionally.
52. **Auto-assign to the least-loaded worker** (a courier, a reviewer) and let only that worker mark the final step.
53. **Return or dispute windows start at delivery,** not at purchase, and the final step can only be set by the party who sees it.
54. **Client-side image cleanup.** Remove backgrounds in the browser (no API cost, no server load) and show before and after so the seller picks.
55. **Seller approval flow.** Applicants wait for an admin; owners manage admins; each role sees only what it needs.

## 7. Integration and presentation

56. **Key stays on the server.** A small serverless function adds the secret and forwards only the exact requests the app makes.
57. **Respect rate limits by design.** Batch requests with pauses, cache for minutes, and load heavy features (maps) on demand in a separate chunk.
58. **Times in the place's own timezone,** and day or night from sunrise and sunset data with a fixed-hours fallback.
59. **Context-aware suggestions.** Suggestions that adapt to external data (weather, traffic, stock) for the plan the user is building.
60. **Multi-stop planning.** Trips or routes made of ordered stops, each with its own date range and data.
61. **Cinematic portfolio moves.** A hero image whose edges dissolve into the page, a faint animated background, a custom cursor only on fine pointers (off for touch and reduced motion), scroll-reveal sections, scrollspy navigation, dual themes, a language switch, and a feedback widget. Every effect needs an off switch.
62. **Multi-language done deliberately.** Translate text, decide direction and number handling per language on purpose, not by default.
63. **Security headers as a feature of a no-backend app.** A strict content policy, no cross-origin requests, and a plainly stated privacy model ("everything stays on this device").
64. **Say the limits out loud.** A short "known limitations" section builds more trust than a feature list.

## 8. Cinematic showcase moves

65. **Ambient product recordings.** Short muted looping clips (with a poster image and no preload) play inside expanding panels, one per product, each on that product's own colours. They load only on demand and are off for reduced motion and data saver.
66. **Scroll as storytelling.** Section reveals, a thin scroll-progress bar, scrollspy highlighting the current section, and a one-time light sweep when a key row scrolls into view.
67. **One glass navigation pill.** Logo mark plus a single pill holding links, language and theme controls, aligned to the page width; on phones the same group opens as a dropdown.
68. **Atmospheric background.** A faint animated backdrop (aurora, particles, cursor-following glow) behind the hero, subtle enough that text never competes with it.
69. **Page cross-fades.** Moving between pages fades with a slight rise while the navigation stays put; browsers without support switch instantly.
70. **Insert-only feedback.** A small pinned feedback pill writes ratings and comments to a table visitors can add to but never read.
71. **Case-study rows.** Each project as an alternating row with a screenshot gallery, role and duration, feature list and technology badges, ranked by polish and usefulness.

