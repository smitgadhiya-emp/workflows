# Codex Prompt — WF-138 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-138 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-138 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

> Channel note: the prompt posts to **Workflow test > `cross check query origin`**. (`Source-138.md`
> abbreviates it as "cross check query" — same channel; match the real one.)

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-138 slow-query tracing run. Delete **only what the run produced**. The
seed data must survive untouched — it is expensive to rebuild and the next run depends on it.

### Do NOT touch (this is the seed)
- The GitHub monorepo **keyurempiricinfotech-art/db-performance** (branch `main`) — nothing at all, in
  any branch. The run only *reads* the repo; if you find changes there, **stop and report it** rather
  than reverting. The Q1–Q28 code across `api-node/` / `workers-python/` / `supabase-functions/` /
  `web-storefront/` / `admin-panel/`, the **deliberately-missing indexes**, the R13-style unresolvable
  bits, the `CODEOWNERS` last-wins overlap + fall-through, and the untraceable Q27/Q28 (no code) are
  all seed. Leave every one of them; do **not** "fix" a query or add an index.
- The Google Sheets **Postgres Slow Queries Data** and **Monitoring & Traces Data** (Drive folder
  **Engineering / DB Performance**) — leave every tab and row alone (the ≥28 fingerprints, the
  fold-variant rows, the N+1 trace correlations, the impact-unknown gaps). The run only reads them.
- The **Jira project `DBP` itself**, its **5 components** (`orders-team`, `payments-team`, `auth-team`,
  `search-team`, `platform-team`), and the **2 seeded prior tickets**:
  - `Optimize slow query in InventoryRepository.checkStockForOrder()` (**Q1**, status **In Progress**)
  - the seeded **Q2** optimization ticket (status **Open/To Do**)
- The Teams team **Workflow test** and the channel **cross check query origin** themselves.
- The Drive folder **Engineering / DB Performance**.

### 1) Jira — project `DBP`, delete only the run's new tickets
- The run opens one optimization ticket per traced top-20 query group and **upserts** the two seeded
  ones (Q1, Q2) rather than duplicating.
- **Delete (or archive) every DBP optimization ticket except the two seeded ones (Q1, Q2).** Match the
  two seeded by their exact summary — or by issue key if you recorded it when seeding, which is safer.
  (Each seeded ticket carries its Query ID + query hash in the description; use that to confirm.)
- The run will have **updated Q1 and Q2 in place** (refreshed the numbers, file/line, root cause, fix,
  priority, monitoring links, added a comment). **Restore them to their seeded stale state**: original
  description body (Query ID + hash preserved), **Q1 back to In Progress**, **Q2 back to Open/To Do**,
  unassigned, and remove any comment/label/link the run added. Do not delete these two.
- Leave the **5 components** exactly as they are.
- **Before deleting anything, list what you are about to delete and what you are keeping**, and confirm
  the survivor count is exactly **2** optimization tickets (plus the components).

### 2) Google Sheet — "Database Query Performance Tracker"
- Keep the header row (all columns: query ID, hash, SQL summary, repository, service, API endpoint,
  frontend screen, source file, line number, avg/max exec time, calls/day, users impacted, root cause,
  recommended fix, priority, Jira ticket, status, owner, last reviewed) exactly as-is.
- **Delete every data row except the 3 seeded prior rows**, keyed on **Query ID**: **Q1**, **Q2**,
  **Q7**. (The run adds a row per traced top-20 group and a "Not Traceable" row for Q12/Q27/Q28 — delete
  all of those.)
- The run **upserted** the 3 prior rows, so restore their seeded values:
  - Put the **human-managed columns back**: `owner` and `status` to their seeded values (e.g. owner
    `payments-team`, status `In Progress`) — the whole point of the seed is that the upsert must
    refresh metrics/fix/priority/Jira-link but **not** overwrite owner/status, so undo any change the
    run made to those two, and set `last reviewed` back to its older seeded date.
  - Clear the metric/analysis columns the run refreshed on these 3 rows back to their seeded stale
    values (avg/max exec time, calls/day, users impacted, root cause, recommended fix, priority, Jira
    ticket link).
- Do not delete the sheet and recreate it — the URL is wired into the workflow prompt.

### 3) Microsoft Teams — `Workflow test` > `cross check query origin`
- Delete the engineering summary the run posted (total slow queries, per-priority counts, top impacted
  APIs, top root causes, tickets created vs updated, tracker rows upserted, owners notified, tracker
  link), plus any follow-ups or thread replies under it.
- Leave the channel itself in place.

### 4) Report back
State exactly: how many DBP tickets you deleted and that exactly **2** survive (Q1 back to In Progress,
Q2 back to Open, both stale) with the 5 components intact; how many tracker rows you deleted and that
the **3** seeded rows (Q1/Q2/Q7) are restored — human `owner`/`status` preserved, metrics reverted;
that the repo and both mock Sheets were not modified; and whether the Teams summary was found and
deleted. If the run left anything you couldn't classify as seed-or-output, **name it and leave it
alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-138)

Delete everything WF-138 created, seed included. This is destructive and there is no undo — the
monorepo, the sheets, and the Jira state take a full seed run to rebuild. Confirm that's what you want
before running it.

1. **GitHub** — delete the repo **keyurempiricinfotech-art/db-performance** entirely.
2. **Google Drive** — delete the tracker (**Database Query Performance Tracker**) and both mock Sheets
   (**Postgres Slow Queries Data**, **Monitoring & Traces Data**), then the folder **Engineering / DB
   Performance** if it is now empty. If the folder holds anything you didn't create, leave the folder
   and say what's in it.
3. **Jira** — delete/archive every issue in the **DBP** project (the 2 seeded tickets + every run
   ticket), then the components and the project itself. If deleting the project needs admin rights you
   don't have, clear all the issues and say so.
4. **Teams** — delete every message in **Workflow test** > **cross check query origin**, then the
   channel. **Leave the team `Workflow test` itself** — it is shared with many other workflows
   (WF-052 / WF-092 / WF-109 / WF-236 / WF-239 / WF-297 and more).

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
