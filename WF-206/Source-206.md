[repo]	sahidempiricinfotech-dotcom/express-input-audit (branch main)
[folders in scope]	services/api-gateway/, services/orders-api/, services/uploads-api/, services/admin-api/, shared/middleware/
[traffic sheet]	"Route Traffic Data" (Drive folder: Engineering / Input Validation)
[tracker sheet]	"Input Validation Coverage Map" (Drive folder: Engineering / Input Validation)
[Jira project key]	IVA (Input Validation Audit)
[team name] > [channel name]	Workflow test > input validation audit
[exact start date]	2026-06-15
[exact end date]	2026-07-14
[timezone]	Asia/Kolkata (IST)
[ticket threshold]	route top score 40 or more (make easy to change)
[ticket granularity]	one per route, not per field
[fallback owner team]	platform
[CODEOWNERS/team ownership source]	CODEOWNERS at repo root (teams: gateway/orders/orders-web/orders-routes/uploads/admin; platform = fall-through)
[Jira components]	gateway-team, orders-team, orders-web-team, orders-routes-team, uploads-team, admin-team, platform-team
[OWASP set]	A01, A03, A04, A05, A08 (2021)
[stack]	Node + Express 4, CommonJS. Validation mix: express-validator, Joi, Zod, celebrate, multer, none.

Mock-source note:
Route traffic, exposure and auth data → "Route Traffic Data" Google Sheet (tab: routes), in the
Drive folder Engineering / Input Validation. The workflow reads that instead of live gateway logs or
APM — those can't have data injected. The Express source comes from the GitHub repo itself.
The sheet's auth column is the ONLY source for the reachability score; join on method + mounted path.

Seeded state the workflow must reconcile with (not workflow output):
- Jira IVA: 2 open tickets ("Unvalidated input in POST /api/v1/uploads/document", "Unvalidated input
  in POST /api/v1/orders/create") -> must be UPDATED, not duplicated. 1 closed ticket ("Unvalidated
  input in GET /api/v1/search") -> closed is not open, so a NEW ticket is correct here.
- Coverage map: 4 prior rows, keyed on method + mounted path + field path. POST /api/v1/uploads/document
  + file.originalname (owner=uploads-team, status=In Progress) and POST /api/v1/orders/create +
  body.couponCode (owner=orders-team, status=Accepted Risk) have human-set columns that must survive
  the upsert. GET /api/v1/orders/:orderId + params.orderId is a clean validated row. POST
  /api/v1/legacy/checkout + body.cardToken points at a route that no longer exists -> must be marked
  Resolved with the run date, not deleted.

Known prompt gaps (see Manual-Setup-206.md for suggested wording):
- DELETE /api/v1/admin/cache is seeded with no traffic row, so it has no auth value either. Line 13
  sources reachability from the sheet's auth column but doesn't say what to do when the row is absent.
  Decide: infer auth from the resolved middleware chain (requireAdmin -> admin), or mark Unresolved.
- Traffic rows are daily. Line 13 doesn't say to average requests_per_hour across the window.

Verify-after-Codex note:
Repo/sheet names above are what the seed prompt instructs. If Codex creates anything under a different
account or name (as happened on WF-109), replace the values here and in Prompt-206.md with the exact
names Codex reports, plus the real Sheet URLs. The traffic sheet joins on method + MOUNTED path (the
gateway's path, not the router file's), so a mount that drifts silently drops a route to
traffic-unknown and changes its score.
