# Codex Prompt — WF-206 Cleanup (reset the run, keep the seed)

Two modes. **Mode A** is the one you want almost always: it removes everything the workflow *run*
produced and puts the seed back exactly as it was, so you can re-run WF-206 from a clean slate without
re-seeding. **Mode B** is a full teardown — only use it when you're done with WF-206 entirely.

Paste the mode you want into Codex. **Operate only through the connectors. Do NOT write anything to
the local file system.**

---

## Mode A — Reset to pre-run state (default; keeps the seed re-runnable)

You are cleaning up after a WF-206 input-validation audit run. Delete **only what the run produced**.
The seed data must survive untouched — it is expensive to rebuild and the next run depends on it.

### Do NOT touch (this is the seed)
- The GitHub repo **sahidempiricinfotech-dotcom/express-input-audit** — nothing at all, in any branch.
  The run does not write to the repo; if you find changes there, **stop and report it** rather than
  reverting.
- The Google Sheet **Route Traffic Data** — leave the `routes` tab completely alone. The run
  only reads it.
- The **Jira IVA project itself**, its seven components (`gateway-team`, `orders-team`,
  `orders-web-team`, `orders-routes-team`, `uploads-team`, `admin-team`, `platform-team`), and these
  **three seeded tickets**:
  - `Unvalidated input in POST /api/v1/uploads/document` (open)
  - `Unvalidated input in POST /api/v1/orders/create` (open)
  - `Unvalidated input in GET /api/v1/search` (closed)
- The Teams team **Workflow test** and the channel **input validation audit** themselves.
- The Drive folder **Engineering / Input Validation**.

### 1) Jira — project `IVA`
- Find every ticket in IVA. The run creates one ticket **per route** titled
  `Unvalidated input in <METHOD> <mounted path>`.
- **Delete every IVA ticket except the three seeded ones listed above.** Match the seeded ones by
  their exact summary — if you seeded them and recorded the keys, match on key instead, which is safer.
- The two **open** seeded tickets were *updated in place* by the run (the run refreshes the score,
  verdict, line number and description rather than duplicating). **Restore them to their stale
  "previous run" state**: put back the old description and score, set the `uploads/document` ticket
  back to **To Do** and the `orders/create` ticket back to **In Progress**, and remove any comment,
  label, or link the run added. Do not delete these two.
- Leave the closed `GET /api/v1/search` ticket exactly as it is.
- **Before deleting anything, list what you are about to delete and what you are keeping**, and
  confirm the count of survivors is exactly 3.

### 2) Google Sheet — "Input Validation Coverage Map"
- Keep the header row (all 20 columns) exactly as-is.
- **Delete every data row except the four seeded prior rows**, which are keyed on
  method + mounted path + field path:
  1. `POST` / `/api/v1/uploads/document` / `file.originalname`
  2. `POST` / `/api/v1/orders/create` / `body.couponCode`
  3. `GET` / `/api/v1/orders/:orderId` / `params.orderId`
  4. `POST` / `/api/v1/legacy/checkout` / `body.cardToken`
- Those four rows were **upserted** by the run, so restore their seeded values:
  - All four: `last reviewed` back to **2026-05-20** (rows 1–3) and **2026-04-02** (row 4); restore the
    stale exploitability score, coverage verdict, OWASP category and Jira link from the seed; clear
    anything the run added to `score breakdown`, `weak reason`, `middleware chain`, `confidence`,
    `traffic per hour`.
  - Row 1: `owner` = **uploads-team**, `status` = **In Progress**.
  - Row 2: `owner` = **orders-team**, `status` = **Accepted Risk**.
  - Row 3: `owner` and `status` back to **empty**.
  - Row 4: `status` back to **Open** — the run will have flipped it to **Resolved** with the run date,
    because `/api/v1/legacy/checkout` doesn't exist in the code. That flip is the thing being tested,
    so it has to be undone for the next run to test it again.
- Do not delete the sheet and recreate it — the URL is wired into the workflow prompt.

### 3) Microsoft Teams — `Workflow test` > `input validation audit`
- Delete the audit summary message the run posted (the one with the input counts, zero-validation
  percentage, OWASP category counts, and top-10 table). Delete any follow-ups or thread replies under
  it.
- Leave the channel itself in place.

### 4) Report back
State exactly: how many IVA tickets you deleted and how many survived (must be 3), that the two open
seeded tickets are back to their stale state, how many coverage-map rows you deleted and that the four
seeded rows are restored to their seeded values, and whether the Teams message was found and deleted.
If the run left anything you couldn't classify as seed-or-output, **name it and leave it alone**
rather than guessing.

---

## Mode B — Full teardown (only when you're finished with WF-206)

Delete everything WF-206 created, seed included. This is destructive and there is no undo — the repo
and the sheets take a full seed run to rebuild. Confirm that's what you want before running it.

1. **GitHub** — delete the repo **sahidempiricinfotech-dotcom/express-input-audit** entirely.
2. **Google Drive** — delete both Sheets (**Route Traffic Data**, **Input Validation Coverage
   Map**) and then the folder **Engineering / Input Validation** if it is now empty. If the folder
   holds anything you didn't create, leave the folder and say what's in it.
3. **Jira** — delete every ticket in project **IVA**, then the seven components, then the project. If
   deleting the project needs admin rights you don't have, delete all the tickets and say so.
4. **Teams** — delete every message in **Workflow test** > **input validation audit**, then the
   channel. **Leave the team `Workflow test` itself** — it's shared with WF-092 / WF-109 / WF-138 /
   WF-200.

Before you delete anything, **list every item you're about to remove and wait for confirmation**.
Report what was deleted and what you couldn't (with the reason). Do not create any local files.
