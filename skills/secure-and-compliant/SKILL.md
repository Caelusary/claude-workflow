---
name: secure-and-compliant
description: "Decide what a site or app needs for security, privacy and legal cover (privacy policy, terms, cookies, age gate, deletion, refunds, security.txt), draft templates, and run an abuse-case pass: auth, access control, replay, rate limits, uploads, headers, secrets, supply chain. Use when planning, adding accounts, payments, uploads, tracking, kids' content or user-to-user features, before launch, or asked what legal pages or protections are needed."
---

# Secure and compliant

Goal: work that is sealed tight. Two jobs: (A) decide what the project owes its users and the law, (B) make it hard to attack and hard to cheat.

Not every project needs every item. Decide per project from what it actually does, and say why each item is in or out. This skill is a working baseline, **not legal advice**; every drafted document ships with a "needs review by a lawyer" flag before real users arrive.

Use `clarify` for facts only the owner knows (who the users are, whether money or minors are involved). Don't guess a fact that flips a requirement.

## Step 1: Profile the project

Answer, from the code first, then by asking:

| Question | Triggers |
|---|---|
| Does it store any personal data (email, name, IP, device id, location, photos)? | Privacy policy, data inventory, deletion path |
| Are there accounts or sign-in? | Terms, password/session hardening, account deletion, recovery abuse checks |
| Cookies, local storage, analytics, ads, third-party scripts? | Cookie/tracker notice, consent before non-essential tracking |
| Payments, subscriptions, donations? | Terms of sale, refund policy, PCI scope (use a hosted checkout, never touch card data) |
| User-generated content, messages, uploads? | Acceptable use, takedown/report path, upload hardening, moderation |
| Could users be under 13/16/18? | Age gate or "not for children" stance, parental rules, extra data limits |
| Third parties receiving data (email, analytics, hosting, AI APIs)? | Processor list in the privacy policy, data-processing terms |
| Operates in or targets particular regions? | Regional extras (see Step 2 note) |
| Health, financial, biometric or precise-location data? | Treat as sensitive: minimise, encrypt, stronger consent, flag for legal review |
| Open source / downloadable software? | License file, EULA if distributing binaries |

## Step 2: Documents decision

Output a table: document, **needed / not needed / recommended**, reason, where it lives.

Baseline set (global, region-neutral):

- **Privacy policy:** needed if any personal data (even just an email). Must list what is collected, why, who receives it, how long kept, how to access/correct/delete, a contact. Written from the actual data inventory, never boilerplate.
- **Terms of service:** needed with accounts, payments, user content or any service promise. Covers acceptable use, account termination, liability limits, IP in user content, governing law, changes.
- **Cookie and tracker notice:** needed if anything beyond strictly necessary session storage is set. Non-essential tracking waits for opt-in; choices must be as easy to refuse as accept; no pre-ticked boxes.
- **Refund/payment terms:** if money changes hands.
- **Acceptable use and report/takedown path:** if users post anything others see.
- **Account and data deletion flow:** a real working path, not a promise.
- **Age statement or gate:** if minors are plausible.
- **`/.well-known/security.txt` and `SECURITY.md`:** how to report vulnerabilities.
- **Attribution/licence page:** for third-party assets and licences that require it.

Regional note: this baseline is deliberately region-neutral. If the owner later targets a specific region (for example the EU/UK, the Philippines, or US states), add that region's rules (lawful basis, registration, notice and rights timelines) and flag it for review. Ask before assuming a region.

Templates and the placement checklist live in `reference/legal-docs.md`. Draft documents from the data inventory with `[PLACEHOLDERS]` for anything unknown, plus a short list of "lawyer should check" items.

## Step 3: Threat and abuse-case pass

For every action and data field, ask who could abuse it and how. Cover both outsiders (attackers) and insiders (curious or cheating users).

### Access and identity
- Every endpoint, bucket, function and admin route requires auth **server-side** and checks ownership/role per object. Test by calling it without the app.
- Roles: for each role, what can it see, change, delete? Is there a test that a lower role is refused?
- Sign-in: rate limit and lock out gently, uniform error messages (no account enumeration), strong password rules or passkeys, safe reset (single-use, short-lived, not guessable), MFA for admins.
- Sessions: HttpOnly, Secure, SameSite cookies; rotation on privilege change; real logout invalidates server-side.
- Don't trust the client for identity, price, role, score, or status.

### Data exposure
- For each field returned by each endpoint: who may see it? Return only that. Test the viewer who may not.
- Personal data shown to another user: stop sending it the moment the task that needed it ends.
- No sequential/guessable ids on private resources, or enforce ownership regardless.
- Logs, errors and analytics hold no secrets or personal data. Stack traces never reach users.

### Abuse and cheating
- Actions that award, count, vote, spend or unlock: repeatable? replayable? reachable after seeing the answer? Make them idempotent and server-decided, and cap rates.
- Rate limits per user, IP and global on anything costly, enumerable, or message-sending (email/SMS bombing, scraping, brute force).
- Races: double-submit, parallel requests, out-of-order events. Use atomic writes and unique constraints.
- Content: size, type, count limits; sanitise or sandbox rendered user content; no trusting file names or MIME from the client; strip metadata from images; store uploads outside executable paths; scan if public.
- Anti-automation proportional to the risk (rate limits, proof-of-work or a challenge only where abuse is real).

### Injection and browser protections
- Parameterised queries only. Validate all input at the boundary with a schema.
- Output encoding by default; no raw HTML sinks (`innerHTML`, `dangerouslySetInnerHTML`) without sanitising.
- Headers: strict CSP (nonce/hash, no `unsafe-inline` unless forced), HSTS, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`, frame-ancestors, CORS limited to known origins.
- SSRF: server fetches of user URLs go through an allowlist and block internal addresses.
- CSRF protection on cookie-authenticated state changes.

### Secrets and environments
- Secrets only in server environment variables or a secret manager; never in the repo, client bundle, logs or chat. Rotate on exposure.
- Dev cannot reach production data by accident (separate projects, keys, databases).
- Least-privilege API keys; service-role/admin keys never ship to clients.

### Supply chain
- Lockfile committed; audit dependencies and judge reachability, not just counts. Prefer fewer, maintained packages. Review install scripts for new ones.
- Pin CI actions and build tools. Don't run unreviewed third-party skills, scripts or installs.
- Subresource integrity or self-host third-party scripts; every external script is a trust decision.

### Privacy by design
- Collect the minimum. Short retention. Separate identifiers from content where possible. Provide export and delete.
- Third parties receive only what they need, listed in the privacy policy.

### Resilience
- Backups tested by restore. Safe deploy and rollback. Monitoring and alerts for auth failures and error spikes. An incident plan: who is told, how users are notified.

For a Supabase or other hosted-database backend, also apply `reference/backend-data.md` (RLS, policies, storage, auth, migrations, advisors).

## Step 4: Verify, don't assume

- Run the app and attack it as a user: call endpoints without auth, with another user's ids, with replayed requests, with oversized or malformed input.
- Confirm headers on the real deployed responses, not the config file.
- Add tests for each abuse case found. A control without a test is a hope.
- For a whole-project sweep, dispatch the `security-engineer` agent; for browser-driven behavior (CSP console errors, role-based screens) use `journey-auditor`.

## Output

1. Project profile (facts, who answered).
2. Documents table with decisions and reasons.
3. Draft documents or templates with placeholders and a lawyer-review list.
4. Threat/abuse findings as: Severity · Where · How it is abused · Fix · Test.
5. Launch checklist of what remains.

Never state that a project is "compliant" or "legally safe". Say what was checked and what still needs a professional.
