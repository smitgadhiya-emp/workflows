[backend repo list]	keyurempiricinfotech-art/db-performance (branch main) — subfolders api-node/, workers-python/, supabase-functions/
[frontend repo list]	keyurempiricinfotech-art/db-performance (branch main) — subfolders web-storefront/, admin-panel/
[project name/ref] (Supabase)	acme-storefront (ref acmestorefront)
[cluster/account] (Postgres)	acme-prod-pg
[database name]	acme_production
[environment]	production
[project key] (Jira)	DBP (DB Performance)
[Datadog account/dashboard]	"WF-138 Monitoring & Traces" Google Sheet (mock — stands in for Datadog)
[New Relic account]	"WF-138 Monitoring & Traces" Google Sheet (mock — stands in for New Relic)
[Grafana folder/dashboard]	"WF-138 Monitoring & Traces" Google Sheet (mock — stands in for Grafana)
[trace source]	traces tab of "WF-138 Monitoring & Traces" Google Sheet (mock — stands in for OpenTelemetry/Jaeger)
[Google Sheet sheet URL]	"Database Query Performance Tracker" (Drive folder: Engineering / DB Performance)
[team name] > [channel name]	Workflow test > cross check query
[ranking metric]	total DB time (mean_exec_time × calls), tie-break by users impacted
[exact start date]	2026-06-06
[exact end date]	2026-07-05
[CODEOWNERS/team ownership source]	CODEOWNERS files in the repos (teams: orders/payments/auth/search/platform)
[top N]	20 (make easy to change)

Mock-source note:
Postgres pg_stat_statements/slow-query data → "WF-138 Postgres Slow Queries" Google Sheet.
Datadog/New Relic/Grafana + traces → "WF-138 Monitoring & Traces" Google Sheet.
Both live in the Drive folder Engineering / DB Performance. The workflow reads these instead of the
live products (they can't have data injected).

Verify-after-Codex note:
Repo names above assume org acme-commerce. If Codex creates the repos under a different account
(as happened on WF-109), replace the repo full names here and in prompt-138.md with the exact names
Codex reports, plus the real Sheet URLs.
