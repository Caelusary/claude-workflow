# Backend and data layer (Supabase-first, principles general)

Read with Step 3 of the main skill. Use the Supabase MCP tools to inspect the real project: `list_tables`, `get_advisors` (security and performance), `list_migrations`, `execute_sql` for read-only checks, `query_logs`. Check the live project before reasoning from code.

## Access control at the database

- **Row-level security (RLS) on every table in an exposed schema.** A table without RLS in `public` is readable and writable by anyone holding the anon key. `get_advisors` flags this; treat each finding as a defect.
- **Default deny.** Enable RLS, then add the narrowest policies. No policy means no access, which is the safe state.
- **One policy per role per operation** (select, insert, update, delete) with `using` for what rows are visible and `with check` for what rows may be written. An update policy without `with check` lets a user rewrite a row into someone else's.
- **Identity from the token, never the request body.** `auth.uid()` in policies; do not accept `user_id` from the client and trust it.
- **Roles and permissions from `app_metadata` or a server-owned table**, never `user_metadata` (users can edit their own `user_metadata`).
- **`service_role` and secret keys are server-only.** They bypass RLS. Never in the client bundle, never committed, never logged. The client uses the anon/publishable key only.
- **Views and functions:** views run with the owner's privileges by default and can bypass RLS; use `security_invoker = true`. `SECURITY DEFINER` functions set `search_path` explicitly and validate caller identity inside. Revoke `execute` from `anon`/`public` on functions that should not be callable.
- **Field-level exposure:** RLS limits rows, not columns. For columns only some viewers may see (private contact details, internal notes), expose through a view or RPC that omits them, or split into a separate table with its own policy. A UI that hides a field it received is not protection.
- **Time-boxed access:** personal data one user needs about another is readable only while the task that needs it is open (policy checks the task status), and a test proves the after-state.

## Storage

- Buckets private by default. Public only for truly public assets.
- Policies scope by path (for example `auth.uid()::text = (storage.foldername(name))[1]`) and by operation.
- Limit file size and MIME types at the bucket; never trust the client's content type; do not serve user uploads from the app origin if they can contain HTML or SVG scripts.
- Deleting a file referenced from several records goes through one shared "who else uses this URL?" check.

## Auth

- Email confirmation on, leaked-password protection on where available, sensible password rules, rate limits and CAPTCHA on sign-up and reset if abuse appears.
- Redirect URLs allow-listed exactly. No wildcard production redirects.
- Sessions: server-side checks on every protected route; the client's idea of "signed in" is a hint, not a gate.
- MFA for admin roles.

## Migrations and environments

- **Every schema change is a migration file in version control**, applied through `apply_migration` or the CLI, never hand-edited in the dashboard on production.
- Test migrations on a branch/dev project first (`create_branch` or a separate project). Destructive changes (drop, type narrowing) need a backup point and an explicit approval.
- Keep dev and production on separate projects and keys, so running dev cannot reach live data.
- Seed data is fake. Production data never enters dev, tests or screenshots.
- Index foreign keys and policy-filtered columns; policies that call heavy functions per row are a speed risk (`get_advisors` performance).

## Server code and mocks

- Validate every input with a schema at the boundary. Parameterised queries only.
- Rate-limit costly or enumerable endpoints (auth, search, anything that sends email/SMS).
- Actions that award, count or spend are decided server-side, idempotent, protected from replay and races (unique constraints, atomic updates).
- For tests, point the production build at the local mock backend from the `testing-standards` e2e scaffold; cover each role plus forced failures. Add a direct API test per role: call the endpoint as that role and expect refusal where it should be refused.

## Review checklist

1. Run `get_advisors` (security) and fix or justify every finding.
2. For each table: RLS on? Policies per operation? `with check` present? Test as anon, as another user, as the owner, as each role.
3. For each returned field: who may see it, and does a viewer who may not get a response without it?
4. Any `service_role` use outside server-only code? Any secret in the repo or logs?
5. Views, functions and storage policies checked as above.
6. Migrations in version control; dev isolated from prod; backups restorable.
