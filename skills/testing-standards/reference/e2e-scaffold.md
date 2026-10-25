# End-to-end scaffold (Playwright)

One reusable setup, so every project proves its journeys the same way. Adapt names to the stack; keep the five properties:

1. **The suite owns its server**, on an uncommon port, and never reuses whatever already answers there.
2. **Production headers apply** (CSP and the rest), read from the deploy config, so a CSP that only exists in prod is exercised.
3. **Any console error, page error or CSP violation fails the test.**
4. **The backend is a local mock** (server-side calls included), so the suite runs offline with no secrets and can force failures.
5. **Journeys run per role, on desktop and 375px, and mutation journeys repeat** to catch intermittent staleness.

## Install

```bash
npm i -D @playwright/test @axe-core/playwright
npx playwright install chromium
```

## `playwright.config.ts`

```ts
import { defineConfig, devices } from '@playwright/test';

const PORT = 4789;          // uncommon on purpose
const MOCK_PORT = 4790;

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  retries: 0,               // flakiness must be visible, not retried away
  reporter: [['list'], ['html', { open: 'never' }]],
  use: { baseURL: `http://localhost:${PORT}`, trace: 'retain-on-failure' },
  projects: [
    { name: 'desktop', use: { ...devices['Desktop Chrome'] } },
    { name: 'phone-375', use: { ...devices['Desktop Chrome'], viewport: { width: 375, height: 812 }, isMobile: true, hasTouch: true } },
  ],
  webServer: [
    { command: `node e2e/mock-backend.mjs`, port: MOCK_PORT, reuseExistingServer: false },
    // Build with the mock URL baked in, then serve with the deploy headers.
    { command: `API_URL=http://localhost:${MOCK_PORT} npm run build && node e2e/serve-with-headers.mjs ${PORT}`,
      port: PORT, reuseExistingServer: false, timeout: 180_000 },
  ],
});
```

If the framework serves the production build itself with headers from its own config (for example `next start`), use that command and skip `serve-with-headers.mjs`. If port is in use the run fails loudly, which is the point.

## `e2e/serve-with-headers.mjs` (static build + deploy headers)

Reads the header rules from the deploy config (`vercel.json` `headers`, `netlify.toml`, or `_headers`) so they are not duplicated:

```js
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';

const port = Number(process.argv[2]);
const dist = path.resolve('dist');
const cfg = JSON.parse(fs.readFileSync('vercel.json', 'utf8'));
const rules = (cfg.headers ?? []).flatMap(r => r.headers.map(h => [h.key, h.value]));
const types = { '.html':'text/html', '.js':'text/javascript', '.css':'text/css', '.json':'application/json', '.svg':'image/svg+xml', '.png':'image/png', '.webp':'image/webp', '.woff2':'font/woff2' };

http.createServer((req, res) => {
  let p = path.join(dist, decodeURIComponent(req.url.split('?')[0]));
  if (!p.startsWith(dist)) { res.writeHead(403).end(); return; }
  if (!fs.existsSync(p) || fs.statSync(p).isDirectory()) p = path.join(dist, 'index.html'); // SPA fallback
  for (const [k, v] of rules) res.setHeader(k, v);
  res.setHeader('Content-Type', types[path.extname(p)] ?? 'application/octet-stream');
  fs.createReadStream(p).pipe(res);
}).listen(port);
```

Route-specific `source` patterns in the config need matching if present; apply at least the global `/(.*)` rule.

## `e2e/mock-backend.mjs` (HTTP stand-in with failure switches)

```js
import http from 'node:http';

const state = { fail: false, delayMs: 0, items: [{ id: 1, name: 'Seeded item' }] };

http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://x');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', '*');
  res.setHeader('Access-Control-Allow-Methods', '*');
  if (req.method === 'OPTIONS') return res.writeHead(204).end();

  // control plane used by tests
  if (url.pathname === '/__mock/reset') { state.fail = false; state.delayMs = 0; state.items = [{ id: 1, name: 'Seeded item' }]; return res.end('ok'); }
  if (url.pathname === '/__mock/fail')  { state.fail = url.searchParams.get('on') === '1'; return res.end('ok'); }
  if (url.pathname === '/__mock/delay') { state.delayMs = Number(url.searchParams.get('ms') || 0); return res.end('ok'); }

  if (state.delayMs) await new Promise(r => setTimeout(r, state.delayMs));
  if (state.fail) return res.writeHead(500, { 'Content-Type': 'application/json' }).end(JSON.stringify({ error: 'forced failure' }));

  res.setHeader('Content-Type', 'application/json');
  if (url.pathname === '/items' && req.method === 'GET') return res.end(JSON.stringify(state.items));
  if (url.pathname === '/items' && req.method === 'POST') {
    let body = ''; for await (const c of req) body += c;
    const item = { id: Date.now(), ...JSON.parse(body || '{}') }; state.items.push(item);
    return res.writeHead(201).end(JSON.stringify(item));
  }
  res.writeHead(404).end(JSON.stringify({ error: 'not found' }));
}).listen(4790);
```

Mirror the real API's shapes, status codes and documented error codes. Add per-role tokens (`/auth` returns a role-specific token) so every role journey is reachable.

## `e2e/fixtures.ts` (console, CSP and page errors fail the test)

```ts
import { test as base, expect } from '@playwright/test';

export const test = base.extend<{ mock: { fail(on: boolean): Promise<void>; delay(ms: number): Promise<void>; reset(): Promise<void> } }>({
  page: async ({ page }, use) => {
    const problems: string[] = [];
    page.on('console', m => { if (['error'].includes(m.type())) problems.push(`console: ${m.text()}`); });
    page.on('pageerror', e => problems.push(`pageerror: ${e.message}`));
    await page.addInitScript(() => {
      document.addEventListener('securitypolicyviolation', e =>
        console.error(`CSP violation: ${(e as SecurityPolicyViolationEvent).violatedDirective} ${(e as SecurityPolicyViolationEvent).blockedURI}`));
    });
    await use(page);
    expect(problems, 'console, page or CSP errors').toEqual([]);
  },
  mock: async ({ request }, use) => {
    const base = 'http://localhost:4790';
    await request.get(`${base}/__mock/reset`);
    await use({
      fail:  async on => { await request.get(`${base}/__mock/fail?on=${on ? 1 : 0}`); },
      delay: async ms => { await request.get(`${base}/__mock/delay?ms=${ms}`); },
      reset: async () => { await request.get(`${base}/__mock/reset`); },
    });
    await request.get(`${base}/__mock/reset`);
  },
});
export { expect };
```

A test that expects a console error (an error-path test) must filter it explicitly, never by turning the watcher off.

## Spec patterns (copy per project)

```ts
// e2e/journey.spec.ts
import { test, expect } from './fixtures';
import AxeBuilder from '@axe-core/playwright';

test('main journey as <role>', async ({ page }) => {
  await page.goto('/');
  // sign in as a seeded role, then walk the top task end to end
  await expect(page.getByRole('heading', { name: /.+/ }).first()).toBeVisible();
});

test('failed backend shows an error with retry, not the empty state', async ({ page, mock }) => {
  await mock.fail(true);
  await page.goto('/items');
  await expect(page.getByRole('alert')).toBeVisible();
  await expect(page.getByText(/no items yet/i)).toHaveCount(0);
  await mock.fail(false);
  await page.getByRole('button', { name: /retry/i }).click();
  await expect(page.getByText('Seeded item')).toBeVisible();
});

test('slow backend shows a placeholder shaped like the content', async ({ page, mock }) => {
  await mock.delay(1500);
  await page.goto('/items');
  await expect(page.getByTestId('items-skeleton')).toBeVisible();
  await expect(page.getByText('Seeded item')).toBeVisible();
});

test('add then see it, without a reload', async ({ page }) => {
  await page.goto('/items');
  const name = `Item ${Date.now()}`;
  await page.getByRole('button', { name: /add/i }).click();
  await page.getByLabel(/name/i).fill(name);
  await page.getByRole('button', { name: /save/i }).click();
  await expect(page.getByText(name)).toBeVisible();
});

test('landing pages pass an accessibility scan once data is on screen', async ({ page }) => {
  await page.goto('/items');
  await expect(page.getByText('Seeded item')).toBeVisible();      // wait for fetched content first
  const results = await new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag22aa']).analyze();
  expect(results.violations).toEqual([]);
});

test('no horizontal overflow at 375px', async ({ page }) => {
  await page.goto('/');
  const overflow = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth);
  expect(overflow).toBe(false);
});
```

Run commands:

```bash
npx playwright test                              # both viewports
npx playwright test --repeat-each 10 -g "add then see"   # mutation journeys: any single miss fails
npx playwright test --repeat-each 5              # fetched-content scans: must pass or fail consistently
```

## Roles and states checklist

For each role: sign in, reach every screen it may see, confirm screens it may not see are refused (server-side: call the API directly as that role and expect 403). For each key screen: empty, loading, error with retry, partial data, long text, many items.

## Never

- Reuse an already-running server or point tests at production or a shared dev backend.
- Retry flaky tests to green. Find the cause (`debugging` skill).
- Put real credentials in specs. Seed mock accounts only.
- Scan accessibility on `load` alone; the skeleton passes by luck.
