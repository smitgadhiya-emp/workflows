[repo]	sahidempiricinfotech-dotcom/cors-audit (branch main)
[folders in scope]	services/ (Express), web/ (Next.js), infra/nginx/ (Nginx)
[request-log sheet]	"CORS Request Logs", Requests tab (Drive folder: Engineering / CORS Audit)
[audit sheet]	"CORS Effective Policy Audit" (Drive folder: Engineering / CORS Audit)
[Linear team]	CORS
[team name] > [channel name]	Workflow test > cors audit
[exact start date]	2026-06-15
[exact end date]	2026-07-14
[timezone]	Asia/Kolkata (IST)
[issue threshold]	exposure score 45 or more (make easy to change)
[fallback owner team]	platform
[CODEOWNERS/team ownership source]	CODEOWNERS at repo root (teams: express/users/web/infra; platform = fall-through). Assign by the source path of the layer that introduced the WORST gap, last-wins precedence.
[request order]	Nginx (front) -> app (Express cors()/handler or Next.js config/middleware/handler)

Mock-source note:
Production HTTP request + origin data -> "CORS Request Logs" Google Sheet (Requests tab), in the Drive
folder Engineering / CORS Audit. The workflow reads that instead of live web-server or CDN logs -
those can't have data injected. The CORS config comes from the GitHub repo itself. Join logs to routes
on route path + method (byte-for-byte).

Scoring (max 90, not 100 - a route can't hold two policy-risk tiers):
- Policy risk: 45 wildcard+auth/credentialed, 35 wildcard non-auth (in logs), 25 split-config override,
  15 dead-entry widening, 10 preflight mismatch on its own. (Silently-blocked origin = 0 policy risk.)
- Data exposure: 25 user/auth/payment, 15 business logic, 5 public/static (from real handler code).
- Reach: 20 for >=3 distinct origins, 12 for 1-2, 5 for no log rows (traffic-unknown, not dropped).
- Tie-break: higher policy risk, then higher traffic count, then route path+method A-Z.

Expected ranking spine (for review, NOT an answer key to paste): R01 & R07 = 90 (R01 first on traffic),
R04 = 82, R12 = 75, R08 = 70, R05 & R03 = 60 (R05 first on policy risk), R09 = 52, R11 & R02 = 47
(R11 first on traffic), R14(clean) & R06(gap) = 45, R13(unresolved) & R10(clean) = 17. Issues (gap +
>=45): 11 routes (R01-R09 except R10, plus R11, R12). R14 clean-at-45 and R06 zero-policy-risk-at-45
are the two edges - see Manual-Setup-239.md.

Seeded state the workflow must reconcile with (not workflow output):
- Linear CORS: 2 open issues ("CORS gap on POST /api/orders", "CORS gap on POST /api/checkout") -> must
  be UPDATED, not duplicated. 1 closed issue ("CORS gap on GET /api/products") -> closed is not open,
  so a NEW issue is correct here.
- Audit sheet: 4 prior rows keyed on route+method. POST /api/orders (owner=infra-team, status=In
  Progress) and GET /api/products (owner=web-team, status=Accepted Risk) have human-set columns that
  must survive the upsert. POST /api/login is a clean prior row. DELETE /api/legacy-webhook points at a
  route that no longer exists -> mark Resolved with the run date, not deleted.

Verify-after-Codex note:
Repo/sheet names above are what the seed prompt instructs. If Codex creates anything under a different
account or name, replace the values here and in Prompt-239.md with the exact names Codex reports, plus
the real Sheet URLs. The logs join on route path + method, so a path that drifts between the repo and
the sheet silently drops a route to traffic-unknown and changes its reach + tie-break.
