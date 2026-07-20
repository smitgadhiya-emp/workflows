# Codex Prompt — Create WF-052 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (Jira, GitHub, Google
Drive/Sheets, Microsoft Teams) and a Chrome session, so create every item **in the actual app** — do
NOT write anything to the local file system.

---

You are setting up **mock source data** for a workflow that audits a backend API surface and finds
endpoints that have become dead weight (never called, near-zero, deprecated-but-still-live, legacy
versions) so a team can retire them safely. The workflow later reads an actual backend repo, reads a
traffic/monitoring Google Sheet, cross-checks four signals per endpoint (traffic, code dependencies,
docs, clients), then updates a tracker sheet, opens Jira deprecation issues, writes a report, and
posts to Teams. **Your job is only to create the seed data the workflow reads.** Do NOT run the audit
itself, and do NOT create any of its outputs. Do NOT create any local files — everything must be
created officially (a real GitHub repo, real Google Sheets, a real Jira project state, a Drive
folder) using the connected plugins.

## Anchor values (must match exactly across every item you create)

- **GitHub monorepo:** `keyurempiricinfotech-art/test-repo`, primary branch **main**. The analyzed
  API surface lives under **`apps/backend`**.
- **Backend stack:** **NestJS 10 (TypeScript, Node 20)** with Apollo GraphQL + REST controllers +
  webhook handlers, REST versioned under `/api/v1` and `/api/v2`.
- **Traffic sheet:** Google Sheet named **`mock api data`**, covering **2026-05-01 through
  2026-06-29** (Asia/Kolkata) — the full 60-day window.
- **Lifecycle tracker sheet:** Google Sheet named **`api workflow test`** (seed baseline rows only).
- **Jira project:** **`api-reporting`** (seed project state + one dedup fixture issue only).
- **Google Drive folder:** **`Engineering / API Lifecycle`** — holds both sheets.
- **Microsoft Teams:** team **`Workflow test`**, channel **`Workflow test`**.

GitHub cannot be mocked as a spreadsheet here because the workflow greps and analyzes **real code**
across multiple surfaces (backend, web, mobile, SDK, internal services, workers, docs). So create an
actual monorepo with coherent, cross-referenced code — rich enough to grep, not necessarily runnable.

---

## The single most important thing: the endpoint ground-truth table

Every endpoint's **code**, its **rows in the traffic sheet**, its **presence/absence in the OpenAPI
spec**, and its **references (or lack of them) across the other apps** must all agree with the table
below. This is what makes the audit gradeable. The columns encode the four signals the workflow
checks (traffic, deps, docs, clients) plus the bucket each endpoint is designed to land in. Traffic
numbers are **real-caller counts** (after synthetic traffic is stripped — see the synthetic section).

| # | Endpoint (identity = route + method + version) | Public/Internal | Real reqs (60d) | Code deps (which surface references it) | In OpenAPI? | Known client | Deprecated in code? | Designed bucket / outcome |
|---|---|---|---|---|---|---|---|---|
| 1 | `POST /api/v1/auth/login` | Public | ~52,000 | web, mobile, sdk | Yes | Web + Mobile | No | Active → **Keep** |
| 2 | `GET /api/v2/products` | Public | ~48,000 | web, mobile, sdk | Yes | Web + Mobile | No | Active → **Keep** |
| 3 | `GET /api/v1/products` | Public | ~40 | mobile (old pinned version only) | Yes (marked legacy) | Old mobile build | No | **Legacy version** (v2 supersedes) → Keep, caution |
| 4 | `GET /api/v1/recommendations` | Public | ~18 | none in repo; external partner calls it | Yes (marked deprecated) | Partner "AcmePartnerCo" | **Yes** | **Deprecated-but-live** → Keep + **Immediate Engineering Review** + Candidate for Deprecation |
| 5 | `DELETE /api/v1/wishlist/{id}` | Public | 0 | **none, any surface** | **No** | **None** | No | Never-called, clean → **Safe to Remove** (has the pre-seeded Jira dedup issue) |
| 6 | `GET /api/v1/legacy/export` | Internal | 0 | **notification-worker cron (live dep)** | No | Internal cron | No | Never-called **but live code dep** → **Keep** (zero traffic ≠ safe) |
| 7 | `GET /api/v1/coupons/validate` | Public | ~3 | web checkout, but via a **dynamically built route string** (`/api/v1/coupons/${action}`) — unresolvable | Yes | Web (unclear) | No | Near-zero + **dep hole** → **Needs Review** |
| 8 | `GET /api/v1/orders/{id}/invoice` | Public | ~7 | web billing | Yes | Web (version can't be pinned) | No | Near-zero + **unattributed version traffic** → **Needs Review** |
| 9 | `POST /internal/reindex` | Internal | ~1,200 | search-service | No (internal) | Internal search-service | No | Internal-only, active dep → **Keep** |
| 10 | `GET /internal/metrics-summary` | Internal | ~12 | web admin dashboard | No (internal) | Internal admin | No | Low-usage internal, live dep → **Keep** |
| 11 | `GET /api/v1/status-report` | Public | ~90 (incl. ambiguous) | none clear | Yes | Caller `acme-status-checker` — can't tell if synthetic or real | No | **Dirty traffic can't be cleaned** → keep hits in count + **Needs Review** for dirty traffic |
| 12 | `POST /webhooks/stripe` | Public (signed) | ~9,500 | payment-service handler | Yes | Stripe (third party) | No | Active webhook → **Keep** |
| 13 | `POST /webhooks/legacy-shipping` | Public | 0 | **none** (provider removed) | **No** | **None** | No | Never-called webhook, clean → **Safe to Remove** |
| 14 | GraphQL Query `products` | Public | ~15,000 | web, mobile | Yes (schema) | Web + Mobile | No | Active → **Keep** |
| 15 | GraphQL Mutation `applyPromo` | Public | ~5 | referenced only **behind a config flag** — unresolvable | Yes (schema) | Web (unclear) | No | Near-zero + **dep hole** → **Needs Review** |
| 16 | GraphQL Query `legacyInventory` | Public | 0 | **none** | **No** | **None** | **Yes** | Never-called, deprecated resolver, clean → **Safe to Remove** |

Coverage this gives the auditor: three clean **Safe to Remove** (5, 13, 16), one **zero-traffic-but-
Keep** trap (6), three **Needs Review** for different reasons — dep hole (7, 15), unattributed
version (8), dirty traffic (11) — a **deprecated-but-live** loud item (4), a **legacy version** (3),
**internal-only** keeps (9, 10), and healthy **actives** (1, 2, 12, 14). Every one of the four
signals swings at least one verdict, and no verdict rests on traffic volume alone.

---

## What to create

### A) GitHub monorepo — `keyurempiricinfotech-art/test-repo` (branch `main`)

Create a real repo. Make it internally consistent: routes match controllers, controllers match
services/repositories, the GraphQL schema matches its resolvers, the OpenAPI spec matches the table
above (and pointedly **omits** the safe-to-remove endpoints), and cross-app references match the
"Code deps" column exactly. Aim for analyzable depth, not a running app.

```
test-repo/
  package.json                      # workspaces: apps/*, services/*, packages/*
  README.md                         # monorepo + architecture summary (modules, versioning, GraphQL)
  apps/
    backend/                        # <-- THE ANALYZED API SURFACE (NestJS 10)
      src/
        main.ts
        app.module.ts
        modules/
          auth/                     # auth.controller (login, refresh), service, guard (JWT/Passport)
          products/                 # products.controller v1+v2, service, repository, product.entity
          orders/                   # orders.controller (incl. /orders/:id/invoice), service, repo
          coupons/                  # coupons.controller (validate), service
          wishlist/                 # wishlist.controller (DELETE /:id) — ORPHAN, nothing calls it
          recommendations/          # recommendations.controller — mark @deprecated in JSDoc + decorator
          internal/                 # reindex.controller, metrics-summary.controller (internal guard)
          status/                   # status-report.controller
          webhooks/                 # stripe.controller, legacy-shipping.controller (orphan)
        graphql/
          schema.graphql            # types + Query.products, Query.orderHistory, Mutation.applyPromo,
                                    #   Query.legacyInventory (@deprecated), Query.legacyInventory has no client
          resolvers/                # products.resolver, promo.resolver, legacy-inventory.resolver
        common/                     # versioning setup, exception filter, logging interceptor, cache
      docs/
        openapi.yaml                # documents ONLY the endpoints marked "In OpenAPI? Yes" above
    web/                            # React storefront — references #1,2,7(dynamic),8,10(admin),14
    mobile/                         # React Native — references #1,2,3(old pinned v1),14
  services/
    search-service/                 # internal service that calls POST /internal/reindex  (#9)
    notification-worker/            # cron/worker that calls GET /api/v1/legacy/export       (#6)
    payment-service/                # handles POST /webhooks/stripe                          (#12)
  packages/
    sdk/                            # public TS SDK — wraps #1, #2 only
    shared/                         # shared types/config; holds the config flag that gates applyPromo (#15)
```

Requirements that create the ground truth the audit depends on:

1. **Versioning is real:** `/api/v1/products` and `/api/v2/products` are two distinct
   controllers/handlers (identity = route+method+version). Do not collapse them.
2. **Orphans are truly orphaned:** `DELETE /api/v1/wishlist/{id}` (#5), `POST /webhooks/legacy-
   shipping` (#13), and GraphQL `legacyInventory` (#16) must have **zero references** anywhere in the
   monorepo and must **not** appear in `openapi.yaml` / the documented schema surface. A grep for them
   across `apps/`, `services/`, `packages/`, `docs/` returns nothing but their own definition.
3. **The zero-traffic trap has a live dep:** `GET /api/v1/legacy/export` (#6) gets **zero traffic**
   but `services/notification-worker` must import/call it on a cron. This is the endpoint that proves
   "no traffic" alone never means "safe to remove."
4. **Deprecated-but-live is marked in code:** `GET /api/v1/recommendations` (#4) and GraphQL
   `legacyInventory` (#16) carry an explicit `@deprecated` marker (decorator/JSDoc/schema directive).
5. **Two deliberate dependency holes** (so the auditor must kick them to review, not guess):
   - Web checkout calls coupons via a built string: `` fetch(`/api/v1/coupons/${action}`) `` (#7) — a
     static grep for `/api/v1/coupons/validate` won't resolve it.
   - `applyPromo` (#15) is only invoked behind a config flag read from `packages/shared` — the call
     site is gated and not statically obvious.
6. **OpenAPI spec** documents exactly the rows marked "Yes" and omits the three clean removals.

Make the first/only commit on `main` coherent so the workflow can note the exact baseline commit.

### B) Google Sheet — `mock api data` (traffic / monitoring)

Create a Sheet named **`mock api data`** in the Drive folder, one row per request event (or per
day-bucket per endpoint — either works as long as totals reconcile to the table). Columns:

`timestamp` (Asia/Kolkata, within 2026-05-01…2026-06-29) · `route` · `method` · `version` ·
`endpoint_id` (1–16 from the table) · `client_id` · `user_agent` · `auth_method`
(JWT / Sanctum / signed-webhook / internal-token / none) · `status_code` · `latency_ms` ·
`is_peak` (flag a peak-traffic day) · `source_type` (leave BLANK — the workflow classifies; you set
it up so it's derivable).

Rules that make it gradeable:

- **Real-caller volumes must match the "Real reqs" column** for endpoints 1–16 after synthetic rows
  are excluded. You do not need the exact count to the unit for the high-volume ones — get within a
  few percent — but the **low ones (0, ~3, ~5, ~7, ~12, ~18, ~40) must be exact**, because those are
  what the buckets hinge on. Endpoints 5, 13, 16 must have **zero** real-caller rows.
- **Seed synthetic/fake traffic that must be stripped**, so the strip step has real work and a
  per-endpoint "rows stripped" count exists:
  - Health/probe paths with no real auth: `/healthz`, `/api/v1/ping`, `/status`, `/readiness`,
    `/livez`, `/metrics` — several hundred rows.
  - Synthetic user-agents against real endpoints (esp. #2 and #14): `k6/0.49`, `Pingdom.com_bot`,
    `UptimeRobot`, `synthetic-monitor`, `datadog-agent`, `newrelic-probe`, `health-checker`.
  - These carry `auth_method = none` or a monitoring token, never a real user credential.
- **The one ambiguous caller:** endpoint #11 (`GET /api/v1/status-report`) gets traffic from
  `client_id = acme-status-checker` with `user_agent = acme-status-checker/2.1`. It is deliberately
  impossible to tell whether this is a real internal tool or a synthetic monitor. Do **not** make it
  cleanly match the synthetic patterns. This forces "keep the hits, mark Needs Review for dirty
  traffic."
- **Unattributed version traffic:** endpoint #8 (`/orders/{id}/invoice`) rows should **omit or
  scramble** the `version` field so the auditor can't pin hits to v1 vs v2.

### C) Google Sheet — `api workflow test` (Lifecycle Tracker — BASELINE ONLY)

Create a Sheet named **`api workflow test`** in the Drive folder with this header row exactly:

`Endpoint · Method · Module · Version · Last Prod Call · Total Requests (60d) · Unique Clients ·
Removal Risk · Debt Score · Recommended Action · Owner · Status`

Seed **exactly these 7 baseline rows** (a subset of the 16, so the workflow must both **edit these in
place** and **add the missing 9** — never duplicating a route+method+version key):

| Endpoint | Method | Module | Version | Owner | Status |
|---|---|---|---|---|---|
| `/api/v1/auth/login` | POST | auth | v1 | Platform Team | Active |
| `/api/v2/products` | GET | products | v2 | Catalog Team | Active |
| `/api/v1/products` | GET | products | v1 | *(leave blank)* | Active |
| `/api/v1/recommendations` | GET | recommendations | v1 | Growth Team | Active |
| `/internal/reindex` | POST | internal | — | *(leave blank)* | Active |
| `/webhooks/stripe` | POST | webhooks | — | Payments Team | Active |
| `products` (GraphQL) | QUERY | graphql | — | Catalog Team | Active |

Leave the other tracker columns (Last Prod Call, Total Requests, etc.) blank on these baseline rows —
the workflow fills them. The two **blank Owner** cells are a fixture for the "leave the ownership
column alone even if it's blank" rule. Do **not** seed rows for endpoints 5, 6, 7, 8, 10, 11, 13, 15,
16 — those are the "no existing row → add new" cases.

### D) Jira — project `api-reporting`

The project must exist and expose the statuses the workflow uses (map to whatever the project can
actually offer and record the mapping): a **To Do / Open** state for new deprecation issues. Confirm
these labels are available: `technical-debt`, `api-cleanup`, `backend`, `architecture`,
`deprecation`.

Seed **exactly one** pre-existing issue as a **dedup fixture**:

- Summary: **`Deprecate DELETE /api/v1/wishlist/{id}`** (endpoint #5).
- A short body noting it's a candidate-for-deprecation ticket, labels `technical-debt`,
  `api-cleanup`, `deprecation`, unassigned.
- This exists so the workflow's "check the project first so you don't reopen a duplicate" path is
  exercised. Do **not** create issues for any other endpoint — those are the workflow's output.

### E) Google Drive folder — `Engineering / API Lifecycle`
Ensure the folder exists and contains **only** the two Sheets above (`mock api data`, `api workflow
test`). Do not put a report in it — the report is the workflow's output.

### F) Microsoft Teams
Confirm the team **`Workflow test`** and channel **`Workflow test`** exist. Do **not** post anything —
the completion summary is the workflow's output.

---

## Do NOT create (these are the workflow's outputs)
- The report Sheet (title pattern **`API Technical Debt Report Months-Year`**, resolves to
  `05-06/2026` for this window).
- Any Jira deprecation issue other than the single wishlist dedup fixture.
- Any edits/fills to the `api workflow test` tracker beyond the 7 baseline rows.
- The Teams summary message.
- Any local files at all.

## When done
Report back with:
1. The GitHub repo URL and confirmation branch `main` exists, plus the exact baseline commit SHA.
2. Confirmation that endpoints #5, #13, #16 are truly orphaned (grep-clean, absent from OpenAPI) and
   that #6 is called by `notification-worker`.
3. Links to both Google Sheets and the Drive folder.
4. The Jira project key and the single dedup fixture issue key.
5. Confirmation the Teams team/channel exist.
6. A one-paragraph note confirming the traffic sheet's real-caller totals reconcile with the
   ground-truth table (exact on the low-count endpoints), that synthetic rows are present and
   strippable, and that the ambiguous `acme-status-checker` and unattributed-version fixtures are in
   place.
