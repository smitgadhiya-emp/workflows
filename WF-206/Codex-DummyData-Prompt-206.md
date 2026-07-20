# Codex Prompt — Create WF-206 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (GitHub, Jira, Google
Drive/Sheets, Microsoft Teams). **Create every item in the actual app. Do NOT write anything to the
local file system.**

---

You are setting up **mock source data** for a workflow that audits input-validation coverage across an
Express API, then files Jira tickets, upserts a coverage map Sheet, and posts a Teams summary. Your
job is ONLY to create the seed data the workflow reads.

**Do NOT run the audit.** Do NOT decide or record coverage verdicts, do NOT compute or write
exploitability scores, do NOT assign OWASP categories, do NOT create the audit Jira tickets, do NOT
post to Teams, and do NOT write this run's rows into the coverage map. The tables below tell you what
code to *write* so the audit has something true to find — they are your build spec, not output to be
transcribed into a sheet.

## Where each source lives

- **GitHub, Jira, Google Drive/Sheets, Teams** → create real items via the connectors.
- **Route traffic, exposure and auth** → cannot be injected into live gateway logs or APM, so they are
  a **Google Sheet** that stands in as the mock source.
- **The code must be real.** The whole audit compares the field set a validator covers against the
  field set a handler reads, resolved through a real middleware chain — so this is an actual
  working-looking Express monorepo, not a spreadsheet describing one.

## Anchor values (use everywhere; keep identical across every item)

- GitHub repo: **sahidempiricinfotech-dotcom/express-input-audit**, branch **main** (the default branch).
  If it already exists, update files in place — do not create a second repo.
- Folders in scope: `services/api-gateway/`, `services/orders-api/`, `services/uploads-api/`,
  `services/admin-api/`, `shared/middleware/`
- Google Drive folder for both Sheets: **Engineering / Input Validation**
- Traffic sheet: **Route Traffic Data**
- Tracker sheet: **Input Validation Coverage Map**
- Jira project: key **IVA**, name **Input Validation Audit**
- Microsoft Teams: team **Workflow test**, channel **input validation audit**
- Traffic window: **2026-06-15 through 2026-07-14** inclusive, Asia/Kolkata
- Stack: Node + Express 4, CommonJS. Validation libraries deliberately mixed:
  **express-validator**, **Joi**, **Zod**, **celebrate**, **multer**, and **none**.

## The route catalog — the shared spine (enforce exactly)

**18 route/middleware entries, 45 inputs.** An input is **one field** — `req.body.email` is one input
and `req.body.shippingAddress.zip` is another. Build every route at a real, findable line, with the
exact validation shape and the exact field set described. The "Intended finding" column is *why the
code is written that way* — write it so an honest reader reaches that conclusion from the code alone.

> **Never annotate the answer.** No comment anywhere may say a field is unvalidated, weak, a gap, or
> a vulnerability. No `// TODO: validate this`, no `// FIXME: injection`. The seed describes the
> world; the audit draws the conclusions. A run that reads the verdict off a comment proves nothing.

### A) `services/api-gateway/` — the mount point (9 inputs)

The gateway is what makes **mounted paths** real. Router files must use short local paths and the
gateway must mount them, so `router.post('/create')` in `orders-api` is really
`POST /api/v1/orders/create`. Mount in `services/api-gateway/src/app.js`:
```js
app.use(requestId)
app.use('/api/v1', tenantContext)          // shared/middleware — reads a header, see §E
app.use('/api/v1', rateLimitByKey)         // shared/middleware — reads a header, see §E
app.use('/api/v1/orders',  require('../../orders-api/src/routes/orders'))
app.use('/api/v1/uploads', require('../../uploads-api/src/routes/uploads'))
app.use('/api/v1/admin',   requireAdmin, require('../../admin-api/src/routes/admin'))
app.use(errorHandler)                       // last — an error handler, not validation
```
`requireAdmin` mounted here, several files above the admin routers, is the **only** thing making the
admin routes admin-only. A run that reads the admin router file alone will miss it.

| Route | File / handler | Validation | Fields the handler reads | Intended finding |
|---|---|---|---|---|
| `POST /api/v1/auth/login` | `src/routes/auth.js` → `loginHandler` | express-validator, same file: `body('email').isEmail()`, `body('password').exists()` | via `const { email, password, tenantId, rememberMe } = req.body` | **coverage gap** — chain covers 2 of 4. `email` validated. `password` weak (`exists()` and nothing else) and it reaches a raw SQL legacy lookup. `tenantId` unvalidated, concatenated into SQL. `rememberMe` unvalidated, drives session TTL. |
| `GET /api/v1/health` | `src/routes/health.js` → `healthHandler` | **none** | `req.query.verbose` | no-validation route; `verbose` only echoed back |
| `GET /api/v1/search` | `src/routes/search.js` → `searchHandler` | Zod via `validate(buildSearchSchema())` where `buildSearchSchema()` is **built at runtime** from a `SEARCHABLE_FIELDS` array | `req.query.q`, `.limit`, `.offset`, `.sort` | **coverage gap + runtime schema → medium confidence at best.** Schema covers `q`, `limit`, `offset`, not `sort`. `q` is `z.string()` with **no length bound** and lands in a `RegExp` → weak. `limit`/`offset` are `z.number().min(1).max(100)` → validated. `sort` unvalidated, concatenated into `ORDER BY`. |

### B) `services/orders-api/` — alias & cross-file tracing (16 inputs)

| Route | File / handler | Validation | Fields | Intended finding |
|---|---|---|---|---|
| `POST /api/v1/orders/create` | `src/routes/orders.js` → `createOrder` | Joi via `validateBody(createOrderSchema)` imported from `shared/middleware/validateBody.js`. Schema covers `customerEmail: Joi.string().email()`, `items: Joi.array()` (**no item schema, no max**), `total: Joi.number()` (**no min**) | handler does `const { body } = req` then reads `body.customerEmail`, `body.items`, `body.total`, `body.couponCode`, `body.shippingAddress.zip`, `body.shippingAddress.country`, `body.notes` | **the headline gap route** — 3 of 7 covered, and the middleware is camouflage. `customerEmail` validated. `items` weak (type only; unbounded array → DB insert). `total` weak (type only, no min → negative price reaches business logic). `couponCode`, `shippingAddress.zip`, `shippingAddress.country` unvalidated → DB query. `notes` unvalidated, logged only. **Note the `const { body } = req` alias.** |
| `PATCH /api/v1/orders/:orderId/status` | `src/routes/orders.js` → `updateStatus` | express-validator: `param('orderId').isUUID()` only | `req.params.orderId`, `req.body.status`, `req.body.reason`, `req.headers['x-actor-id']` | coverage gap. `orderId` validated. `status` unvalidated → business logic. `reason` unvalidated, logged. **`x-actor-id` unvalidated and reaches a DB query** — the headers surface nobody validates. |
| `POST /api/v1/orders/bulk-import` | `src/routes/orders.js` → `bulkImport` | **none** | `Order.create({ ...req.body })` — a **spread**. Also passes bare `req` into `importService.process(req)` in `src/services/importService.js`, which reads `req.body.dryRun` **two files away** | no-validation route. The spread is an **unbounded object input** — record as one input (`body.*`), not a guessed field list. `dryRun` only findable by following `req` across the file boundary. |
| `GET /api/v1/orders/:orderId` | `src/routes/orders.js` → `getOrder` | `celebrate({ params: Joi.object({ orderId: Joi.string().uuid().required() }) })` | `req.params.orderId` only | **fully validated** — must come back clean. |
| `POST /api/v1/orders/webhook` | `src/routes/orders.js` → `webhookHandler` | **none** | `req.body.type`, then dispatches `handlers[req.body.type](req)` where `handlers` is populated by a **dynamic `require` over a directory** at startup | **the Unresolved case.** `body.type` is resolvable (unvalidated, drives dispatch). The rest of the payload genuinely **cannot** be resolved statically — the audit should say so with candidates and low confidence, not invent a field list. |

### C) `services/uploads-api/` — multer (9 inputs)

| Route | File / handler | multer config | Handler touches | Intended finding |
|---|---|---|---|---|
| `POST /api/v1/uploads/avatar` | `src/routes/avatar.js` → `uploadAvatar` | `limits: { fileSize: 5*1024*1024 }` — **no `fileFilter`** | `file.originalname` (used to build a disk path, no length/pattern bound), `file.mimetype` (checked with an `if` **inside the handler, after the file already landed**), `req.body.userId` | gap. Size present; **MIME and filename missing**. The in-handler MIME check does not count — it runs after multer wrote the file. `userId` unvalidated → DB. |
| `POST /api/v1/uploads/document` | `src/routes/document.js` → `uploadDocument` | **no `limits`, no `fileFilter`** — bare `multer({ dest })` | `fs.writeFileSync(path.join(UPLOAD_DIR, file.originalname))`, `file.size`, `req.body.docType` | **the worst route in the repo** — public multipart upload with zero multer config. **All three missing (MIME, size, filename)**; unbounded filename straight into a filesystem path. |
| `POST /api/v1/uploads/batch` | `src/routes/batch.js` → `uploadBatch` | `fileFilter` (MIME whitelist), `limits: { fileSize, files }`, and `storage.filename` sanitizing via a **bounded** regex (`/^[\w.-]{1,64}$/`) | `file.originalname`, `file.mimetype`, `req.body.albumId` (Joi validated) | **fully validated upload** — must come back clean. This is the don't-cry-wolf control. |

### D) `services/admin-api/` — chain order & mount inheritance (9 inputs)

All of these are admin-only **solely** because of `requireAdmin` mounted in the gateway (§A).

| Route | File / handler | Validation | Fields | Intended finding |
|---|---|---|---|---|
| `POST /api/v1/admin/users/:userId/role` | `src/routes/admin.js` → `setRole` | `router.use(auditLogger)` in-file + `body('role').isIn(['user','admin'])` | `req.params.userId`, `req.body.role`, `req.body.reason` | gap. `role` validated. `userId` unvalidated → DB query. `reason` unvalidated, logged only. |
| `GET /api/v1/admin/reports/export` | `src/routes/admin.js` → `exportHandler` | **registered AFTER the handler**: `router.get('/reports/export', exportHandler, validateExportQuery)`. Also `router.use(errorHandler)` at the bottom | `req.query.format` (reaches a template render), `.from`, `.to` (reach a DB query) | **no-validation route, not a gap route.** `validateExportQuery` sits on the route line but never runs before the handler, and the error handler is not coverage. A lazy scan sees a validator on the line and calls it covered. |
| `DELETE /api/v1/admin/cache` | `src/routes/admin.js` → `flushCache` | **none** | `req.query.pattern` → `exec('redis-cli KEYS ' + pattern)` — a **shell call** | no-validation route. **This route gets NO row in the traffic sheet** → traffic-unknown. |
| `GET /api/v1/admin/settings/flags` | `src/routes/admin.js` → `getFlags` | **none** | `req.query.verbose`, `req.query.page` — both only echoed back | no-validation, but low-stakes: admin-only, tiny traffic, booleans/numbers, echoed. This is the **sheet-only** route — it must score under the ticket threshold. |

### E) `shared/middleware/` — chains, and inputs of its own (2 inputs)

Build the shared chains other services import: `validateBody.js` (Joi wrapper), `validators/orderChain.js`
(express-validator), `requireAdmin.js`, `errorHandler.js`, `requestId.js`.

Two of these read user input themselves, and are mounted **app-wide at `/api/v1`** in the gateway — so
they are user-reachable inputs living in middleware, not on any one route. Record them against the
mounted path they're registered at (`ALL /api/v1/*`), and give that key a row in the traffic sheet so
the join resolves cleanly:

| File | Reads | Intended finding |
|---|---|---|
| `shared/middleware/tenantContext.js` | `req.headers['x-tenant-id']` → used in a DB query to load tenant config | unvalidated header, reaches a DB query, applies to **every** route including public ones |
| `shared/middleware/rateLimitByKey.js` | `req.headers['x-api-key']` → used as a Redis counter key, and logged | unvalidated header, but only logged |

### F) `CODEOWNERS` (repo root)

GitHub precedence is **last match wins**. Write it so a naive "most specific pattern wins" reading
gets a different answer, and so `shared/middleware/` matches nothing. Do **not** add a `*` default.
```
/services/api-gateway/                     @gateway-team
/services/uploads-api/                     @uploads-team
/services/admin-api/                       @admin-team
/services/orders-api/                      @orders-team
/services/orders-api/src/routes/orders.js  @orders-routes-team
/services/orders-api/src/routes/           @orders-web-team
```
(Last-wins means `orders.js` lands on **@orders-web-team**, not `@orders-routes-team` — the broader
pattern is listed later. That is intentional; leave it. `shared/middleware/` matches nothing and must
fall through to the platform team.)

## What to create

### 1) GitHub repo `sahidempiricinfotech-dotcom/express-input-audit` (branch `main`)

The Express monorepo above, with all 18 entries at real findable lines. Also add a root `README.md`
describing the layout, a root `package.json` with the mixed validation deps
(`express-validator`, `joi`, `zod`, `celebrate`, `multer`) so the library mix is real, and a
per-service `package.json`. Handlers must reach their sinks through **real code** — a `db.query()`
with a template literal for the SQL-concat cases, a real `exec()` for the shell case, a real
`fs.writeFileSync`/`path.join` for the filesystem case, a real `RegExp` for the ReDoS case. The audit
classifies sink severity from what the code does, so the sinks have to actually be there.

### 2) Google Sheet — "Route Traffic Data" (in the Drive folder)

**Tab `routes`** — columns: `date, method, mounted_path, auth, requests_per_hour`.
Daily rows joined on **method + mounted path** (paths must match the gateway's mounted paths
byte-for-byte, not the router-file paths).

`auth` ∈ `public | authenticated | admin` — **this column is the audit's only source for
reachability**, so it must be consistent with the code (`requireAdmin` mounts, public routes).

- Cover the window **2026-06-15 → 2026-07-14** for every route **except `DELETE /api/v1/admin/cache`**,
  which gets **no rows at all** so the traffic-unknown path is exercised.
- **Also add out-of-window rows** — 2026-06-01 → 2026-06-14 and 2026-07-15 → 2026-07-20 — with
  **deliberately different** values, so a run that forgets to filter by the window lands in the wrong
  bucket: `POST /api/v1/uploads/document` runs ~500/hr in-window but ~50/hr in the earlier rows;
  `POST /api/v1/orders/create` runs ~900/hr in-window but ~1,500/hr in the July 15–20 rows.
- Keep in-window daily values **tightly clustered** so a bucket can't flip on rounding — the audit
  must be reproducible. Nothing should sit near 100 or 1000. Target daily averages and auth:

| method + mounted_path | auth | ~req/hr |
|---|---|---|
| `ALL /api/v1/*` | public | 4000 |
| `GET /api/v1/health` | public | 3000 |
| `POST /api/v1/auth/login` | public | 1800 |
| `GET /api/v1/search` | public | 1200 |
| `GET /api/v1/orders/:orderId` | authenticated | 1100 |
| `POST /api/v1/orders/create` | authenticated | 900 |
| `POST /api/v1/uploads/document` | public | 500 |
| `POST /api/v1/uploads/avatar` | authenticated | 300 |
| `POST /api/v1/orders/webhook` | public | 200 |
| `PATCH /api/v1/orders/:orderId/status` | authenticated | 150 |
| `POST /api/v1/orders/bulk-import` | authenticated | 40 |
| `POST /api/v1/uploads/batch` | authenticated | 20 |
| `GET /api/v1/admin/settings/flags` | admin | 8 |
| `POST /api/v1/admin/users/:userId/role` | admin | 5 |
| `GET /api/v1/admin/reports/export` | admin | 3 |
| `DELETE /api/v1/admin/cache` | — | **no rows at all** |

### 3) Google Sheet — "Input Validation Coverage Map" (in the Drive folder)

Create it with **exactly** these header columns, in this order:

`route method, mounted path, field path, request surface, source file, line number, handler,
validation library, middleware chain, coverage verdict, weak reason, exploitability score, score
breakdown, traffic per hour, OWASP category, confidence, Jira ticket, status, owner, last reviewed`

Add **exactly four rows from a pretended previous run** (older `last reviewed` dates) and nothing
else — this run's rows are the workflow's output. Rows are keyed on **method + mounted path + field
path**:

1. `POST` / `/api/v1/uploads/document` / `file.originalname` — `last reviewed` **2026-05-20**, a stale
   score and verdict, **`owner` = uploads-team**, **`status` = In Progress** filled in by a human.
   *(Tests that the upsert refreshes verdict/score/OWASP/Jira/last-reviewed but leaves `owner` and
   `status` alone.)*
2. `POST` / `/api/v1/orders/create` / `body.couponCode` — `last reviewed` **2026-05-20**,
   **`owner` = orders-team**, **`status` = Accepted Risk**. *(Same test, on the headline gap route.)*
3. `GET` / `/api/v1/orders/:orderId` / `params.orderId` — `last reviewed` **2026-05-20**, verdict
   validated, `owner` and `status` **empty**. *(Tests that a clean row updates cleanly.)*
4. `POST` / `/api/v1/legacy/checkout` / `body.cardToken` — `last reviewed` **2026-04-02**, verdict
   unvalidated, `status` = Open. **This route must NOT exist anywhere in the repo.** *(Tests that a
   row whose code is gone gets marked Resolved with the run date instead of deleted.)*

### 4) Jira — project `IVA` (Input Validation Audit)

Ensure the project exists with **components** `gateway-team`, `orders-team`, `orders-web-team`,
`orders-routes-team`, `uploads-team`, `admin-team`, `platform-team` (the CODEOWNERS teams plus the
fall-through owner).

Create **exactly three** pre-existing tickets and no others. Tickets are **per route**, not per field:

1. **Open** — `Unvalidated input in POST /api/v1/uploads/document`, status To Do, with a stale score
   and description from the "previous run". *(Must be updated, not duplicated.)*
2. **Open** — `Unvalidated input in POST /api/v1/orders/create`, status In Progress, stale details.
   *(Must be updated, not duplicated.)*
3. **Done/Closed** — `Unvalidated input in GET /api/v1/search`. *(The workflow only searches for
   **open** tickets, so this one should get a **new** ticket — closed is not a reason to skip.)*

Do **not** create any other audit tickets — those are the workflow's output.

### 5) Microsoft Teams

Confirm team **Workflow test** and channel **input validation audit** exist; create the channel if it
isn't there. Do not post — the summary is the workflow's output.

## Consistency rules (verify all before reporting done)

1. **18 entries / 45 inputs** exist across the five folders, at real findable lines, with the exact
   field sets above. Body, params, query and headers are all represented as separate surfaces.
2. Router files use **short local paths**; the gateway mounts them. Every mounted path in the traffic
   sheet matches what the gateway actually produces, byte-for-byte.
3. `requireAdmin` is mounted **only** in the gateway — never inside the admin router — so the chain
   must be resolved across files to learn the admin routes are admin-only.
4. The three alias/indirection cases are real: `const { body } = req` in `createOrder`; the
   `{ ...req.body }` spread in `bulkImport`; bare `req` into `importService.process(req)` reading
   `body.dryRun` two files away.
5. `GET /api/v1/admin/reports/export` has its validator **after** the handler on the route line, and
   `errorHandler` is mounted last in the gateway. Neither is coverage.
6. `buildSearchSchema()` genuinely builds the Zod schema at runtime from an array — the field list is
   only knowable by reading the builder.
7. multer: `avatar` has limits but no fileFilter; `document` has neither; `batch` has fileFilter +
   limits + a bounded filename regex. The `avatar` MIME check is **inside the handler**, after the
   write.
8. `DELETE /api/v1/admin/cache` has **no rows** in the traffic sheet; every other route has in-window
   rows; `uploads/document` and `orders/create` have out-of-window rows with different values.
9. The `auth` column agrees with the code for every route.
10. `CODEOWNERS` has no `*` default, has the last-wins overlap on `/services/orders-api/src/routes/`,
    and leaves `shared/middleware/` unmatched.
11. The coverage map has the 20 headers, exactly four prior rows, human `owner`/`status` set on rows 1
    and 2, and `/api/v1/legacy/checkout` pointing at a route that does not exist.
12. Jira IVA has exactly three tickets (two open, one closed) and the seven components.
13. **Nowhere in the repo, the sheets, or the tickets is there a comment, column, or note that states a
    coverage verdict, a score, or an OWASP category for this run.**

## When done — report back (so the workflow prompt can be filled to match)

List: the **repo full name + default branch** and confirmation all five folders exist with the 18
entries at real lines; the **URL of both Google Sheets**; the **Jira project key + the seven component
names + the three seeded ticket keys**; and confirmation the **Teams team/channel** exist. If any of
the Jira components, the Teams channel, or the repo could not be created, **say so explicitly and name
which** — do not report done with a gap. Finish with a short note confirming the thirteen consistency
rules hold, calling out specifically that the mounted paths match the sheet byte-for-byte, that
`requireAdmin` exists only in the gateway, and that no verdict/score/OWASP tag appears anywhere in the
seed. Do not create any local files.
