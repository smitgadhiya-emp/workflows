# Codex Prompt — WF-052 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-052 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-052 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-052 API technical-debt audit run. Delete **only what the run produced**.
The seed data must survive untouched — it is expensive to rebuild and the next run depends on it.

### Do NOT touch (this is the seed)
- The GitHub repo **keyurempiricinfotech-art/test-repo** — nothing at all, in any branch. The run only
  *reads* the repo; if you find changes there, **stop and report it** rather than reverting. The
  deliberate fixtures — the orphaned endpoints (`DELETE /api/v1/wishlist/{id}`, `POST /webhooks/legacy-
  shipping`, GraphQL `legacyInventory`), the zero-traffic-but-live `GET /api/v1/legacy/export`, the
  `@deprecated` markers, the dynamic-string coupon call, and the config-flag-gated `applyPromo` — are
  all seed. Leave every one of them exactly as it is; do **not** "clean up" any endpoint.
- The Google Sheet **mock api data** — leave every row alone (real traffic, synthetic rows, the
  ambiguous `acme-status-checker`, the unattributed-version `/orders/{id}/invoice` rows, and the
  out-of-window rows). The run only reads it.
- The **Jira project `api-reporting` itself** and its **one seeded dedup fixture issue**:
  `Deprecate DELETE /api/v1/wishlist/{id}`.
- The Teams team **Workflow test** and the channel **Workflow test** themselves.
- The Drive folder **Engineering / API Lifecycle**.

### 1) Google Sheet — "api workflow test" (Lifecycle Tracker)
Keep the header row (all 12 columns) exactly as-is. The run **upserted** the tracker: it filled the
seeded rows and added a row for every endpoint that had no existing row. Undo both.

- **Delete every data row except the 7 seeded baseline rows**, keyed on **route + method + version**:
  1. `POST` / `/api/v1/auth/login` / v1
  2. `GET` / `/api/v2/products` / v2
  3. `GET` / `/api/v1/products` / v1
  4. `GET` / `/api/v1/recommendations` / v1
  5. `POST` / `/internal/reindex` / (—)
  6. `POST` / `/webhooks/stripe` / (—)
  7. `products` (GraphQL) / QUERY / (—)
  (There will be ~9 more rows the run added — endpoints 5, 6, 7, 8, 10, 11, 13, 15, 16. Delete those.)
- **Restore those 7 rows to their seeded baseline state:**
  - `Status` back to **Active** on all 7 (the run will have changed some to Candidate for Deprecation /
    Pending Review / Approved for Removal).
  - `Owner` back to the seeded values: **Platform Team** (auth/login), **Catalog Team** (v2 products
    and GraphQL `products`), **Growth Team** (recommendations), **Payments Team** (webhooks/stripe),
    and **blank** on `/api/v1/products` and `/internal/reindex`. (The run is supposed to leave Owner
    alone, so this is usually already correct — confirm it and fix any drift.)
  - **Clear the columns the run filled** on these 7 rows, back to blank: Last Prod Call, Total Requests
    (60d), Unique Clients, Removal Risk, Debt Score, Recommended Action.
- Do not delete the sheet and recreate it — the URL is wired into the workflow prompt.

### 2) Jira — project `api-reporting`
- The run opens one deprecation issue per **Candidate for Deprecation** endpoint. **Delete (or archive)
  every issue in `api-reporting` except the one seeded fixture** `Deprecate DELETE /api/v1/wishlist/{id}`.
  Match the fixture by its exact summary — or by issue key if you recorded it when seeding, which is
  safer.
- The run's dedup step may have **updated the fixture in place** (refreshed the body, added the usage/
  dependency analysis, a comment, or a link). **Restore it to its seeded stale state**: original short
  candidate-for-deprecation body, labels `technical-debt` / `api-cleanup` / `deprecation`, **unassigned**,
  status back to **To Do / Open**. Do not delete the fixture.
- **Before deleting anything, list what you are about to delete and what you are keeping**, and confirm
  the count of survivors is exactly 1.

### 3) Google Sheet — the report
- Delete the report Sheet the run created: title pattern **`API Technical Debt Report <Months-Year>`**
  (for this window it resolves to **`API Technical Debt Report 05-06/2026`**). A wrong-window run may
  have titled it a different month — match on the **`API Technical Debt Report`** prefix and delete any
  such sheet in **Engineering / API Lifecycle**. Do **not** delete `mock api data` or `api workflow
  test`.

### 4) Microsoft Teams — `Workflow test` > `Workflow test`
- Delete the summary message the run posted (total reviewed, safe-removal candidates, needs-review
  count, deprecated-but-still-hit endpoints, oldest unused, estimated debt reduction, Jira issue count,
  report link, and any "Immediate Engineering Review" block). Delete any follow-ups or thread replies
  under it.
- Leave the channel itself in place.

### 5) Report back
State exactly: how many tracker rows you deleted and that the 7 seeded rows are restored to baseline
(Status = Active, seeded Owners incl. the 2 blanks, other columns cleared); how many Jira issues you
deleted and that exactly **1** survives (the wishlist fixture, back to its stale unassigned state); that
the report Sheet was found and deleted; and whether the Teams message was found and deleted. Confirm the
repo and both source Sheets (`mock api data`, `api workflow test` header) were **not** modified beyond
the row cleanup above. If the run left anything you couldn't classify as seed-or-output, **name it and
leave it alone** rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-052)

Delete everything WF-052 created, seed included. This is destructive and there is no undo — the repo,
the sheets, and the Jira state take a full seed run to rebuild. Confirm that's what you want before
running it.

1. **GitHub** — delete the repo **keyurempiricinfotech-art/test-repo** entirely. (Check first that no
   other workflow depends on this monorepo — it is a generic `test-repo` name; if anything else uses it,
   stop and ask.)
2. **Google Drive** — delete the report Sheet (`API Technical Debt Report …`), then both source Sheets
   (**mock api data**, **api workflow test**), then the folder **Engineering / API Lifecycle** if it is
   now empty. If the folder holds anything you didn't create, leave the folder and say what's in it.
3. **Jira** — delete/archive every issue in the **api-reporting** project (the fixture included), then
   the project itself. If deleting the project needs admin rights you don't have, clear all the issues
   and say so.
4. **Teams** — delete every message in **Workflow test** > **Workflow test**, then the channel **if it
   is not the team's default/General channel** (Teams won't let you delete the default one — if so, just
   clear the messages). **Leave the team `Workflow test` itself** — it is shared with many other
   workflows (WF-138 / WF-206 / WF-236 / WF-239 / WF-297 and more).

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
