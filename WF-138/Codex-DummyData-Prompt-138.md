# Codex Prompt — Create WF-138 Dummy Data (in the real apps)

Paste everything below the line into Codex. Codex has the connected plugins (GitHub, Jira, Google
Drive/Sheets, Microsoft Teams). **Create every item in the actual app. Do NOT write anything to the
local file system.** (That was the mistake last time — don't repeat it.)

---

You are setting up **mock source data** for a workflow that traces slow PostgreSQL queries back to
the exact code that fires them, across a multi-service stack, then files Jira tickets, updates a
tracker sheet, and posts a Teams summary. Your job is ONLY to create the seed data the workflow
reads. Do NOT run the tracing workflow itself, do NOT create the optimization Jira tickets, do NOT
post to Teams, and do NOT write the current run's rows into the tracker.

**Where each source lives** (this is the important rule):
- **GitHub, Jira, Google Drive/Sheets, Teams** → create real items via the connectors.
- **PostgreSQL `pg_stat_statements` + slow query log**, and **Datadog / New Relic / Grafana +
  traces** → cannot have data injected into the live products, so represent each as a **Google
  Sheet in the Drive folder** that stands in as the mock source (same pattern as a "mock api data"
  sheet).
- **The code must be real** — the whole workflow is about pinning a query to a file and line, so the
  repos below are actual repositories with actual ORM calls, not spreadsheets.

## Anchor values (use everywhere; keep them identical across every item)

- GitHub repo: **keyurempiricinfotech-art/db-performance** — ONE monorepo (the connector can't create
  multiple repos). This repo already exists and is populated on branch **main** with the subfolders
  `api-node/`, `workers-python/`, `supabase-functions/`, `web-storefront/`, `admin-panel/` (Q1–Q10
  trace files verified; old `acme-commerce` fallback repo already cleaned). If you re-run, update
  files in place — do not create new repos.
- Branch: **main** (the populated default branch).
- Supabase project (for reference): **acme-storefront** (ref `acmestorefront`)
- Postgres (for reference): cluster **acme-prod-pg**, database **acme_production**, env **production**
- Jira project: key **DBP**, name **DB Performance**
- Reporting window: **2026-06-06 through 2026-07-05** (inclusive, Asia/Kolkata)
- Ranking metric: **total DB time = mean_exec_time × calls**, tie-break by users impacted
- Top N: **20** (there must be MORE than 20 raw rows so grouping/top-N is a real step)
- Google Drive folder for all mock sheets + the tracker: **Engineering / DB Performance**
- Microsoft Teams: team **Workflow test**, channel **cross check query origin**
- Team ownership via a **CODEOWNERS** file in each repo mapping paths → teams: `orders-team`,
  `payments-team`, `auth-team`, `search-team`, `platform-team`

## The query catalog — the shared spine (enforce exactly)

Every row below must exist **three times, consistently**: (a) as rows in the Postgres mock sheet
(with a stable `queryid` hash), (b) as real code at the stated file/method in the stated repo, and
(c) as an API route in the monitoring mock sheet. Use the same `queryid` in all three so the
workflow can join them. Q11 and Q12 are **deliberately not traceable** — no matching code — to
exercise the "Not Traceable" path.

| id | Group name | Subfolder / language | File → method (must exist, findable line) | API route | Frontend screen | Root cause | Priority |
|----|-----------|----------------------|-------------------------------------------|-----------|-----------------|-----------|----------|
| Q1 | Order Create Inventory Check | api-node/ (TypeORM) | `api-node/src/inventory/InventoryRepository.ts` → `checkStockForOrder()` | POST /orders/create | Checkout (web-storefront/) | N+1 — one query per line item | Critical |
| Q2 | Checkout Payment Method Lookup | api-node/ (Prisma) | `api-node/src/payments/PaymentRepository.ts` → `findPaymentMethods()` | POST /checkout/payment | Checkout | Missing index → seq scan on `payments(user_id)` | Critical |
| Q3 | Auth User Lookup | api-node/ (raw `db.query`) | `api-node/src/auth/UserRepository.ts` → `findUserByEmail()` | POST /auth/login | Login | Missing index on `users(lower(email))` | Critical |
| Q4 | Product Search | api-node/ (Knex) | `api-node/src/catalog/ProductRepository.ts` → `searchProducts()` | GET /products/search | Search | Full scan + `ILIKE`, missing pagination (~150k rows) | High |
| Q5 | Order History | api-node/ (TypeORM) | `api-node/src/orders/OrderRepository.ts` → `listOrdersForUser()` | GET /orders | Account › Orders | Expensive nested join | High |
| Q6 | Cart Recalculation | supabase-functions/ | `supabase-functions/functions/recalc-cart/index.ts` (RPC `recalc_cart`) | POST /cart/recalc | Cart | RPC loads whole rows it doesn't need | High |
| Q7 | Daily Revenue Report | workers-python/ (SQLAlchemy) | `workers-python/workers/reports/revenue_report.py` → `build_daily_revenue()` | cron job | Admin › Revenue (admin-panel/) | Full-scan aggregate, no partition | Medium |
| Q8 | Inventory Sync | workers-python/ (psycopg) | `workers-python/workers/sync/inventory_sync.py` → `run()` | background job | (none) | Lock wait / competing updates | Medium |
| Q9 | Admin User Export | api-node/ | `api-node/src/admin/AdminUserController.ts` → `exportUsers()` | GET /admin/users/export | Admin › Users | Missing pagination, `SELECT *` | Low |
| Q10 | Category Tree | api-node/ (TypeORM) | `api-node/src/catalog/CategoryRepository.ts` → `getTree()` | GET /categories | Storefront nav | Unoptimized recursive CTE | Medium |
| Q11 | Session Cleanup | (none — ad-hoc cron not in any tracked repo) | — | — | — | — | NOT TRACEABLE |
| Q12 | Ad-hoc Analytics | (none — run from a psql console) | — | — | — | — | NOT TRACEABLE |

## What to create

### A) GitHub monorepo `keyurempiricinfotech-art/db-performance` (real code, coherent but compact)
Everything goes in ONE repo, each service in its own top-level subfolder. Add a single root
`CODEOWNERS` mapping subfolders/paths → teams, and a root `README.md` explaining the layout.
- **`api-node/`** (Node + TypeScript). Layered: `Controllers → Services → Repositories → routes`.
  Include the Q1–Q5, Q9, Q10 methods above at real, findable lines, each firing SQL that matches
  its Postgres row. Mix the ORMs as noted (TypeORM, Prisma, Knex, raw `db.query`). Include a small
  GraphQL server entry. Add `routes` wiring the API paths. Add `migrations/` or `schema.sql` for
  tables `users, orders, order_items, payments, products, categories, carts, inventory, sessions`
  **deliberately missing** the indexes the fixes would add (so the seq scans are real).
- **`workers-python/`** (Python). Q7 via SQLAlchemy, Q8 via psycopg. Realistic worker/cron layout.
- **`supabase-functions/`** (Supabase edge functions + SQL). Q6 as an edge function + `recalc_cart`
  SQL RPC.
- **`web-storefront/`** (React/Next.js). Screens that call the endpoints: Checkout → POST
  /orders/create and POST /checkout/payment, Login → POST /auth/login, Search → GET /products/search,
  Cart → POST /cart/recalc, Account/Orders → GET /orders. Real fetch/api-client calls so the
  frontend-consumer tracing works.
- **`admin-panel/`** (React). Revenue dashboard screen and a Users-export screen calling the admin
  endpoints (Q7 view, Q9).

### B) Google Sheet — "Postgres Slow Queries Data" (in the Drive folder)
- **Tab `pg_stat_statements`** — 30–40 rows so top-20-after-grouping is a real selection. Columns:
  `queryid, query, calls, total_exec_time_ms, mean_exec_time_ms, min_exec_time_ms, max_exec_time_ms,
  stddev_ms, rows, shared_blks_hit, shared_blks_read, last_seen, datname, usename`. Include the 12
  catalog groups (use the Q-id as/with the `queryid`), plus near-duplicate rows that differ only by
  literal values (e.g. `user_id=9812` vs `user_id=4471`) so SQL normalization + grouping is
  exercised. Make the Critical ones (Q1–Q3) exceed ~5s mean; spread the rest across durations.
- **Tab `slow_query_log`** — 20–30 raw log lines with `log_time, duration_ms, usename, datname,
  query` (query still has literal values), plus occasional lock-wait / plan notes for Q8.

### C) Google Sheet — "Monitoring & Traces Data" (in the Drive folder)
- **Tab `api_latency`** (stands in for Datadog / New Relic / Grafana) — one row per API route in the
  catalog. Columns: `route, method, service, p50_ms, p95_ms, p99_ms, requests_per_hour,
  unique_users_per_day, error_rate, peak_hour_multiplier, mobile_pct, avg_latency_added_ms,
  touches_checkout_or_payment`. Checkout/payment/auth routes get high traffic + revenue flag.
- **Tab `traces`** (stands in for OpenTelemetry/Jaeger) — ~10 rows linking a route to a query:
  `trace_id, root_route, span_service, span_repository, db_queryid, duration_ms`. Cover the critical
  and high queries so the API→query chain can be corroborated.

### D) Google Sheet — "Database Query Performance Tracker" (in the Drive folder)
Create it with the exact header columns the workflow expects: `Query ID, Query Hash, SQL Summary,
Repository, Service, API Endpoint, Frontend Screen, Source File, Line Number, Avg Execution Time,
Max Execution Time, Calls/Day, Users Impacted, Root Cause, Recommended Fix, Priority, Jira Ticket,
Status, Owner, Last Reviewed`. Add **2–3 rows from a pretended previous run** (older `Last Reviewed`
dates, Status = Done/In Progress) so the workflow's "update in place, don't start fresh" behavior can
be tested. Do NOT fill in this run's results — that's the workflow's output.

### E) Jira — project `DBP` (DB Performance)
Ensure the project exists with **components** `orders-team, payments-team, auth-team, search-team,
platform-team` (so tickets can be assigned by code ownership). Do **not** create any optimization
tickets — those are the workflow's output.

### F) Microsoft Teams
Confirm team **Workflow test** / channel **cross check query origin** exist. Do not post — the summary is
the workflow's output.

## Consistency rules (verify all before reporting done)
1. Every catalog query (Q1–Q10) resolves to a **real method at a findable file+line** in the stated
   repo, firing SQL that matches its `pg_stat_statements` row; Q11/Q12 have **no** matching code.
2. Multi-language coverage is real: Node (Q1–Q5, Q9, Q10), Python (Q7, Q8), Supabase (Q6).
3. The DB schema is **missing** the indexes the fixes would add, so the seq-scan / full-scan root
   causes are genuine.
4. `api_latency` routes and `traces` match the catalog routes; checkout/payment/auth are flagged
   revenue-touching and high-traffic so the Critical bucket is populated.
5. Frontend repos actually call the endpoints, so screen tracing (Checkout, Search, Login, Cart)
   works.
6. More than 20 raw query rows exist, including near-duplicates differing only by literals, so
   normalization + grouping + top-20 selection is a real step.

## When done — report back (so the workflow prompt can be filled to match)
List: the exact **monorepo full name + default branch** and confirm the five subfolders exist, the
**URL of each of the three Google Sheets** (Slow Queries, Monitoring & Traces, and the Tracker), the
**Jira project key + component names**, and confirmation the **Teams team/channel** exist. If any of
Jira components / the Teams team could not be created or seen, say so explicitly. Finish with a one-paragraph
note confirming the six consistency rules hold (especially that Q11/Q12 are untraceable and the
indexes are absent). Do not create any local files.
