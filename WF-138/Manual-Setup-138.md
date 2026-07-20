# WF-138 — Manual Setup (do these yourself, before anything runs)

Things Codex can't bootstrap on its own (OAuth logins, Jira project/admin config, GitHub org, Teams
creation). Do these first, then run the Codex seed prompt, then fill the workflow prompt with the
exact names Codex reports, then run the workflow.

## Current status (as of last seed run)
- ✅ **GitHub** — monorepo `keyurempiricinfotech-art/db-performance` populated on `main`; Q1–Q10
  verified; old `acme-commerce` fallback repo cleaned; tracker Repository column repointed.
- ✅ **Google Sheets** — Slow Queries, Monitoring & Traces, and Tracker all created and verified.
- ✅ **Jira** — project DBP + the 5 team components (orders/payments/auth/search/platform) created
  manually. CODEOWNERS decides which team owns a file; the workflow records it on the ticket's
  Component field. (Dedup step relies on JQL search working.)
- ⚠️ **Microsoft Teams** — BLOCKER. Team `Workflow test` not visible to the connected account; channel
  `cross check query origin` not created. Fix before running.
- ▢ **GitHub default branch** — confirm `main` is the repo's default (not an empty `develop`).

## 1. Connect / authenticate the plugins in Codex
Codex can't self-authorize OAuth. Sign in to the connectors it will actually use:
- [ ] **GitHub** (with permission to create repos under the target org)
- [ ] **Jira**
- [ ] **Google Drive / Sheets**
- [ ] **Microsoft Teams**

> You do NOT need to connect PostgreSQL, Datadog, New Relic, Grafana, or a tracing tool. Those can't
> have data injected, so they're mocked as Google Sheets (see the seed prompt). The *workflow* run
> also reads them from those Sheets, not the live products.

## 2. Jira — project + components ✅ DONE
- [x] Project **DBP** (DB Performance) exists.
- [x] The 5 team components created manually: `orders-team`, `payments-team`, `auth-team`,
      `search-team`, `platform-team`. CODEOWNERS decides which team owns a file; the workflow records
      it on the ticket's **Component** field.
- [ ] Confirm the connector can **run a JQL search** on DBP so the "update-not-duplicate" idempotency
      step can find existing tickets. Status set **To Do / In Progress / In Review / Done** is fine.

## 3. GitHub — one monorepo ✅ DONE
- [x] Seed code lives in **keyurempiricinfotech-art/db-performance**, branch **main**, subfolders
      `api-node/`, `workers-python/`, `supabase-functions/`, `web-storefront/`, `admin-panel/`.
      Q1–Q10 trace files + line numbers verified; old `acme-commerce` fallback repo cleaned.
- [ ] Confirm **`main` is the repo's default branch** (Repo settings → Branches) so repo searches
      don't hit an empty branch.

## 4. Microsoft Teams — team + channel must exist
- [ ] Confirm team **Workflow test** exists (reuse from WF-092/109) and the channel
      **cross check query origin** exists under it — create the channel if it isn't there yet.

## 5. Google Drive — folder for the mock sheets + tracker
- [ ] Create the folder **Engineering / DB Performance**. Codex puts the three Sheets there (Slow
      Queries, Monitoring & Traces, and the Database Query Performance Tracker). Leave the tracker's
      current-run rows empty — that's the workflow's output.

---

## After Codex runs — wire the real names into the workflow prompt (don't skip this)
This is the WF-109 lesson: the workflow prompt must point at what actually got created.
Collect from Codex's report and fill `prompt-138.md`:
- [ ] `[backend repo list]` → the real `api-node`, `workers-python`, `supabase-functions` full names
- [ ] `[frontend repo list]` → the real `web-storefront`, `admin-panel` full names
- [ ] `[project name/ref]` (Supabase) → `acme-storefront` / `acmestorefront`
- [ ] `[cluster/account]`, `[database name]`, `[environment]` → `acme-prod-pg`, `acme_production`,
      `production`
- [ ] `[project key]` → `DBP`
- [ ] `[Datadog account/dashboard]`, `[New Relic account]`, `[Grafana folder/dashboard]`,
      `[trace source]` → point all of these at the **"Monitoring & Traces Data"** Sheet URL
- [ ] `[Google Sheet sheet URL]` → the **Database Query Performance Tracker** URL
- [ ] `[team name] > [channel name]` → `Workflow test` > `cross check query origin`
- [ ] `[ranking metric]` → total DB time (mean_exec_time × calls), tie-break users impacted
- [ ] `[exact start date]` / `[exact end date]` → `2026-06-06` / `2026-07-05`
- [ ] `[CODEOWNERS/team ownership source]` → the `CODEOWNERS` files in the repos
- [ ] Add a source-pointer note (like WF-092 had): *"Postgres pg_stat_statements/slow-query data and
      the Datadog/New Relic/Grafana/trace data are provided as the two Google Sheets in the
      Engineering / DB Performance folder — read those instead of the live products."*

## Verify the seed before the real run (after the supplement too)
- [ ] Monorepo has all 5 subfolders on `main`; Q1–Q10 **plus the new Q13–Q26 traced methods** exist
      at real lines; Q11/Q12/Q27/Q28 have no code.
- [ ] Slow-query Sheet now has **≥28 distinct fingerprints** with a real top-20 cut and near-ties at
      ranks 18–22; fold variants (`$1` / `= ANY` / IN-lists / VALUES / mixed case) share one Query ID.
- [ ] Monitoring Sheet: routes match the catalog; checkout/payment/auth flagged revenue; background/
      cron groups (Q8/Q20/Q22) and Q27/Q28 have **no** row (impact-unknown); traces carry the
      parent-request-count vs child-call-count columns for the N+1 groups.
- [ ] `findUserByEmail` (Q3) has **4 real call sites** across api-node / workers-python / supabase.
- [ ] Root `CODEOWNERS` has default `* @platform-team` + a last-wins overlap + one fall-through path.
- [ ] Tracker has headers + prior rows keyed to Q1/Q2/Q7 with **human Owner/Status set**; no
      current-run rows.
- [ ] **Two** prior open DBP tickets exist for Q1/Q2 (idempotency); no other optimization tickets.
- [ ] Jira DBP project + 5 team components exist (done); CODEOWNERS team names match the components.
- [ ] Sheets named exactly: **Postgres Slow Queries Data**, **Monitoring & Traces Data**, **Database
      Query Performance Tracker** (rename the monitoring sheet if it's still "WF-138 Monitoring & Traces").

## What you do NOT set up (the workflow produces these)
- The per-optimization Jira tickets
- The current-run rows in the Database Query Performance Tracker
- The Teams engineering summary
