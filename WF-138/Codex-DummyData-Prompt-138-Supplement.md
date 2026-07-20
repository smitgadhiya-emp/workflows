# Codex Prompt — WF-138 Dummy Data SUPPLEMENT (harden the seed for the difficult prompt)

Paste below the line into Codex. This **augments the existing WF-138 seed in place** — it does NOT
recreate it. Do NOT write local files. Do NOT run the tracing workflow, create optimization tickets
(except the two "previous-run" ones explicitly called for in §7), post to Teams, or fill the
current run's tracker rows. Keep everything consistent with the existing catalog (Q1–Q12), the
monorepo `keyurempiricinfotech-art/db-performance` (branch `main`), Jira `DBP`, and the Drive folder
`Engineering / DB Performance`.

The workflow was hardened to require reproducible ranking, fingerprint folding, one-to-many code
tracing, N+1 proof, CODEOWNERS precedence, Jira idempotency, and tracker upsert. The current seed
can't exercise those. Add the following.

## §0. Reconcile sheet names (do first)
Make the sheet names exactly match what the workflow reads:
- Slow-query sheet must be named exactly **"Postgres Slow Queries Data"**.
- Monitoring sheet must be named exactly **"Monitoring & Traces Data"** (rename it if it is currently
  "WF-138 Monitoring & Traces").
- Tracker must be exactly **"Database Query Performance Tracker"**.

## §1. Expand to MORE than 20 distinct query groups (so top-20 is a real cut)
Add the groups below to the "Postgres Slow Queries Data" sheet (new `pg_stat_statements` rows, and a
few matching `slow_query_log` lines). Together with Q1–Q12 this makes ~28 distinct fingerprints.
Traceable ones must have **real code** at the stated path in the monorepo; the two untraceable ones
must have **no** code. Set `total_exec_time_ms` (= mean × calls) so that ~20 groups sit clearly
above the cut and ~8 below, and make ranks ~18–22 **near-ties** (differ by <2% total DB time) so the
tie-break chain (users impacted → max duration → query hash) actually decides the order.

| id | Group name | Subfolder → file → method | API route | Screen | Root cause | Priority | Traceable |
|----|-----------|---------------------------|-----------|--------|-----------|----------|-----------|
| Q13 | Cart Item Load | api-node/src/cart/CartRepository.ts → getCartItems() | GET /cart | Cart | N+1 on product join | High | yes |
| Q14 | Product Detail | api-node/src/catalog/ProductRepository.ts → getProductById() | GET /products/:id | Product | missing index on slug, high frequency | High | yes |
| Q15 | Order Status Update | api-node/src/orders/OrderRepository.ts → updateStatus() | POST /orders/:id/status | (internal) | lock wait | Medium | yes |
| Q16 | Wishlist Fetch | api-node/src/wishlist/WishlistRepository.ts → listForUser() | GET /wishlist | Account › Wishlist | missing index | Medium | yes |
| Q17 | Coupon Validation | api-node/src/promo/CouponRepository.ts → validate() | POST /checkout/coupon | Checkout | full scan on coupons + IN list | Critical | yes |
| Q18 | Inventory Availability (GraphQL) | api-node/src/graphql/resolvers/inventory.ts → availability() | GraphQL `availability` | Product | N+1 across variants | High | yes |
| Q19 | Shipment Tracking | api-node/src/shipping/ShipmentRepository.ts → track() | GET /shipments/:id | Orders | expensive join | Medium | yes |
| Q20 | Notification Fanout | workers-python/workers/notify/fanout.py → run() | background job | (none) | duplicate query in loop | Medium | yes |
| Q21 | Search Suggest | api-node/src/catalog/SearchRepository.ts → suggest() | GET /search/suggest | Search | missing trigram index | High | yes |
| Q22 | Payment Reconciliation | workers-python/workers/finance/reconcile.py → reconcile() | cron job | Admin › Finance | full-scan aggregate | Medium | yes |
| Q23 | Audit Log Insert | api-node/src/audit/AuditRepository.ts → write() | (many routes) | — | multi-row VALUES insert, high volume | Low | yes (see §2) |
| Q24 | Session Touch | api-node/src/auth/SessionRepository.ts → touch() | (middleware, many routes) | — | tiny query at very high frequency | High | yes |
| Q25 | Category Products | api-node/src/catalog/CategoryRepository.ts → productsIn() | GET /categories/:id/products | Category | missing pagination | High | yes |
| Q26 | Admin Metrics | api-node/src/admin/MetricsController.ts → summary() | GET /admin/metrics | Admin dashboard | expensive multi-join | Low | yes |
| Q27 | Legacy Report | (decommissioned service — NO code in the repo) | — | — | — | (high DB time) | **NO — must rank in top 20** |
| Q28 | Manual Backfill | (run from a psql console — NO code) | — | — | — | Medium | **NO** |

Make **Q12** (Ad-hoc Analytics) and **Q27** carry high total DB time so at least two **not-traceable**
groups fall inside the top 20 — this forces "Not Traceable" tracker rows in the top 20, not as an
afterthought.

## §2. Fingerprint-folding variants (so normalization is actually tested)
For these groups, add extra raw `pg_stat_statements` / `slow_query_log` rows that look different but
must fold to ONE fingerprint. They should share the same Query ID after normalization:
- **Q3 (User Lookup):** `WHERE email = 'a@b.com'`, `WHERE email = $1`, `where EMAIL = 'c@d.com'`
  (mixed case + whitespace + a `-- comment`).
- **Q4 (Product Search) / Q17 (Coupon):** an `IN (1,2,3)` row and an `IN (1,2,…,40)` row, plus an
  `= ANY($1)` row — all one pattern.
- **Q23 (Audit Insert):** a 1-row `VALUES (...)` and a 50-row `VALUES (...),(...)` insert — one
  pattern.
- At least one already-parameterized (`$1,$2`) row whose literal-filled twin also appears.

## §3. One shared method with MANY origins (multi-origin, fork, multi-route, priority conflict)
Make the **User Lookup by email** fingerprint (Q3) genuinely one-to-many. Add real call sites so the
same normalized query is generated from **4 call sites across 3 services and 2+ routes**:
1. `api-node/src/auth/UserRepository.ts → findUserByEmail()` called by the **auth login** flow →
   POST /auth/login (**critical**).
2. The same repo method called by `api-node/src/admin/AdminUserController.ts → exportUsers()` →
   GET /admin/users/export (**low**).
3. `workers-python/.../user_digest.py` issuing the same shape via SQLAlchemy (background).
4. `supabase-functions/functions/user-sync/index.ts` issuing it via RPC.
This exercises: one-to-many origins, a shared method the call graph forks on, impact attributed
across multiple routes, and the "hits both critical and low → takes the higher (critical)" rule.

## §4. N+1 numeric proof (traces must let the workflow CONFIRM, not guess)
In the "Monitoring & Traces Data" sheet, extend the `traces` tab with columns:
`parent_route, parent_request_count, child_queryid, child_call_count, fanout_ratio`.
For the N+1 / duplicate groups (Q1, Q13, Q18, Q20) add rows where `child_call_count ≈
parent_request_count × fanout_ratio` (e.g., 2,500 orders × ~8 line items ≈ 20,000 child inventory
queries). This is the correlation the prompt demands as evidence.

## §5. CODEOWNERS with precedence + a deliberate fall-through
`db-performance` is a PERSONAL repo, so real GitHub `@org/team` handles don't exist. Use plain
ownership tokens that the workflow reads as the owning-team string (GitHub may flag them "unknown
owner" — fine, the file is still the ownership source of truth). Write the monorepo root `CODEOWNERS`
so that:
- A catch-all default sits first: `* @platform-team` (the "default backend team" the prompt falls
  back to).
- Specific team rules come **after** it (last-match-wins gives them the path): e.g.
  `/api-node/src/payments/** @payments-team`, `/api-node/src/auth/** @auth-team`,
  `/api-node/src/catalog/** @search-team`, `/api-node/src/orders/** @orders-team`, etc.
- Include **two overlapping patterns for the same path** where the later one must win (tests "last
  matching pattern wins").
- Leave **one traced path with no specific rule** — e.g. `/api-node/src/audit/**` (Q23) — so it
  falls through to `* @platform-team` and the workflow must note the fall-through.
- Use the SAME team names as the DBP Jira components — `orders-team`, `payments-team`, `auth-team`,
  `search-team`, `platform-team` — so CODEOWNERS → Jira Component lines up (see §7).

## §6. Impact-unknown coverage
Ensure the background/cron groups (Q8, Q20, Q22) and the untraceable Q27/Q28 have **no row** in the
`api_latency` tab, so the workflow must flag them "impact-unknown / no user-facing trace" while still
ranking them.

## §7. Pre-existing Jira tickets (to test idempotency — update, don't duplicate)
Create **2 open DBP issues** as if from a previous run (the connector can create issues; leave them
unassigned). Each title like "Optimize slow query in InventoryRepository.checkStockForOrder()" and
**put the Query ID and query hash in the description** so the workflow matches on them:
- one for **Q1** (status In Progress), one for **Q2** (status Open).
Do not create tickets for any other query — those are the workflow's output.

Ownership note (aligns with the executed seed): the 5 DBP components — `orders-team`, `payments-team`,
`auth-team`, `search-team`, `platform-team` — were created manually, so the workflow records the
owning team on the ticket's **Component** field, matching the CODEOWNERS team from §5. For the
idempotency step to work, the connector must be able to run a **JQL search** on DBP so "update instead
of duplicate" can find the existing ticket.

## §8. Tracker prior rows with human-managed Owner/Status
In the "Database Query Performance Tracker", make sure the prior-run rows are keyed to real Query IDs
(Q1, Q2, Q7) and have **Owner and Status filled in** (as if a human set them, e.g. Owner =
payments-team, Status = In Progress) with older `Last Reviewed` dates. This tests the rule that the
upsert must refresh metrics/fix/priority/Jira link but **not overwrite** Owner or Status.

## Consistency + report back
Verify: ≥28 distinct fingerprints with a real, deterministic top-20 cut and near-ties at 18–22; the
fold variants share one Query ID each; the Q3 shared method has 4 real call sites; the traces prove
the N+1s numerically; CODEOWNERS has a default + last-wins overlap + one fall-through path; Q27/Q28
(and Q12) are untraceable with at least two of them inside the top 20; background/cron groups have no
monitoring row; two prior DBP tickets exist for Q1/Q2; tracker prior rows have human Owner/Status.
Report the sheet URLs (confirm the renamed monitoring sheet), the new file paths added to the
monorepo, and the two Jira issue keys. No local files.
