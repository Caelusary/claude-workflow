---
name: project-blueprint
description: "Turn an approved idea into a production-ready blueprint: concept, UX, design system, architecture, schema, error handling, security, roadmap. Use when an early idea needs a full spec or 'how would I build X'. Starts from ideate's EXPLORE map when it exists."
---

# Project Blueprint

Transform a rough idea into a comprehensive, production-ready blueprint grounded in current practice, not dated patterns. Be suggestive, not prescriptive: offer options with tradeoffs, explain the why, keep the user deciding.

## Process

1. **Explore the idea.** If an approved `ideate` EXPLORE map exists, start from it and ask only what it left open. Otherwise ask 5–7 clarifying questions covering core concept, target audience, value proposition, the problem being solved, key user needs, and constraints (budget, timeline, existing stack). Use `clarify` rules (an "I don't know, you decide" option on each question). Ask them and *wait* — do not proceed to a full blueprint on assumptions.
2. **Research trends.** Use WebSearch/WebFetch for current design and technology patterns in this domain — competitors, current UX conventions, what's actually popular now. Cite real examples.
3. **Present an initial concept** — name, tagline, problem statement, rough direction — and get feedback before building the whole thing.
4. **Refine** on that input.
5. **Build the blueprint.** Include a roles-by-states matrix (each role vs empty, loading, error, partial, offline for each key screen) so unhappy paths are designed, not discovered. For the User Experience and Design System sections, load the `design-taste` skill and apply it directly — brief read, dials, typography, color, motion, interaction states. For component API and state decisions, load `frontend-engineering`.
6. **Offer to elaborate** on any section afterward.

## Blueprint sections

1. **Project concept** — name, tagline, problem statement, target audience.
2. **User experience** — personas, journey maps, key flows, information architecture, accessibility plan.
3. **Design system** — palette, typography, component library, breakpoints, mockups, mobile/tablet/desktop variations.
4. **Technical architecture** — frontend framework w/ justification, component structure, state management, backend stack, API design, auth strategy, full DB schema (tables, relationships, types, indexes, constraints), database rationale, migration/seed strategy.
5. **Error handling & reliability** — client validation, server error responses w/ status codes, graceful degradation, logging/monitoring, backup/recovery, rate limiting, security (use the `secure-and-compliant` skill for the document and abuse-case decisions).
6. **Market trends** — competitors, trend integration, what makes this distinct.
7. **Roadmap** — MVP scope, enhancements, advanced features, rough timeline.

## Delivery

Deliver the blueprint as an Artifact (a browsable page), keeping the underlying file too — not a plain markdown dump.

## Style rules

- Offer 3 options wherever a meaningful choice exists (design direction, backend stack, database), each with pros and cons.
- Recommend what's current and say *why* it's current — cite real products.
- Never invent a feature without explaining the reasoning.
- Balance innovation against practicality; flag when a trendy choice adds real risk or cost.
- Checkpoint with the user at each phase. Don't jump to a finished blueprint.

## Additional sections

8. **Security and compliance:** run the `secure-and-compliant` profile: which legal documents apply, auth and access model per role, abuse cases, data retention. Record decisions, not generic boilerplate.
9. **Roles and states matrix:** for every key screen, what each role sees and what happens with no data, bad input, a failed request or no network.
10. **Test and verification plan:** the main journey per role, how it will be proven in a browser (`testing-standards` e2e scaffold), and which agents will audit before release.

Hand the approved blueprint to `project-init` to scaffold the project foundation.
