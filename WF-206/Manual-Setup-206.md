# WF-206 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, Jira project/admin config, GitHub org, Teams
creation). Do these first, then run the Codex seed prompt, then confirm the workflow prompt matches
what Codex actually reports, then run the workflow.

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **GitHub** (with permission to create repos under `sahidempiricinfotech-dotcom`)
- [ ] **Jira**
- [ ] **Google Drive / Sheets**
- [ ] **Microsoft Teams**

> You do NOT need to connect a gateway log source or an APM. Route traffic, exposure and auth can't be
> injected into those, so they're mocked as the **Route Traffic Data** Sheet. The *workflow* run
> also reads traffic and auth from that Sheet — the prompt already says so at line 29.

## 2. Jira — project + components
- [ ] Project **IVA** (Input Validation Audit) exists.
- [ ] Components created: `gateway-team`, `orders-team`, `orders-web-team`, `orders-routes-team`,
      `uploads-team`, `admin-team`, `platform-team`. These are the CODEOWNERS teams plus the
      fall-through owner. CODEOWNERS decides which team owns a file; the workflow records it on the
      ticket's **Component** field.
- [ ] Confirm the connector can **run a JQL search** on IVA — the "update, don't duplicate"
      idempotency step depends on it. Status set To Do / In Progress / In Review / Done is fine.
- [ ] Confirm the connector can **filter by status**, since the seed includes one *closed* ticket
      (`GET /api/v1/search`) that must NOT suppress a new one.

## 3. GitHub — one repo
- [ ] Repo **sahidempiricinfotech-dotcom/express-input-audit** exists, or Codex can create it.
- [ ] Confirm **`main` is the default branch** (Settings → Branches) so repo searches don't hit an
      empty `develop`.
- [ ] Confirm the connector can **search file contents repo-wide** — resolving middleware chains across
      files and following `req` into service functions both need it.

## 4. Microsoft Teams — team + channel
- [ ] Confirm team **Workflow test** exists (reuse from WF-092/109/138/200) and that the channel
      **input validation audit** exists under it — create the channel if it isn't there yet.

> This was the blocker on WF-138 (team not visible to the connected account). Check it **before** the
> run, not after — the Teams post is the last step and a half-finished run is the one thing the prompt
> explicitly tells the workflow not to do.

## 5. Google Drive — folder for the mock sheet + tracker
- [ ] Create the folder **Engineering / Input Validation**. Codex puts both Sheets there
      (Route Traffic Data, Input Validation Coverage Map).
- [ ] Leave the coverage map's current-run rows empty — only the four seeded prior rows. That's the
      workflow's output.

---

## Two gaps in Prompt-206 worth closing before you run
The seed exposes these; they're prompt bugs, not seed bugs. Both are cheap to fix and both cost you
reproducibility if you don't.

1. **Reachability has no source when a route has no traffic row.** Line 13 says reachability comes
   from the `auth` column of the traffic sheet, *and* that a route with no row gets traffic 2 +
   traffic-unknown. `DELETE /api/v1/admin/cache` is seeded with no row at all — so it has no auth
   either, and the prompt doesn't say what to do. Two engineers will split: one infers `admin` from the
   `requireAdmin` mount, the other marks it Unresolved. **Suggested fix:** add to line 13 — *"If a
   route has no row, infer reachability from the resolved middleware chain and mark it
   reachability-inferred."*
2. **Traffic rows are daily, so the window needs aggregating.** Line 13 says read the sheet over
   2026-06-15 → 2026-07-14 but doesn't say the rows are per-day or that you want a mean. **Suggested
   fix:** say *"average requests_per_hour per route across the window"*, or tell me and I'll flatten
   the sheet to one pre-averaged row per route instead.

A third, softer one: the two `shared/middleware/` inputs are keyed `ALL /api/v1/*` because they're
mounted app-wide rather than on a route. That's seeded with a matching traffic row so the join
resolves, but if you'd rather the audit not treat middleware as a pseudo-route, say so and I'll drop
those two inputs.

## Verify the seed before the real run
Spot-check these by hand; they're the ones that silently break the audit if Codex drifts.

- [ ] **45 inputs across 18 entries**: api-gateway 9, orders-api 16, uploads-api 9, admin-api 9,
      shared/middleware 2. All four surfaces (body / params / query / headers) present.
- [ ] **Mounted paths match the sheet byte-for-byte.** Router files use short local paths
      (`router.post('/create')`), the gateway mounts them at `/api/v1/orders`, and the sheet says
      `/api/v1/orders/create`. A drift here silently drops a route to traffic-unknown.
- [ ] **`requireAdmin` appears only in the gateway**, never inside `services/admin-api/`.
- [ ] **`GET /api/v1/admin/reports/export`** has `validateExportQuery` listed *after* `exportHandler`
      on the route line.
- [ ] **`DELETE /api/v1/admin/cache`** has zero rows in the traffic sheet.
- [ ] **Out-of-window rows** exist with different values for `uploads/document` (~500 in-window vs ~50
      before) and `orders/create` (~900 in-window vs ~1500 after).
- [ ] **multer**: `avatar` = limits, no fileFilter, MIME checked inside the handler; `document` =
      neither; `batch` = fileFilter + limits + bounded filename regex.
- [ ] **`CODEOWNERS`** has no `*` default, has `/services/orders-api/src/routes/` listed *after* the
      `orders.js` line, and leaves `shared/middleware/` unmatched.
- [ ] **Coverage map** has the 20 headers, exactly 4 prior rows, human `owner`/`status` set on
      `uploads/document + file.originalname` and `orders/create + body.couponCode`, and
      `/api/v1/legacy/checkout` pointing at a route that does **not** exist.
- [ ] **Jira IVA** has exactly 3 tickets: 2 open (`uploads/document`, `orders/create`), 1 closed
      (`search`). No others.
- [ ] **No verdict, score, or OWASP tag anywhere in the seed** — not in a code comment, not in a sheet
      column, not in a ticket. If Codex helpfully added `// TODO: validate this` or `// FIXME:
      injection`, delete it. The audit has to find it.

## What the seed is designed to catch (why these specific values)
Useful when reviewing the run's output — these are the traps, not an expected answer sheet.

| Trap | Where | What a lazy run does wrong |
|---|---|---|
| `const { body } = req` alias | `createOrder` | misses all 7 fields by grepping `req.body` |
| `{ ...req.body }` spread | `bulkImport` | invents a field list instead of one unbounded object input |
| Bare `req` into a service, 2 files away | `importService.process(req)` → `body.dryRun` | field never found |
| Nested field = separate input | `shippingAddress.zip` vs `.country` | counted as one input |
| Validation middleware as camouflage | `orders/create` (3 of 7 covered) | route reads green; 4 fields are naked |
| Validator registered *after* the handler | `admin/reports/export` | credited as covered |
| Error handler mistaken for validation | gateway `errorHandler` | credited as covered |
| Auth middleware mounted files above | `requireAdmin` in the gateway | admin routes read as public → +30 on every admin score |
| Runtime-built schema | `buildSearchSchema()` | field list guessed instead of reasoned; confidence not dropped to medium |
| Weak: type-only on a concat sink | `body.password` (`exists()` only) | called validated |
| Weak: no length bound into a regex | `query.q` (`z.string()`) | called validated — this is the ReDoS shape |
| Weak: no min on a price | `body.total` (`Joi.number()`) | called validated; negative totals pass |
| Weak: unbounded array | `body.items` (`Joi.array()`) | called validated |
| Headers surface | `x-actor-id`, `x-tenant-id`, `x-api-key` | not scanned at all |
| Input living in middleware, not a route | `shared/middleware/` (2 inputs) | folder skipped as "not routes" |
| multer MIME checked inside the handler | `uploads/avatar` | credited — the file already landed |
| Unbounded filename → fs path | `uploads/document` | not flagged because a size limit "exists" (it doesn't here) |
| Which of MIME/size/filename is missing | `avatar` (MIME+filename) vs `document` (all 3) | reported as a flat "not validated" |
| Fully validated controls | `orders/:orderId`, `uploads/batch` | false positives that burn credibility |
| No traffic row | `admin/cache` | dropped, or a number invented, instead of 2 + traffic-unknown |
| Out-of-window traffic rows | `uploads/document`, `orders/create` | wrong bucket → wrong score → wrong ranking |
| Genuinely unresolvable dispatch | `orders/webhook` payload | field list invented instead of an Unresolved row |
| Ties in the ranking | 5-way at 92, 6-way at 73, 5-way at 54 | order moves between runs |
| Route top score vs field score | `admin/users/:userId/role` (top 54, but `body.reason` is 29) | drops the route, or files per-field tickets |
| Threshold is per route, not per field | `admin/settings/flags` (top 22) | ticketed anyway |
| CODEOWNERS last-wins | `orders.js` | assigned to `orders-routes-team` instead of `orders-web-team` |
| CODEOWNERS fall-through | all of `shared/middleware/` | left unassigned instead of platform + a note |
| Closed ticket ≠ open ticket | `search` | skipped as "already exists" |
| Human-owned columns | the 2 seeded rows with owner/status | overwritten |
| Route deleted since last run | `/api/v1/legacy/checkout` row | row deleted instead of marked Resolved |

## What you do NOT set up (the workflow produces these)
- The per-route Jira tickets (beyond the three seeded ones)
- The current-run rows in the Input Validation Coverage Map
- The Teams summary
