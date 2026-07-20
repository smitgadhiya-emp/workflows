# Codex Prompt — Create WF-239 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (GitHub, Google
Drive/Sheets, Linear, Microsoft Teams). **Create every item in the actual app. Do NOT write anything
to the local file system.**

---

You are setting up **mock source data** for a workflow that resolves the *effective* CORS policy per
route across three stacked layers (Nginx → Express / Next.js), classifies the gaps against real
request logs, opens Linear issues, upserts an audit Sheet, and posts a Teams summary. Your job is ONLY
to create the seed data the workflow reads.

**Do NOT run the workflow.** Do NOT resolve effective policies, do NOT classify gaps, do NOT compute
exposure scores, do NOT create the audit Linear issues, do NOT post to Teams, and do NOT write this
run's rows into the audit Sheet (beyond the four seeded prior-run rows below). The catalog below tells
you what **config to write across the three layers** so the audit has a real fight to resolve — it is
your build spec, not output to transcribe.

## Where each source lives

- **GitHub, Google Drive/Sheets, Linear, Teams** → create real items via the connectors.
- **Production HTTP request + origin data** → cannot be injected into live web-server or CDN logs, so
  it is a **Google Sheet** that stands in as the mock source.
- **The config must be real code** — the whole audit is about which layer's header actually wins, so
  the three layers must be actual Nginx/Express/Next.js config at findable file+line, not a
  spreadsheet describing them.

## Anchor values (use everywhere; keep identical across every item)

- GitHub repo: **sahidempiricinfotech-dotcom/cors-audit**, branch **main** (the default branch). If it
  already exists, update files in place — do not create a second repo.
- Folders: `services/` (Express), `web/` (Next.js), `infra/nginx/` (Nginx)
- Google Drive folder for both Sheets: **Engineering / CORS Audit**
- Request-log sheet: **CORS Request Logs**, tab **Requests**
- Audit sheet: **CORS Effective Policy Audit**
- Linear team: **CORS**
- Microsoft Teams: team **Workflow test**, channel **cors audit**
- Traffic window: **2026-06-15 through 2026-07-14** inclusive, Asia/Kolkata
- Issue threshold: exposure score **45 or more** (make easy to change)
- Fallback owner team: **platform**

## The origin set (use these exact strings everywhere — configs and logs must agree byte-for-byte)

- **Real origins (appear in the logs in-window):** `https://app.acme.com`, `https://admin.acme.com`,
  `https://acme.com`, `https://www.acme.com`, `https://checkout.acme.com`, `https://partner.example.com`
- **Dead origins (allowed in config, but NEVER appear in the logs for any route in-window):**
  `https://staging-old.acme.com`, `https://legacy-admin.acme.com`

## The route catalog — the shared spine (enforce exactly)

**14 routes across the three layers.** Build every route as real config at a real file+line, wired so
the *effective* policy (what survives all layers in request order) is what the "why" column says. The
key mechanic is that **Nginx sits in front**, and **an Nginx `location` block that sets ANY
`add_header` drops all `add_header`s inherited from the `server` block** — so a location can silently
strip the app's CORS and re-add its own. Do not annotate any verdict, gap, or score in the code.

| id | route | layers that touch CORS (file) | effective policy / gap | why it resolves that way |
|----|-------|-------------------------------|------------------------|--------------------------|
| R01 | `POST /api/orders` | Express global `cors()` allowlist in `services/orders-api/src/app.js`; **Nginx** `location /api/orders/` in `infra/nginx/conf.d/orders.conf` sets an `add_header` (caching) which **drops the inherited server-block CORS** and re-adds `Access-Control-Allow-Origin *` | **effective = `*` on a credentialed route** → wildcard-on-authenticated **+ split-config override**. Nginx wins. The Express allowlist looks locked but never reaches the browser. **THE HEADLINE.** |
| R02 | `POST /api/payments/charge` | Express route-level `cors()` (locked, credentials true) + an `OPTIONS` handler in `services/payments-api/src/routes/charge.js` | effective policy fine, but **preflight advertises only `POST` while the handler also implements `DELETE`** → preflight methods mismatch (implemented-not-advertised) | real DELETE requests fail after preflight |
| R03 | `GET /api/users/:id` | Express global `cors()` allowlist in `services/users-api/src/app.js` that **includes `https://staging-old.acme.com`** | clean effective policy **+ dead whitelist entry** | staging-old never appears in logs anywhere |
| R04 | `PUT /api/users/:id/role` | Express global `cors()` allowlist + the handler in `services/users-api/src/routes/role.js` **hand-writes `res.header('Access-Control-Allow-Origin','*')`** | handler overrides middleware → **wildcard-on-authenticated + split-config** | hand-set header beats the global cors() for this route |
| R05 | `GET /api/public/config` | Express global `cors({ origin: '*' })` in `services/public-api/src/app.js` | **wildcard on a non-auth route** (in logs) | public static config, but * is still flagged at the non-auth tier |
| R06 | `POST /api/orders/:id/cancel` | Express allowlist in `services/orders-api` limited to `https://admin.acme.com` | **silently blocked origin**: logs show `https://app.acme.com` hitting it, not in the allow list | real users get CORS failures nobody filed |
| R07 | `POST /api/checkout` | Next.js `next.config.js` `headers()` allowlist for `/api/:path*` + the route handler in `web/app/api/checkout/route.ts` **sets `Access-Control-Allow-Origin: *`** | handler overrides config → **wildcard-on-authenticated + split-config** | Next route handler header wins over next.config |
| R08 | `GET /api/products` | Next.js `next.config.js` `headers()` sets `Access-Control-Allow-Origin: *` for `/api/products` | **wildcard on a non-auth route** (business data) | catalog data, * flagged at non-auth tier |
| R09 | `GET /api/profile` | Next.js `web/middleware.ts` sets an allowlist that **includes `https://legacy-admin.acme.com`** | clean effective **+ dead whitelist entry** | legacy-admin never in logs |
| R10 | `POST /api/newsletter` | Next.js route handler in `web/app/api/newsletter/route.ts`, allowlist matches the logs, simple POST | **clean, no gaps** (control) | don't-cry-wolf control |
| R11 | `DELETE /api/sessions/:id` | Express route in `services/users-api/src/routes/sessions.js` with cors() but **no `OPTIONS` handling at all** | **needs preflight, has none** → preflight-missing flag | DELETE is non-simple; no preflight = broken |
| R12 | `GET /api/admin/export` | Next.js route handler `web/app/api/admin/export/route.ts` sets `Access-Control-Allow-Origin: *`, authenticated admin export | **wildcard-on-authenticated**, **traffic-unknown** (no log rows) | scored 45 on policy risk even with reach 5 — must not be dropped |
| R13 | `GET /api/status` | Nginx `infra/nginx/conf.d/status.conf` pulls in an **`include`** whose `add_header` depends on a `map`/variable set in a file the chain can't fully resolve | **UNRESOLVED** effective policy | genuinely ambiguous layer order → mark Unresolved, do not guess |
| R14 | `POST /api/login` | Express route-level `cors({ origin: <specific>, credentials: true })` in `services/users-api/src/routes/login.js`, correct `OPTIONS` | **clean, credentials done right** (control) | a correctly-credentialed route that must NOT be false-flagged as wildcard-on-auth |

### Nginx must be genuinely three-layer and demonstrate the inheritance drop

`infra/nginx/nginx.conf` with a `server` block that sets `add_header Access-Control-Allow-Origin`
from a `map $http_origin` allowlist, `include conf.d/*.conf`, and per-route `location` blocks in
`conf.d/`. **At least `orders.conf` (R01) must set its own `add_header` in the location block**, which
per Nginx rules drops the inherited server-block CORS header — that is the mechanic the whole audit
hinges on. `status.conf` (R13) is the deliberately-unresolvable include.

### CODEOWNERS (repo root) — assign by the layer that introduced the WORST gap

GitHub precedence is **last match wins**. The workflow assigns each issue by matching the source path
of the layer that caused the worst gap — so for R01 that's the **Nginx** file, not the Express
service. Write CODEOWNERS with a last-wins overlap and a fall-through, and **no `*` default**:
```
/services/          @express-team
/services/users-api/ @users-team
/web/               @web-team
/infra/nginx/       @infra-team
/infra/nginx/conf.d/ @infra-team
/infra/nginx/conf.d/legacy/ @platform-team
```
Leave any `infra/nginx/` path **not** under `conf.d/` matching only `/infra/nginx/` (so an include
placed directly in `infra/nginx/` still resolves), but put the R13 unresolvable include under a path
that falls through to **platform** with a note. Keep the last-wins overlap on `/services/` vs
`/services/users-api/` intentional.

## What to create

### 1) GitHub repo `sahidempiricinfotech-dotcom/cors-audit` (branch `main`)

The three-layer app above, with all 14 routes as real config at findable lines. Handlers must
**actually touch what their data class claims** — the payment/user/auth routes read or write that data
in real code, the public routes serve static/public content — because the workflow judges data
exposure from what the handler does, not from the route name. Add a root `README.md` describing the
three layers and the request order (Nginx → app), and per-service `package.json`. Do **not** annotate
any gap, verdict, or score anywhere in the code.

### 2) Google Sheet — "CORS Request Logs" (in the Drive folder), tab **Requests**

Columns: `date, method, route path, origin, request count, had_credentials`. Rows are per
(day × route × origin). Join key is **route path + method**, so paths must match the repo routes
byte-for-byte. Seed so that **distinct-origins-per-route** and **total-request-count-per-route** come
out exactly as below (the audit reads reach from distinct origins and the tie-break from total count):

| route | distinct origins (→reach) | total req (window) | notes |
|-------|---------------------------|--------------------|-------|
| `POST /api/orders` | 5 (→20) | ~4200 | credentialed rows present |
| `POST /api/checkout` | 4 (→20) | ~2600 | credentialed |
| `PUT /api/users/:id/role` | 2 (→12) | ~260 | credentialed |
| `GET /api/admin/export` | **0 (→5)** | **0 — NO ROWS AT ALL** | traffic-unknown |
| `GET /api/products` | 5 (→20) | ~4800 | |
| `GET /api/public/config` | 6 (→20) | ~5000 | |
| `GET /api/users/:id` | 4 (→20) | ~3100 | staging-old NOT present |
| `GET /api/profile` | 2 (→12) | ~540 | legacy-admin NOT present |
| `DELETE /api/sessions/:id` | 2 (→12) | ~410 | |
| `POST /api/payments/charge` | 2 (→12) | ~380 | |
| `POST /api/orders/:id/cancel` | 3 (→20) | ~900 | **must include `https://app.acme.com`** (the silently-blocked origin) |
| `POST /api/login` | 3 (→20) | ~1500 | |
| `GET /api/status` | 2 (→12) | ~300 | |
| `POST /api/newsletter` | 1 (→12) | ~120 | |

Rules:
- **Neither dead origin** (`staging-old.acme.com`, `legacy-admin.acme.com`) may appear in ANY row for
  ANY route in-window — that's what makes them dead.
- `POST /api/orders/:id/cancel` **must** have `https://app.acme.com` rows even though the route's
  effective allow list is `admin.acme.com` only — that's the silently-blocked case.
- `GET /api/admin/export` gets **no rows at all** (traffic-unknown).
- **Add out-of-window rows** (2026-06-01→06-14 and 2026-07-15→07-20) with **different** values so a
  run that forgets to filter lands wrong: `GET /api/public/config` ~5000/window in-window but shows a
  7th origin (`https://old-partner.example.com`) only in the out-of-window rows; `POST /api/orders`
  total ~4200 in-window but much lower before. Keep in-window distinct-origin counts exactly as the
  table says.

### 3) Google Sheet — "CORS Effective Policy Audit" (in the Drive folder)

Create it with **exactly** these header columns, in this order:

`route, method, layers touched (file:line), configured policy per layer, resolved effective policy,
winning layer per header, gap types, preflight verdict, origins seen, request count, exposure score,
score breakdown, confidence, linear issue, owner, status, last reviewed`

Add **exactly four rows from a pretended previous run** (older `last reviewed`) and nothing else:
1. `POST /api/orders` — `last reviewed` **2026-05-20**, stale score/policy, **`owner` = infra-team**,
   **`status` = In Progress** (human-set). *(Upsert must refresh policy/score/gaps/linear but leave
   owner/status.)*
2. `GET /api/products` — `last reviewed` **2026-05-20**, **`owner` = web-team**, **`status` = Accepted
   Risk** (human-set). *(Same test.)*
3. `POST /api/login` — `last reviewed` **2026-05-20**, verdict clean, `owner`/`status` empty. *(Clean
   row updates cleanly.)*
4. `DELETE /api/legacy-webhook` — `last reviewed` **2026-04-02**, some stale gap, `status` Open. **This
   route must NOT exist in the repo.** *(Must be marked Resolved with the run date, not deleted.)*

### 4) Linear — team **CORS**

Ensure the team exists. Create **exactly three** pre-existing issues and no others:
1. **Open** (Todo/In Progress) — `CORS gap on POST /api/orders`, stale details. *(Must be updated,
   not duplicated.)*
2. **Open** — `CORS gap on POST /api/checkout`, stale details. *(Must be updated, not duplicated.)*
3. **Done/Canceled** — `CORS gap on GET /api/products`. *(The workflow searches only **open** issues,
   so this one should get a **new** issue — closed is not a reason to skip.)*

Do **not** create any other issues — those are the workflow's output.

### 5) Microsoft Teams

Confirm team **Workflow test** and channel **cors audit** exist; create the channel if it isn't there.
Do not post — the summary is the workflow's output.

## Consistency rules (verify all before reporting done)

1. All 14 routes exist as real config at findable file+line across the three layers, with the exact
   layer wiring above. The multi-layer routes (R01, R04, R07) genuinely have two layers fighting.
2. **R01's Nginx `location` block sets its own `add_header`, dropping the inherited server-block CORS**
   and re-adding `*`. This is the headline mechanic and must be real Nginx, not a comment.
3. Request-log paths+methods match the repo routes byte-for-byte; distinct-origin counts and total
   request counts per route match the table exactly.
4. Neither dead origin appears in any in-window log row; `app.acme.com` DOES hit
   `POST /api/orders/:id/cancel`; `GET /api/admin/export` has no rows.
5. Out-of-window rows carry different values (extra origin on `/api/public/config`, lower `/api/orders`
   total) so a window-filter miss is visible.
6. Data classes are backed by real handler code (payment/user/auth vs public/static).
7. R02 preflight advertises fewer methods than the handler implements; R11 has no OPTIONS at all; R14
   has correct preflight and correct credentialed CORS (the false-positive control).
8. R13's Nginx include is genuinely unresolvable (depends on an unset/elsewhere variable).
9. CODEOWNERS has no `*` default, a last-wins overlap on `/services/`, and a fall-through path to
   platform for the R13 include location.
10. Audit sheet has the 17 headers, exactly four prior rows, human owner/status on rows 1–2, and
    `DELETE /api/legacy-webhook` pointing at a route that does not exist.
11. Linear CORS has exactly three issues (two open, one closed) and no others.
12. **No effective policy, gap classification, exposure score, or winning-layer verdict appears
    anywhere in the seed** — not in a code comment, not in a sheet column, not in an issue.

## When done — report back (so the workflow prompt can be filled to match)

List: the **repo full name + default branch** and confirmation all three layer folders exist with the
14 routes at real lines; the **URL of both Google Sheets**; the **Linear team + the three seeded issue
IDs**; and confirmation the **Teams team/channel** exist. If the repo, a Sheet, the Linear team, or the
Teams channel could not be created, **say so explicitly and name which** — do not report done with a
gap. Finish with a short note confirming the twelve consistency rules hold, especially that R01's Nginx
location drops the inherited header, that the dead origins are absent from the logs, and that no
policy/gap/score appears anywhere in the seed. Do not create any local files.
