# Legal document templates (starting points, not legal advice)

Fill from the real data inventory. Replace every `[PLACEHOLDER]`. Delete sections that do not apply. Everything here needs a lawyer's review before launch to real users, especially liability, governing law and any region-specific rules.

## 0. Data inventory (do this first)

| Data item | Why collected | Where stored | Who receives it | Retention | Sensitive? |
|---|---|---|---|---|---|
| e.g. email | sign-in, receipts | [database/provider] | [email provider] | until account deleted + [N] days | no |

Every row must appear in the privacy policy. If a row cannot be justified, stop collecting it.

## 1. Privacy policy skeleton

1. **Who we are:** [operator name], contact [email].
2. **What we collect:** from the inventory, grouped (you give us / collected automatically / from third parties).
3. **Why and on what basis:** purpose per group; for consent-based items, how to withdraw.
4. **Who we share with:** each processor by name and role (hosting, email, analytics, payments, AI APIs).
5. **Cookies and similar technology:** essential vs optional, with link to the cookie notice.
6. **How long we keep it:** per item.
7. **Your choices:** access, correction, export, deletion, objection; how to ask and expected reply time.
8. **Children:** [not intended for under X / handling].
9. **Security:** one honest paragraph; no promise of "perfect security".
10. **International transfers:** [where data is processed], if applicable.
11. **Changes:** how updates are announced; effective date.
12. **Contact and complaints.**

Rule: the policy must match what the app does. Re-check on every release that adds data, a vendor, or a tracker.

## 2. Terms of service skeleton

1. Acceptance and eligibility (age, capacity).
2. The service and changes to it.
3. Accounts: accuracy, security, one person per account, termination.
4. Acceptable use: prohibited conduct list; consequences.
5. User content: what you own, the licence you grant us to operate it, removal rights.
6. Our intellectual property.
7. Payments, renewals, cancellations, refunds (or link to refund policy).
8. Third-party services.
9. Disclaimers and limitation of liability (lawyer must check wording and local limits).
10. Indemnity (optional).
11. Termination and what happens to data.
12. Governing law and disputes: `[JURISDICTION]`.
13. Changes to terms; contact.

## 3. Cookie and tracker notice

- Table: name, purpose, essential or optional, duration, provider.
- Essential only → no banner needed in most regimes, but still disclose. Optional (analytics, ads, embeds that track) → block until opt-in.
- Banner rules: equal prominence for "Accept" and "Reject", no pre-ticked boxes, a way to change the choice later, remember the choice.
- Prefer privacy-friendly analytics without personal identifiers to avoid the banner entirely.

## 4. Refund and payment terms

Price display, billing cycle, trial rules, cancellation steps, refund window and method, failed-payment handling, tax. Use a hosted payment page; never store card numbers.

## 5. Acceptable use and report path

Plain-language rules, a visible Report button or address, response commitment, repeat-offender policy, copyright/takedown contact.

## 6. Account and data deletion

Working in-app deletion or a documented request path; what is deleted immediately, what is retained and why (legal, fraud), when backups age out, confirmation to the user.

## 7. security.txt

```
Contact: mailto:[security@domain]
Expires: [ISO date within 1 year]
Preferred-Languages: en
Policy: https://[domain]/security
```
Serve at `/.well-known/security.txt`. Add `SECURITY.md` in the repo with the same contact, supported versions, and a safe-harbour sentence for good-faith reports.

## 8. Placement checklist

- Footer links on every page: Privacy, Terms, Cookies (if used), Contact.
- Sign-up form links Terms and Privacy next to the button; consent is a deliberate action, never bundled with marketing opt-in.
- Marketing email: separate unchecked opt-in, one-click unsubscribe.
- Effective date and version on each document; keep old versions.
- Legal pages are plain, readable, mobile-friendly and reachable without signing in.

## 9. Lawyer-review list (attach to every draft)

- Liability limits and disclaimers
- Governing law and dispute clause
- Region-specific obligations for the countries the app targets
- Anything involving minors, health, finance, biometrics, or precise location
- Data transfers across borders
- Any claim about security or data handling the app cannot prove
