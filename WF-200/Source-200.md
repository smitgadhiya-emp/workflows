[repo]	sahidempiricinfotech-dotcom/next-action-audit (branch main)
[folders in scope]	app/, src/actions/, src/components/, src/lib/
[traffic sheet]	"Action Traffic Data" (Drive folder: Engineering / Server Action Audit)
[tracker sheet]	"Server Action Auth Coverage Matrix" (Drive folder: Engineering / Server Action Audit)
[Jira project key]	SAA (Server Action Audit)
[team name] > [channel name]	Workflow test > server action audit
[exact start date]	2026-06-15
[exact end date]	2026-07-14
[timezone]	Asia/Kolkata (IST)
[ticket threshold]	45 or more (make easy to change)
[fallback owner team]	platform
[CODEOWNERS/team ownership source]	CODEOWNERS at repo root (teams: web/admin/app/payments/auth; platform = fall-through)
[Jira components]	web-team, admin-team, app-team, payments-team, auth-team, platform-team
[stack]	Next.js 14 App Router, TypeScript, next-auth (getServerSession), Prisma

Mock-source note:
Invocation traffic and caller exposure data → "Action Traffic Data" Google Sheet
(tabs: invocations, callers), in the Drive folder Engineering / Server Action Audit. The workflow
reads that instead of live Vercel logs or APM — those can't have data injected. The Next.js source
comes from the GitHub repo itself.

Seeded state the workflow must reconcile with (not workflow output):
- Jira SAA: 2 open tickets (updateBillingProfile @ src/actions/billing.ts, resetPasswordForUser @
  src/actions/auth.ts) → must be UPDATED, not duplicated. 1 closed ticket (exportOrdersCsv @
  src/actions/orders.ts) → closed is not open, so a NEW ticket is correct here.
- Matrix sheet: 4 prior rows. updateBillingProfile (owner=payments-team, status=In Progress) and
  cancelOrder (owner=orders-team, status=Accepted Risk) have human-set columns that must survive the
  upsert. getBillingProfile is a clean guarded row. deleteLegacyWebhook @ src/actions/webhooks.ts
  points at code that no longer exists → must be marked Resolved with the run date, not deleted.

Verify-after-Codex note:
Repo/sheet names above are what the seed prompt instructs. If Codex creates anything under a
different account or name (as happened on WF-109), replace the values here and in Prompt-200.md with
the exact names Codex reports, plus the real Sheet URLs. The traffic sheet joins on action name +
file path, so a path that drifts between the repo and the sheet silently drops an action to
traffic-unknown.
